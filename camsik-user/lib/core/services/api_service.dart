import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../data/fallback/fallback_banners.dart';
import '../../data/fallback/fallback_categories.dart';
import '../../data/fallback/fallback_models.dart';
import '../../data/fallback/fallback_questions.dart';
import '../../data/fallback/fallback_refurbished.dart';
import '../../data/fallback/fallback_rental_cameras.dart';
import '../constants/api_constants.dart';
import '../constants/app_keys.dart';
import '../utils/api_sanitizer.dart';
import '../utils/logger.dart';
import '../utils/session_manager.dart';
import 'session_service.dart';
import 'storage_service.dart';

class ApiService {
  // ── DIO INSTANCE WITH EMBEDDED INTERCEPTORS ──
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
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

  // ── IN-MEMORY CACHES FOR 0ms UI RENDERING ──
  static List<Map<String, dynamic>> cachedBanners = List<Map<String, dynamic>>.from(FallbackBanners.data);
  static List<Map<String, dynamic>> cachedCategories = List<Map<String, dynamic>>.from(FallbackCategories.data);
  static List<Map<String, dynamic>> cachedRefurbished = List<Map<String, dynamic>>.from(FallbackRefurbished.data);
  static List<Map<String, dynamic>> cachedRentalCameras = List<Map<String, dynamic>>.from(FallbackRentalCameras.data);

  // ── IMAGE & DATA SANITIZATION ──
  static String cleanImagePath(dynamic path, {String? categoryId}) =>
      ApiSanitizer.cleanImagePath(path, categoryId: categoryId);

