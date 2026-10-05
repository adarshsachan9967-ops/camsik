import 'dart:async';
import 'package:dio/dio.dart';
import '../../models/partner_models.dart';
import '../constants/api_constants.dart';
import '../constants/app_keys.dart';
import '../utils/logger.dart';
import '../utils/session_manager.dart';
import 'network_exceptions.dart';
import 'storage_service.dart';

class ApiService {
  static late final Dio dio;

  static void init() {

    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final startTime = DateTime.now();
          options.extra['startTime'] = startTime;

          final prefs = await SharedPreferencesService.getInstance();
          final token = prefs.getString(AppKeys.accessToken);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            appLog("🔐 Bearer Token attached");
          }

          dynamic dataToLog = options.data;
          if (options.data is FormData) {
            final formData = options.data as FormData;
            final fieldsMap = Map.fromEntries(formData.fields);
            final filesMap = Map.fromEntries(
              formData.files.map((f) => MapEntry(f.key, f.value.filename ?? 'File')),
            );
            dataToLog = {
              if (fieldsMap.isNotEmpty) 'fields': fieldsMap,
              if (filesMap.isNotEmpty) 'files': filesMap,
            };
          }

          appLog("📤 REQUEST → ${options.method} ${options.uri}");
          appLog("🔸 Headers: ${options.headers}");
          appLog("🔸 Data: $dataToLog");
          appLog("⏱️ Started at: $startTime");

          return handler.next(options);
        },
        onResponse: (response, handler) {
          final startTime = response.requestOptions.extra['startTime'] as DateTime?;
          final duration = startTime != null ? DateTime.now().difference(startTime) : null;
          appLog("✅ RESPONSE ← ${response.statusCode} ${response.requestOptions.uri}");
          appLog("📦 Response Data: ${response.data}");
          if (duration != null) {
            appLog("⏳ API Duration: ${duration.inMilliseconds} ms (${duration.inSeconds}s)");
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          final startTime = e.requestOptions.extra['startTime'] as DateTime?;
          final duration = startTime != null ? DateTime.now().difference(startTime) : null;

          appLog("❌ ERROR ← ${e.response?.statusCode} ${e.requestOptions.uri}");
          if (duration != null) {
            appLog("⏱️ API failed after: ${duration.inMilliseconds} ms (${duration.inSeconds}s)");
          }

          if (e.response?.statusCode == 401) {
            if (e.requestOptions.path.contains('/auth/refresh-token')) {
              appLog("🚨 Refresh token endpoint returned 401 - forcing logout");
              await SessionManager.forceLogout();
              return handler.next(e);
            }

            final prefs = await SharedPreferencesService.getInstance();
            final storedRefreshToken = prefs.getString(AppKeys.refreshToken);

            if (storedRefreshToken != null && storedRefreshToken.isNotEmpty) {
              appLog("🔄 401 Unauthorized received. Attempting token refresh...");
              try {
                final refreshDio = Dio(
                  BaseOptions(
                    connectTimeout: const Duration(seconds: 15),
                    receiveTimeout: const Duration(seconds: 15),
                    headers: {"Accept": "application/json", "Content-Type": "application/json"},
                  ),
                );

                final refreshResponse = await refreshDio.post(
                  ApiConstants.refreshToken,
                  data: {"token": storedRefreshToken},
                );

                if (refreshResponse.statusCode == 200 &&
                    refreshResponse.data != null &&
                    refreshResponse.data['success'] == true) {
                  final newAccessToken = refreshResponse.data['data']?['accessToken'];
                  if (newAccessToken != null && newAccessToken is String && newAccessToken.isNotEmpty) {
                    appLog("✅ Access token refreshed successfully! Retrying request...");
                    await prefs.setString(AppKeys.accessToken, newAccessToken);

                    final retryOptions = e.requestOptions;
                    retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                    final response = await dio.fetch(retryOptions);
                return handler.resolve(response);
                  }
                }
              } catch (refreshErr) {
                appLog("❌ Refresh token call failed: $refreshErr");
            }
          }

            appLog("🚨 401 Unauthorized & refresh token unavailable/expired - forcing logout");
            await SessionManager.forceLogout();
            return handler.next(e);
          }

          if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
            appLog("⚠️ Timeout: The API took too long to respond.");
            try {
              appLog("🔁 Retrying request once due to timeout...");
              final retryOptions = e.requestOptions;
              retryOptions.connectTimeout = const Duration(seconds: 30);
              retryOptions.receiveTimeout = const Duration(seconds: 30);

              final response = await dio.fetch(retryOptions);
              appLog("✅ Retry succeeded with status ${response.statusCode}");
              return handler.resolve(response);
            } catch (retryError) {
              appLog("❌ Retry failed too: $retryError");
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  // ── AUTHENTICATION ──

  static Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final res = await dio.post(
        ApiConstants.login,
        data: {
          'identifier': identifier.trim(),
          'password': password.trim(),
          'role': 'partner',
        },
      );

      if (res.data != null && res.data['success'] == true) {
        final partnerData = res.data['partner'] ?? res.data['user'];
        return {
          'success': true,
          'partner': PartnerUser.fromJson(Map<String, dynamic>.from(partnerData)),
          'message': res.data['message'] ?? 'Logged in successfully',
        };
      }

      return {
        'success': false,
        'message': res.data?['message'] ?? 'Invalid partner credentials.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': NetworkExceptions.getErrorMessage(e),
      };
    }
  }

  // ── ORDERS ──
  static Future<List<PartnerOrder>> fetchOrders({
    String? partnerId,
    String? status,
    String? type,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (partnerId != null && partnerId.isNotEmpty) queryParams['partnerId'] = partnerId;
      if (status != null && status.isNotEmpty && status != 'all') queryParams['status'] = status;
      if (type != null && type.isNotEmpty && type != 'all') queryParams['type'] = type;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final res = await dio.get(ApiConstants.orders, queryParameters: queryParams);
      if (res.data != null && res.data['success'] == true && res.data['orders'] is List) {
        return (res.data['orders'] as List)
            .map((item) => PartnerOrder.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<bool> updateOrder({
    required String orderId,
    required String status,
    double? finalPrice,
    int? inspectionScore,
    String? notes,
  }) async {
    try {
      final payload = <String, dynamic>{
        'orderId': orderId,
        'status': status,
      };
      if (finalPrice != null) payload['finalPrice'] = finalPrice;
      if (inspectionScore != null) payload['inspectionScore'] = inspectionScore;
      if (notes != null) payload['notes'] = notes;

      final res = await dio.patch(ApiConstants.orders, data: payload);
      return res.data != null && res.data['success'] == true;
    } catch (_) {
      return false;
    }
  }

  // ── PARTNER PROFILE ──
  static Future<bool> updatePartnerProfile(String partnerId, Map<String, dynamic> updates) async {
    try {
      final payload = {'id': partnerId, ...updates};
      final res = await dio.patch(ApiConstants.partners, data: payload);
      return res.data != null && res.data['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
