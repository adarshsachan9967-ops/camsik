import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../constants/app_keys.dart';
import '../utils/api_sanitizer.dart';
import '../utils/logger.dart';
import '../utils/session_manager.dart';
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

          // Failover from unreachable local dev server to production server
          if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
            final uriStr = e.requestOptions.uri.toString();
            if (uriStr.contains("127.0.0.1:4028") || uriStr.contains("localhost:4028") || uriStr.contains("10.0.2.2:4028")) {
              try {
                appLog("🔄 Unreachable local server, auto-failing over to production: https://casmik-one.vercel.app");
                final retryOptions = e.requestOptions;
                final newUri = uriStr
                    .replaceAll("http://127.0.0.1:4028", "https://casmik-one.vercel.app")
                    .replaceAll("http://localhost:4028", "https://casmik-one.vercel.app")
                    .replaceAll("http://10.0.2.2:4028", "https://casmik-one.vercel.app");
                retryOptions.path = newUri;
                final res = await dio.fetch(retryOptions);
                return handler.resolve(res);
              } catch (failoverErr) {
                appLog("❌ Failover to production failed: $failoverErr");
              }
            }
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

  // ── IN-MEMORY CACHES FOR QUICK INITIAL RENDERING ──
  static List<Map<String, dynamic>> cachedBanners = [];
  static List<Map<String, dynamic>> cachedCategories = [];
  static List<Map<String, dynamic>> cachedRefurbished = [];
  static List<Map<String, dynamic>> cachedRentalCameras = [];
  static List<Map<String, dynamic>> cachedLenses = [];

  // ── IMAGE & DATA SANITIZATION ──
  static String cleanImagePath(dynamic path, {String? categoryId}) =>
      ApiSanitizer.cleanImagePath(path, categoryId: categoryId);

  // ── AUTHENTICATION API ──
  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final res = await dio.post(ApiConstants.login, data: {
        'identifier': identifier.trim(),
        'password': password.trim(),
      });
      if (res.data is Map) {
        return Map<String, dynamic>.from(res.data as Map);
      }
    } catch (e) {
      appLog("Login network error: $e");
    }
    return {'success': false, 'message': 'Login request failed'};
  }

  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post(ApiConstants.register, data: {
        'name': name.trim(),
        'phone': phone.trim().replaceAll(RegExp(r'\D'), ''),
        'email': email.trim(),
        'password': password.trim(),
        'role': 'user',
      });
      if (res.data is Map) {
        return Map<String, dynamic>.from(res.data as Map);
      }
    } catch (e) {
      appLog("Registration network error: $e");
    }
    return {'success': false, 'message': 'Registration request failed'};
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

  // ── BRANDS, MODELS & QUESTIONS ──
  static Future<List<Map<String, dynamic>>> fetchBrands({String? categoryId, String? search}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') queryParams['categoryId'] = categoryId;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final res = await dio.get(ApiConstants.brands, queryParameters: queryParams);
      if (res.data != null && res.data['brands'] is List) {
        final list = (res.data['brands'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return const [];
  }

  static Future<List<Map<String, dynamic>>> fetchModels({String? categoryId, String? brandId, String? search}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') queryParams['categoryId'] = categoryId;
      if (brandId != null && brandId.isNotEmpty && brandId != 'all') queryParams['brandId'] = brandId;
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
    return const [];
  }

  static Future<List<Map<String, dynamic>>> fetchQuestions({required String categoryId}) async {
    try {
      final res = await dio.get(ApiConstants.questions, queryParameters: {'categoryId': categoryId});
      if (res.data != null && res.data['questions'] is List) {
        final list = (res.data['questions'] as List)
            .whereType<Map>()
            .map((e) {
              final q = Map<String, dynamic>.from(e);
              if (q['options'] is List) {
                q['options'] = (q['options'] as List).whereType<Map>().map((o) {
                  final opt = Map<String, dynamic>.from(o);
                  if (!opt.containsKey('desc') && opt.containsKey('sublabel')) {
                    opt['desc'] = opt['sublabel'];
                  }
                  return opt;
                }).toList();
              }
              return q;
            })
            .toList();
        if (list.isNotEmpty) return list;
      }
    } catch (e) {
      appLog("⚠️ Failed to fetch questions from API: $e");
    }
    return const [];
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

  // ── CAMERA LENSES ──
  static Future<List<Map<String, dynamic>>> fetchLenses() async {
    try {
      final res = await dio.get(ApiConstants.lenses);
      if (res.data != null && res.data['lenses'] is List) {
        final list = (res.data['lenses'] as List)
            .cast<Map<String, dynamic>>()
            .where((l) => l['active'] != false)
            .toList();
        if (list.isNotEmpty) {
          cachedLenses = list;
          return list;
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch lenses from API: $e');
    }
    return cachedLenses;
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
        return Map<String, dynamic>.from(res.data['order'] as Map);
      }
    } catch (e) {
      appLog("⚠️ ApiService createOrder error: $e");
    }
    return null;
  }

  // ── USER PROFILE & PAYOUT SYNC ──
  static Future<Map<String, dynamic>?> updateUserProfile({
    required String phone,
    String? name,
    String? email,
    String? address,
    String? upiId,
    String? bankAccount,
  }) async {
    try {
      final res = await dio.put(ApiConstants.updateProfile, data: {
        'phone': phone.trim(),
        if (name != null) 'name': name.trim(),
        if (email != null) 'email': email.trim(),
        if (address != null) 'address': address.trim(),
        if (upiId != null) 'upiId': upiId.trim(),
        if (bankAccount != null) 'bankAccount': bankAccount.trim(),
      });
      if (res.data != null && res.data['success'] == true) {
        appLog("✅ User profile synced with server successfully");
        return Map<String, dynamic>.from(res.data['user'] as Map);
      }
    } catch (e) {
      appLog("⚠️ Profile sync network error: $e");
    }
    return null;
  }

  static Future<Map<String, dynamic>?> fetchUserProfile(String phone) async {
    try {
      final res = await dio.get(ApiConstants.updateProfile, queryParameters: {'phone': phone.trim()});
      if (res.data != null && res.data['success'] == true && res.data['user'] != null) {
        return Map<String, dynamic>.from(res.data['user'] as Map);
      }
    } catch (e) {
      appLog("⚠️ Fetch profile error: $e");
    }
    return null;
  }

  // ── ORDER LIFECYCLE (CANCEL & RESCHEDULE) ──
  static Future<bool> cancelOrder({
    required String orderId,
    String? reason,
  }) async {
    try {
      final res = await dio.patch(ApiConstants.updateOrder, data: {
        'orderId': orderId,
        'status': 'Cancelled',
        'cancellationReason': reason ?? 'Cancelled by user',
      });
      return res.data != null && res.data['success'] == true;
    } catch (e) {
      appLog("❌ Cancel order error: $e");
      return false;
    }
  }

  static Future<bool> rescheduleOrder({
    required String orderId,
    required String newDate,
    required String newSlot,
  }) async {
    try {
      final res = await dio.patch(ApiConstants.updateOrder, data: {
        'orderId': orderId,
        'pickupDate': newDate,
        'pickupSlot': newSlot,
      });
      return res.data != null && res.data['success'] == true;
    } catch (e) {
      appLog("❌ Reschedule order error: $e");
      return false;
    }
  }

  // ── CITIES & SERVICEABILITY ──
  static Future<List<Map<String, dynamic>>> fetchCities() async {
    try {
      final res = await dio.get(ApiConstants.cities);
      if (res.data != null && res.data['cities'] is List) {
        return (res.data['cities'] as List).cast<Map<String, dynamic>>();
      }
    } catch (e) {
      appLog("⚠️ Fetch cities error: $e");
    }
    return [];
  }

  static Future<Map<String, dynamic>> checkPincodeServiceability(String pincode) async {
    try {
      final res = await dio.get(ApiConstants.pincodes, queryParameters: {'pincode': pincode.trim()});
      if (res.data != null && res.data is Map) {
        return Map<String, dynamic>.from(res.data as Map);
      }
    } catch (e) {
      // Fallback to cities endpoint
      try {
        final res = await dio.get(ApiConstants.cities, queryParameters: {'pincode': pincode.trim()});
        if (res.data != null && res.data is Map) {
          return Map<String, dynamic>.from(res.data as Map);
        }
      } catch (_) {}
      appLog("⚠️ Pincode check error: $e");
    }
    return {'success': true, 'serviceable': false, 'pincode': pincode};
  }

  // ── NOTIFICATIONS ──
  static Future<List<Map<String, dynamic>>> fetchNotifications({String? phone}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (phone != null && phone.isNotEmpty) queryParams['phone'] = phone;
      final res = await dio.get(ApiConstants.notifications, queryParameters: queryParams);
      if (res.data != null && res.data['notifications'] is List) {
        return (res.data['notifications'] as List).cast<Map<String, dynamic>>();
      }
    } catch (e) {
      appLog("⚠️ Fetch notifications error: $e");
    }
    return [];
  }

  static Future<void> markNotificationAsRead(String id) async {
    try {
      await dio.post(ApiConstants.notifications, data: {
        'action': 'mark_read',
        'id': id,
      });
    } catch (e) {
      appLog("⚠️ Mark notification read error: $e");
    }
  }

  // ── OTP AUTHENTICATION ──
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final res = await dio.post(ApiConstants.sendOtp, data: {'phone': phone.trim()});
      if (res.data != null && res.data is Map) {
        return Map<String, dynamic>.from(res.data as Map);
      }
    } catch (e) {
      appLog("⚠️ Send OTP error: $e");
    }
    return {'success': true, 'message': 'OTP sent to mobile'};
  }

  static Future<Map<String, dynamic>> verifyOtp({required String phone, required String otp}) async {
    try {
      final res = await dio.post(ApiConstants.verifyOtp, data: {
        'phone': phone.trim(),
        'otp': otp.trim(),
      });
      if (res.data != null && res.data is Map) {
        return Map<String, dynamic>.from(res.data as Map);
      }
    } catch (e) {
      appLog("⚠️ Verify OTP error: $e");
    }
    return {'success': false, 'message': 'Invalid OTP'};
  }
}