  // ── AUTHENTICATION API ──
  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final cleanId = identifier.trim();
    try {
      final res = await dio.post(ApiConstants.login, data: {'identifier': cleanId, 'password': password.trim()});
      if (res.data != null && res.data is Map) {
        final mapRes = Map<String, dynamic>.from(res.data as Map);
        if (mapRes['success'] == true) {
          if (mapRes['user'] != null && mapRes['user'] is Map) {
            final u = Map<String, dynamic>.from(mapRes['user'] as Map);
            await SessionService.saveLocalAccount(
              phone: u['phone']?.toString() ?? cleanId,
              password: password.trim(),
              name: u['name']?.toString() ?? 'Camsik Customer',
              email: u['email']?.toString() ?? '',
            );
          }
          if (mapRes['token'] != null) {
            final prefs = await SharedPreferencesService.getInstance();
            await prefs.setString(AppKeys.accessToken, mapRes['token'].toString());
          }
          return mapRes;
        }
      }
    } catch (e) {
      appLog("Login network attempt failed: $e");
      String msg = 'Login failed. Please check your credentials.';
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          msg = data['message'].toString();
        } else if (e.response?.statusCode == 401) {
          msg = 'Incorrect password or account not found.';
        }
      }
      /*
      // --- Offline / Demo Fallback (Commented Out) ---
      final localAccount = SessionService.verifyLocalAccount(identifier: cleanId, password: password.trim());
      if (localAccount != null) {
        return {
          'success': true,
          'token': 'camsik-local-jwt-${DateTime.now().millisecondsSinceEpoch}',
          'user': {'id': 'usr-local', 'phone': localAccount['phone'], 'name': localAccount['name'], 'email': localAccount['email'], 'role': 'user'},
        };
      }
      if (cleanId == '9876543210' || cleanId.toLowerCase() == 'test@camsik.in') {
        return {
          'success': true,
          'token': 'camsik-default-jwt-${DateTime.now().millisecondsSinceEpoch}',
          'user': {'id': 'usr-default', 'phone': '9876543210', 'name': 'Rahul Sharma', 'email': 'rahul.s@camsik.in', 'role': 'user'},
        };
      }
      */
      return {'success': false, 'message': msg};
    }
    return {'success': false, 'message': 'Invalid credentials. If new, please switch to Create Account.'};
  }

  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final cleanPhone = phone.trim().replaceAll(RegExp(r'\D'), '');
    final cleanEmail = email.trim();
    final cleanName = name.trim();

    try {
      final res = await dio.post(ApiConstants.register, data: {
        'name': cleanName,
        'phone': cleanPhone,
        'email': cleanEmail,
        'password': password.trim(),
        'role': 'user',
      });
      if (res.data != null && res.data is Map) {
        final mapRes = Map<String, dynamic>.from(res.data as Map);
        if (mapRes['success'] == true) {
          await SessionService.saveLocalAccount(
            phone: cleanPhone,
            password: password.trim(),
            name: cleanName,
            email: cleanEmail,
          );
          if (mapRes['token'] != null) {
            final prefs = await SharedPreferencesService.getInstance();
            await prefs.setString(AppKeys.accessToken, mapRes['token'].toString());
          }
          return mapRes;
        }
      }
    } catch (e) {
      appLog("Registration network attempt failed: $e");
      String msg = 'Registration failed. Please try again.';
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          msg = data['message'].toString();
        } else if (e.response?.statusCode == 409) {
          msg = 'Mobile number is already registered. Please sign in.';
        }
      }
      /*
      // --- Offline Local Account Fallback (Commented Out) ---
      await SessionService.saveLocalAccount(
        phone: cleanPhone, password: password.trim(), name: cleanName, email: cleanEmail,
      );
      return {
        'success': true,
        'token': 'camsik-local-jwt-${DateTime.now().millisecondsSinceEpoch}',
        'user': {'id': 'usr-${DateTime.now().millisecondsSinceEpoch}', 'phone': cleanPhone, 'name': cleanName, 'email': cleanEmail, 'role': 'user'},
      };
      */
      return {'success': false, 'message': msg};
    }
    return {'success': false, 'message': 'Registration failed. Please try again.'};
  }

  // ── BACKGROUND SYNC ──
  static Future<void> syncDataInBackground() async {
    try {
      final bannersRes = await dio.get(ApiConstants.banners);
      if (bannersRes.data != null && bannersRes.data['banners'] is List) {
        final list = (bannersRes.data['banners'] as List).cast<Map<String, dynamic>>();
        for (final b in list) {
          b['image'] = cleanImagePath(b['image'], categoryId: b['categoryFilter']?.toString());
        }
        cachedBanners = list;
      }

      final categoriesRes = await dio.get(ApiConstants.categories);
      if (categoriesRes.data != null && categoriesRes.data['categories'] is List) {
        final list = (categoriesRes.data['categories'] as List).cast<Map<String, dynamic>>();
        ApiSanitizer.sanitizeCategories(list);
        cachedCategories = list;
      }

      final refRes = await dio.get(ApiConstants.refurbished);
      if (refRes.data != null && refRes.data['products'] is List) {
        final refList = (refRes.data['products'] as List).cast<Map<String, dynamic>>();
        ApiSanitizer.sanitizeRefurbished(refList);
        cachedRefurbished = refList;
      }

      final rentRes = await dio.get(ApiConstants.rentals);
      if (rentRes.data != null && rentRes.data['cameras'] is List) {
        final rentList = (rentRes.data['cameras'] as List).cast<Map<String, dynamic>>();
        ApiSanitizer.sanitizeRentalCameras(rentList);
        cachedRentalCameras = rentList;
      }
    } catch (e) {
      debugPrint('Background sync note: $e');
    }
  }

  // ── BANNERS & CATEGORIES ──
  static Future<List<Map<String, dynamic>>> fetchBanners() async {
    try {
      final res = await dio.get(ApiConstants.banners);
      if (res.data != null && res.data['banners'] is List) {
        final list = (res.data['banners'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) {
          for (final b in list) {
            b['image'] = cleanImagePath(b['image'], categoryId: b['categoryFilter']?.toString());
          }
          cachedBanners = list;
          return list;
        }
      }
    } catch (_) {}
    return cachedBanners;
  }

  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final res = await dio.get(ApiConstants.categories);
      if (res.data != null && res.data['categories'] is List) {
        final list = (res.data['categories'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) {
          ApiSanitizer.sanitizeCategories(list);
          cachedCategories = list;
          return list;
        }
      }
    } catch (_) {}
    return cachedCategories;
  }

  // ── MODELS & QUESTIONS ──
  static List<Map<String, dynamic>> getFallbackModelsSync({String? categoryId, String? search}) {
    final list = FallbackModels.getModels(categoryId: categoryId, search: search);
    ApiSanitizer.sanitizeModels(list);
    return list;
  }

  static Future<List<Map<String, dynamic>>> fetchModels({String? categoryId, String? search}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') queryParams['categoryId'] = categoryId;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final res = await dio.get(ApiConstants.models, queryParameters: queryParams);
      if (res.data != null && res.data['models'] is List) {
        final list = (res.data['models'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) {
          ApiSanitizer.sanitizeModels(list);
          return list;
        }
      }
    } catch (_) {}
    final fallback = FallbackModels.getModels(categoryId: categoryId, search: search);
    ApiSanitizer.sanitizeModels(fallback);
    return fallback;
  }

  static List<Map<String, dynamic>> getQuestionsSync({required String categoryId}) {
    return FallbackQuestions.getQuestions(categoryId);
  }

  static Future<List<Map<String, dynamic>>> fetchQuestions({required String categoryId}) async {
    try {
      final res = await dio.get(ApiConstants.questions, queryParameters: {'categoryId': categoryId});
      if (res.data != null && res.data['questions'] is List) {
        final list = (res.data['questions'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return FallbackQuestions.getQuestions(categoryId);
  }

  // ── REFURBISHED & RENTALS ──
  static Future<List<Map<String, dynamic>>> fetchRefurbished({String? category, String? condition, String? search}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty && category != 'all') queryParams['category'] = category;
      if (condition != null && condition.isNotEmpty && condition != 'all') queryParams['condition'] = condition;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final res = await dio.get(ApiConstants.refurbished, queryParameters: queryParams);
      if (res.data != null && res.data['products'] is List) {
        final list = (res.data['products'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) {
          ApiSanitizer.sanitizeRefurbished(list);
          cachedRefurbished = list;
          return list;
        }
      }
    } catch (_) {}
    return cachedRefurbished;
  }

  static Future<List<Map<String, dynamic>>> fetchRentalCameras({String? category, String? brand, String? search}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty && category != 'all') queryParams['category'] = category;
      if (brand != null && brand.isNotEmpty && brand != 'all') queryParams['brand'] = brand;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final res = await dio.get(ApiConstants.rentals, queryParameters: queryParams);
      if (res.data != null && res.data['cameras'] is List) {
        final list = (res.data['cameras'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) {
          ApiSanitizer.sanitizeRentalCameras(list);
          cachedRentalCameras = list;
          return list;
        }
      }
    } catch (_) {}
    return cachedRentalCameras;
  }

  // ── ORDERS ──
  static Future<List<Map<String, dynamic>>> fetchOrders({String? phone}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (phone != null && phone.isNotEmpty) queryParams['phone'] = phone;

      final res = await dio.get(ApiConstants.orders, queryParameters: queryParams);
      if (res.data != null && res.data['orders'] is List) {
        return (res.data['orders'] as List).cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  static Future<Map<String, dynamic>?> createOrder(Map<String, dynamic> orderData) async {
    try {
      final res = await dio.post(ApiConstants.createOrder, data: orderData);
      if (res.data != null && res.data['success'] == true && res.data['order'] != null) {
        return res.data['order'] as Map<String, dynamic>;
      }
    } catch (_) {}
    final fallbackOrderNumber =
        'CSM-${orderData['type'] == 'buy' ? 'BUY' : orderData['type'] == 'exchange' ? 'EXC' : orderData['type'] == 'rent' ? 'RNT' : 'SELL'}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    return {
      'id': 'ord-${DateTime.now().millisecondsSinceEpoch}',
      'orderNumber': fallbackOrderNumber,
      'type': orderData['type'] ?? 'sell',
      'status': 'Order Placed',
      'createdAt': DateTime.now().toIso8601String(),
      'customerName': orderData['customerName'] ?? 'Valued Customer',
      'customerPhone': orderData['customerPhone'] ?? '',
      'customerAddress': orderData['customerAddress'] ?? '',
      'city': orderData['city'] ?? 'Mumbai',
      'pincode': orderData['pincode'] ?? '401107',
      'pickupDate': orderData['pickupDate'] ?? 'Tomorrow',
      'pickupSlot': orderData['pickupSlot'] ?? '11:00 AM – 1:00 PM',
      'paymentMethod': orderData['paymentMethod'] ?? 'Instant UPI',
      'amount': orderData['amount'] ?? 0,
      'deviceName': orderData['deviceName'] ?? 'Device',
      'otp': '${1000 + (DateTime.now().millisecondsSinceEpoch % 8999)}',
    };
  }
}
