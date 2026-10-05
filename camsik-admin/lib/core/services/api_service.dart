import 'dart:async';
import 'package:dio/dio.dart';
import '../../models/admin_models.dart';
import '../constants/api_constants.dart';
import '../constants/app_keys.dart';
import '../utils/logger.dart';
import '../utils/session_manager.dart';
import 'network_exceptions.dart';
import 'storage_service.dart';

class ApiService {
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      init();
    }
    return _dio!;
  }

  static set dio(Dio value) => _dio = value;

  static void init() {
    _dio = Dio(
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
          'role': 'admin',
        },
      );

      if (res.data != null && res.data['success'] == true) {
        final userData = res.data['user'] ?? res.data['admin'];
        final token = res.data['token'] ?? res.data['accessToken'];
        final refreshToken = res.data['refreshToken'];

        if (userData != null) {
          final adminUser = AdminUser.fromJson(Map<String, dynamic>.from(userData));
          return {
            'success': true,
            'user': adminUser,
            'token': token,
            'refreshToken': refreshToken,
            'message': res.data['message'] ?? 'Logged in successfully',
          };
        }
      }

      return {
        'success': false,
        'message': res.data?['message'] ?? 'Invalid admin credentials.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': NetworkExceptions.getErrorMessage(e),
      };
    }
  }

  // ── PLATFORM OVERVIEW & ANALYTICS ──
  static Future<Map<String, dynamic>?> fetchOverview() async {
    try {
      final res = await dio.get(ApiConstants.overview);
      if (res.data != null && res.data['success'] == true) {
        return res.data;
      }
    } catch (e) {
      appLog("Error fetching platform overview: $e");
    }
    return null;
  }

  // ── ORDERS MANAGEMENT ──
  static Future<List<AdminOrder>> fetchOrders({
    String? search,
    String? status,
    String? type,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (status != null && status.isNotEmpty && status != 'all') queryParams['status'] = status;
      if (type != null && type.isNotEmpty && type != 'all') queryParams['type'] = type;

      final res = await dio.get(ApiConstants.orders, queryParameters: queryParams);
      if (res.data != null && res.data['success'] == true && res.data['orders'] is List) {
        return (res.data['orders'] as List)
            .map((e) => AdminOrder.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      appLog("Error fetching orders: $e");
    }
    return [];
  }

  static Future<bool> updateOrder({
    required String orderId,
    String? status,
    String? notes,
    String? assignedPartnerId,
    String? assignedPartnerName,
    String? assignedRiderId,
    String? assignedRiderName,
  }) async {
    try {
      final payload = <String, dynamic>{'orderId': orderId};
      if (status != null && status.isNotEmpty) payload['status'] = status;
      if (notes != null && notes.isNotEmpty) payload['notes'] = notes;
      if (assignedPartnerId != null) payload['assignedPartnerId'] = assignedPartnerId;
      if (assignedPartnerName != null) payload['assignedPartnerName'] = assignedPartnerName;
      if (assignedRiderId != null) payload['assignedRiderId'] = assignedRiderId;
      if (assignedRiderName != null) payload['assignedRiderName'] = assignedRiderName;

      final res = await dio.patch(ApiConstants.orders, data: payload);
      return res.data != null && res.data['success'] == true;
    } catch (e) {
      appLog("Error updating order: $e");
      return false;
    }
  }

  // ── PARTNER STORES DIRECTORY ──
  static Future<List<AdminPartner>> fetchPartners({String? city, String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (city != null && city.isNotEmpty) queryParams['city'] = city;
      if (status != null && status.isNotEmpty && status != 'all') queryParams['status'] = status;

      final res = await dio.get(ApiConstants.partners, queryParameters: queryParams);
      if (res.data != null && res.data['success'] == true && res.data['partners'] is List) {
        return (res.data['partners'] as List)
            .map((e) => AdminPartner.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      appLog("Error fetching partners: $e");
    }
    return [];
  }

  static Future<bool> updatePartnerStatus({
    required String partnerId,
    required String status,
  }) async {
    try {
      final res = await dio.patch(
        ApiConstants.partners,
        data: {'id': partnerId, 'status': status},
      );
      return res.data != null && res.data['success'] == true;
    } catch (e) {
      appLog("Error updating partner status: $e");
      return false;
    }
  }

  // ── DELIVERY FLEET & AGENTS ──
  static Future<List<AdminDeliveryAgent>> fetchDeliveryAgents({String? dutyStatus}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (dutyStatus != null && dutyStatus.isNotEmpty && dutyStatus != 'all') {
        queryParams['dutyStatus'] = dutyStatus;
      }

      final res = await dio.get(ApiConstants.deliveryAgents, queryParameters: queryParams);
      if (res.data != null && res.data['success'] == true && res.data['agents'] is List) {
        return (res.data['agents'] as List)
            .map((e) => AdminDeliveryAgent.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      appLog("Error fetching delivery agents: $e");
    }
    return [];
  }

  static Future<bool> updateAgentDutyStatus({
    required String agentId,
    required String dutyStatus,
  }) async {
    try {
      final res = await dio.patch(
        ApiConstants.deliveryAgents,
        data: {'id': agentId, 'dutyStatus': dutyStatus, 'status': dutyStatus},
      );
      return res.data != null && res.data['success'] == true;
    } catch (e) {
      appLog("Error updating agent duty status: $e");
      return false;
    }
  }
}
