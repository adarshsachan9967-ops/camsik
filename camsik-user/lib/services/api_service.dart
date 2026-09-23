import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'session_service.dart';

// Unicode Escape Constants
const String kRupee = '\u20B9';
const String kBullet = '\u2022';

class ApiService {
  static const List<String> _baseUrls = [
    'https://casmik-one.vercel.app', // Production live web backend
    'https://casmik.vercel.app', // Production secondary domain
    'http://10.0.2.2:4028', // Android Emulator to host
    'http://localhost:4028', // Host local
  ];

  static String? _resolvedBaseUrl;

  // Eager in-memory caches populated at startup for 0ms synchronous UI rendering
  static List<Map<String, dynamic>> cachedBanners = _fallbackBanners;
  static List<Map<String, dynamic>> cachedCategories = _fallbackCategories;
  static List<Map<String, dynamic>> cachedRefurbished = _fallbackRefurbished;

  /// Helper to send GET request with auto-discovery and timeout
  static Future<Map<String, dynamic>?> _get(String path) async {
    final client = HttpClient()..connectionTimeout = const Duration(milliseconds: 2500);
    final urlsToTry = _resolvedBaseUrl != null
        ? [_resolvedBaseUrl!, ..._baseUrls.where((u) => u != _resolvedBaseUrl)]
        : _baseUrls;

    for (final base in urlsToTry) {
      try {
        final uri = Uri.parse('$base$path');
        final request = await client.getUrl(uri).timeout(const Duration(milliseconds: 2500));
        request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
        final response = await request.close().timeout(const Duration(milliseconds: 2500));

        if (response.statusCode == 200) {
          final responseBody = await response.transform(utf8.decoder).join();
          _resolvedBaseUrl = base;
          final decoded = jsonDecode(responseBody);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded);
          }
        }
      } catch (_) {}
    }
    client.close();
    return null;
  }

  /// Helper to send POST request
  static Future<Map<String, dynamic>?> _post(String path, Map<String, dynamic> data) async {
    final client = HttpClient()..connectionTimeout = const Duration(milliseconds: 2500);
    final urlsToTry = _resolvedBaseUrl != null
        ? [_resolvedBaseUrl!, ..._baseUrls.where((u) => u != _resolvedBaseUrl)]
        : _baseUrls;

    for (final base in urlsToTry) {
      try {
        final uri = Uri.parse('$base$path');
        final request = await client.postUrl(uri).timeout(const Duration(milliseconds: 2500));
        request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
        request.write(jsonEncode(data));
        final response = await request.close().timeout(const Duration(milliseconds: 2500));

        final responseBody = await response.transform(utf8.decoder).join();
        _resolvedBaseUrl = base;
        try {
          final decoded = jsonDecode(responseBody);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded);
          }
        } catch (_) {
          return {'statusCode': response.statusCode, 'body': responseBody};
        }
      } catch (_) {}
    }
    client.close();
    return null;
  }

  // ── AUTHENTICATION API ──

  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final cleanId = identifier.trim();
    try {
      final res = await _post('/api/auth/login', {
        'identifier': cleanId,
        'password': password.trim(),
      });
      if (res != null) {
        final mapRes = Map<String, dynamic>.from(res);
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
          return mapRes;
        } else if (mapRes['message'] != null && mapRes['message'].toString().toLowerCase().contains('incorrect password')) {
          return mapRes;
        }
      }
    } catch (e) {
      debugPrint('ApiService login network error: $e');
    }

    // Offline / Local verification against registered accounts
    final localCheck = SessionService.verifyLocalAccount(
      identifier: cleanId,
      password: password,
    );
    if (localCheck != null) {
      if (localCheck['error'] == 'INCORRECT_PASSWORD') {
        return {
          'success': false,
          'message': 'Incorrect password. Please enter your valid password.',
        };
      }
      return {
        'success': true,
        'message': 'Logged in successfully',
        'user': Map<String, dynamic>.from(localCheck),
      };
    }

    return {
      'success': false,
      'message': 'Account not found. Please sign up or verify your credentials.',
    };
  }

  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '').trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanName = name.trim();

    // Save locally first so user never loses their credentials
    await SessionService.saveLocalAccount(
      phone: cleanPhone,
      password: password.trim(),
      name: cleanName,
      email: cleanEmail,
    );

    try {
      final res = await _post('/api/auth/signup', {
        'name': cleanName,
        'phone': cleanPhone,
        'email': cleanEmail,
        'password': password.trim(),
      });
      if (res != null) {
        final mapRes = Map<String, dynamic>.from(res);
        if (mapRes['success'] == true) {
          return mapRes;
        }
      }
    } catch (e) {
      debugPrint('ApiService signup network error: $e');
    }

    // Local registration fallback
    return {
      'success': true,
      'message': 'Account created successfully',
      'user': {
        'id': 'usr-${DateTime.now().millisecondsSinceEpoch}',
        'name': cleanName,
        'phone': cleanPhone,
        'email': cleanEmail.isNotEmpty ? cleanEmail : '$cleanPhone@camsik.in',
      },
    };
  }

  // ── SILENT BACKGROUND SYNC ──
  static Future<void> syncDataInBackground() async {
    try {
      final bannersRes = await _get('/api/banners');
      if (bannersRes != null && bannersRes['banners'] is List) {
        cachedBanners = (bannersRes['banners'] as List).cast<Map<String, dynamic>>();
      }

      final catRes = await _get('/api/categories');
      if (catRes != null && catRes['categories'] is List) {
        cachedCategories = (catRes['categories'] as List).cast<Map<String, dynamic>>();
      }

      final refRes = await _get('/api/refurbished');
      if (refRes != null && refRes['products'] is List) {
        cachedRefurbished = (refRes['products'] as List).cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('Background sync note: $e');
    }
  }

  // ── 1. HERO BANNERS ──
  static Future<List<Map<String, dynamic>>> fetchBanners() async {
    try {
      final json = await _get('/api/banners');
      if (json != null && json['banners'] is List) {
        final list = (json['banners'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) {
          cachedBanners = list;
          return list;
        }
      }
    } catch (_) {}
    return cachedBanners;
  }

  // ── 2. CATEGORIES ──
  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final json = await _get('/api/categories');
      if (json != null && json['categories'] is List) {
        final list = (json['categories'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) {
          cachedCategories = list;
          return list;
        }
      }
    } catch (_) {}
    return cachedCategories;
  }

  // ── 3. MODELS & BRANDS ──
  static List<Map<String, dynamic>> getFallbackModelsSync({String? categoryId, String? search}) {
    return _getFallbackModels(categoryId: categoryId, search: search);
  }

  static Future<List<Map<String, dynamic>>> fetchModels({String? categoryId, String? search}) async {
    try {
      var path = '/api/models';
      final params = <String>[];
      if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') params.add('categoryId=$categoryId');
      if (search != null && search.isNotEmpty) params.add('search=${Uri.encodeComponent(search)}');
      if (params.isNotEmpty) path += '?${params.join('&')}';

      final json = await _get(path);
      if (json != null && json['models'] is List) {
        final list = (json['models'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return _getFallbackModels(categoryId: categoryId, search: search);
  }

  // ── 4. QUESTIONS ──
  static List<Map<String, dynamic>> getQuestionsSync({required String categoryId}) {
    return _getFallbackQuestions(categoryId);
  }

  static Future<List<Map<String, dynamic>>> fetchQuestions({required String categoryId}) async {
    try {
      final json = await _get('/api/questions?categoryId=$categoryId');
      if (json != null && json['questions'] is List) {
        final list = (json['questions'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return _getFallbackQuestions(categoryId);
  }

  // ── 5. REFURBISHED CATALOG & UNITS ──
  static Future<List<Map<String, dynamic>>> fetchRefurbished({String? category, String? condition, String? search}) async {
    try {
      var path = '/api/refurbished';
      final params = <String>[];
      if (category != null && category.isNotEmpty && category != 'all') params.add('category=${Uri.encodeComponent(category)}');
      if (condition != null && condition.isNotEmpty && condition != 'all') params.add('condition=${Uri.encodeComponent(condition)}');
      if (search != null && search.isNotEmpty) params.add('search=${Uri.encodeComponent(search)}');
      if (params.isNotEmpty) path += '?${params.join('&')}';

      final json = await _get(path);
      if (json != null && json['products'] is List) {
        final list = (json['products'] as List).cast<Map<String, dynamic>>();
        if (list.isNotEmpty) {
          cachedRefurbished = list;
          return list;
        }
      }
    } catch (_) {}
    return cachedRefurbished;
  }

  // ── 6. ORDERS GET & CREATE ──
  static Future<List<Map<String, dynamic>>> fetchOrders({String? phone}) async {
    try {
      final path = phone != null && phone.isNotEmpty ? '/api/orders?phone=${Uri.encodeComponent(phone)}' : '/api/orders';
      final json = await _get(path);
      if (json != null && json['orders'] is List) {
        return (json['orders'] as List).cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  static Future<Map<String, dynamic>?> createOrder(Map<String, dynamic> orderData) async {
    try {
      final json = await _post('/api/orders', orderData);
      if (json != null && json['success'] == true && json['order'] != null) {
        return json['order'] as Map<String, dynamic>;
      }
    } catch (_) {}
    final fallbackOrderNumber = 'CSM-${orderData['type'] == 'buy' ? 'BUY' : orderData['type'] == 'exchange' ? 'EXC' : 'SELL'}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
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

  // ── COMPREHENSIVE DATASETS MATCHING WEBSITE EXACTLY ──

  static final List<Map<String, dynamic>> _fallbackBanners = [
    {
      'id': 'slide-smartphone',
      'badge': '#1 SMARTPHONE & IPHONE BUYBACK',
      'titlePrefix': 'Sell Used ',
      'titleHighlight': 'Smartphones & iPhones',
      'titleSuffix': ' for Peak Cash',
      'description': 'Guaranteed highest resale payout for Apple iPhone 16/15 Pro, Samsung Galaxy S24, Pixel & OnePlus. 60-second quote & spot UPI.',
      'ctaText': 'Check Phone Price',
      'categoryFilter': 'cat-smartphone',
      'image': 'assets/images/categories/smartphone.png',
      'accentColor': '#38BDF8',
      'bgGradient': [0xFF1E3A8A, 0xFF0F172A],
    },
    {
      'id': 'slide-laptop',
      'badge': 'MAX VALUE FOR LAPTOPS & MACBOOKS',
      'titlePrefix': 'Turn Old ',
      'titleHighlight': 'MacBook & Laptops',
      'titleSuffix': ' Into Cash',
      'description': 'Selling MacBook Pro/Air M3, Dell XPS, HP Spectre & ThinkPads? Fair evaluation, zero hidden fees & free doorstep pickup.',
      'ctaText': 'Sell Old Laptop',
      'categoryFilter': 'cat-laptop',
      'image': 'assets/images/categories/laptop.png',
      'accentColor': '#A78BFA',
      'bgGradient': [0xFF4C1D95, 0xFF1E1B4B],
    },
    {
      'id': 'slide-tablet',
      'badge': 'INSTANT CASH FOR IPADS & TABLETS',
      'titlePrefix': 'Upgrade Your ',
      'titleHighlight': 'iPads & Tablets',
      'titleSuffix': ' Today',
      'description': 'Instant AI valuation for iPad Pro M4, iPad Air, Galaxy Tab S9 & Lenovo tablets. Doorstep testing & instant bank transfer.',
      'ctaText': 'Sell iPad / Tablet',
      'categoryFilter': 'cat-tablet',
      'image': 'assets/images/categories/tablet.png',
      'accentColor': '#22D3EE',
      'bgGradient': [0xFF164E63, 0xFF083344],
    },
    {
      'id': 'slide-dslr',
      'badge': '#1 CAMERA BUYBACK IN INDIA',
      'titlePrefix': 'Sell Used ',
      'titleHighlight': 'DSLR & Mirrorless',
      'titleSuffix': ' Cameras for Instant Cash',
      'description': 'Guaranteed top value for Canon, Nikon, Sony, LUMIX and Fujifilm cameras. AI valuation & spot UPI within minutes.',
      'ctaText': 'Check Camera Price',
      'categoryFilter': 'cat-dslr',
      'image': 'assets/images/categories/dslr.png',
      'accentColor': '#34D399',
      'bgGradient': [0xFF064E3B, 0xFF022C22],
    },
    {
      'id': 'slide-lens',
      'badge': 'TOP VALUATION FOR ALL MOUNTS',
      'titlePrefix': 'Turn Old ',
      'titleHighlight': 'Camera Lenses',
      'titleSuffix': ' Into Instant Money',
      'description': 'Sony G Master, Canon RF/EF, Nikon Z, Sigma Art or Tamron. Spot UPI transfer with zero deductions.',
      'ctaText': 'Sell Camera Lens',
      'categoryFilter': 'cat-lens',
      'image': 'assets/images/categories/lens.png',
      'accentColor': '#60A5FA',
      'bgGradient': [0xFF1E3A8A, 0xFF1E1B4B],
    },
    {
      'id': 'slide-action-video',
      'badge': 'ACTION & 4K CAMCORDERS',
      'titlePrefix': 'Sell 4K Video Cameras, ',
      'titleHighlight': 'GoPro & Gimbals',
      'titleSuffix': '',
      'description': 'GoPro Hero, DJI Osmo Pocket, Insta360 X3 & 3-Axis Gimbals. Fast inspection and certified factory data wipe.',
      'ctaText': 'Sell Video Gear',
      'categoryFilter': 'cat-action-camera',
      'image': 'assets/images/categories/action.png',
      'accentColor': '#2DD4BF',
      'bgGradient': [0xFF064E3B, 0xFF134E4A],
    },
  ];

  static final List<Map<String, dynamic>> _fallbackCategories = [
    {
      'id': 'cat-dslr',
      'name': 'DSLR & Mirrorless',
      'slug': 'sell-old-dslr-camera',
      'icon': '📷',
      'image': 'assets/images/categories/dslr.png',
      'description': 'Sell Canon, Nikon, Sony, LUMIX, Fujifilm cameras for top cash with doorstep pickup.',
      'brandCount': 5,
      'modelCount': 45,
    },
    {
      'id': 'cat-lens',
      'name': 'Camera Lenses',
      'slug': 'sell-old-dslr-mirrorless-lens',
      'icon': '🔍',
      'image': 'assets/images/categories/lens.png',
      'description': 'Instant valuation for prime, zoom, macro, G Master, RF & Z-mount camera lenses.',
      'brandCount': 8,
      'modelCount': 60,
    },
    {
      'id': 'cat-video-camera',
      'name': 'Video Cameras',
      'slug': 'sell-old-video-camera',
      'icon': '📹',
      'image': 'assets/images/categories/video.png',
      'description': 'Sell 4K broadcast camcorders, cinematic cameras from Canon, Sony & Panasonic.',
      'brandCount': 3,
      'modelCount': 20,
    },
    {
      'id': 'cat-action-camera',
      'name': 'Action Cameras',
      'slug': 'sell-old-action-camera',
      'icon': '🎥',
      'image': 'assets/images/categories/action.png',
      'description': 'Get top resale value for GoPro Hero, DJI Osmo Pocket & Insta360 cameras.',
      'brandCount': 3,
      'modelCount': 25,
    },
    {
      'id': 'cat-gimbal',
      'name': 'Gimbals & Stabilizers',
      'slug': 'sell-old-gimbal',
      'icon': '🕹️',
      'image': 'assets/images/categories/gimbal.png',
      'description': 'Turn your DJI Ronin, Zhiyun Crane & FeiyuTech 3-axis gimbals into instant money.',
      'brandCount': 3,
      'modelCount': 18,
    },
    {
      'id': 'cat-smartphone',
      'name': 'Smartphones',
      'slug': 'sell-old-smartphones',
      'icon': '📱',
      'image': 'assets/images/categories/smartphone.png',
      'description': 'Sell Apple iPhone, Samsung Galaxy, Google Pixel & OnePlus for instant doorstep cash.',
      'brandCount': 5,
      'modelCount': 35,
    },
    {
      'id': 'cat-laptop',
      'name': 'Laptops',
      'slug': 'sell-old-laptops',
      'icon': '💻',
      'image': 'assets/images/categories/laptop.png',
      'description': 'Instant quote for Apple MacBook Pro/Air, Dell XPS, HP Spectre & Lenovo ThinkPad.',
      'brandCount': 5,
      'modelCount': 25,
    },
    {
      'id': 'cat-tablet',
      'name': 'Tablets & iPads',
      'slug': 'sell-old-tablets',
      'icon': '📟',
      'image': 'assets/images/categories/tablet.png',
      'description': 'Top resale value for Apple iPad Pro, iPad Air, Samsung Galaxy Tab & Lenovo Tablets.',
      'brandCount': 4,
      'modelCount': 20,
    },
  ];

  static List<Map<String, dynamic>> _getFallbackModels({String? categoryId, String? search}) {
    final allModels = [
      // ── DSLR & Mirrorless Cameras ──
      {
        'id': 'cam-canon-rp',
        'categoryId': 'cat-dslr',
        'brand': 'Canon',
        'name': 'Canon EOS RP',
        'image': 'assets/images/refurbished/canon-eos-rp.jpg',
        'basePrice': 58000,
        'storages': ['Body Only', 'Kit 24-105mm'],
        'colors': ['Black'],
        'specs': '26.2 MP Full-Frame CMOS, Dual Pixel AF, 4K 24p',
      },
      {
        'id': 'cam-canon-eos-r',
        'categoryId': 'cat-dslr',
        'brand': 'Canon',
        'name': 'Canon EOS R',
        'image': 'assets/images/refurbished/canon-eos-r.webp',
        'basePrice': 78000,
        'storages': ['Body Only', 'Kit 24-105mm USM'],
        'colors': ['Black'],
        'specs': '30.3 MP Full-Frame, Dual Pixel CMOS AF, 4K C-Log',
      },
      {
        'id': 'cam-sony-a7',
        'categoryId': 'cat-dslr',
        'brand': 'Sony',
        'name': 'Sony Alpha A7',
        'image': 'assets/images/refurbished/sony-a7.jpg',
        'basePrice': 38000,
        'storages': ['Body Only', 'Kit 28-70mm'],
        'colors': ['Black'],
        'specs': '24.3 MP Exmor CMOS, Full HD 60p, E-Mount',
      },
      {
        'id': 'cam-sony-a7ii',
        'categoryId': 'cat-dslr',
        'brand': 'Sony',
        'name': 'Sony Alpha A7 II',
        'image': 'assets/images/refurbished/sony-a7.jpg',
        'basePrice': 52000,
        'storages': ['Body Only', 'Kit 28-70mm'],
        'colors': ['Black'],
        'specs': '24.3 MP Full-Frame, 5-Axis IBIS, Fast Hybrid AF',
      },
      {
        'id': 'cam-sony-a7iii',
        'categoryId': 'cat-dslr',
        'brand': 'Sony',
        'name': 'Sony Alpha A7 III',
        'image': 'assets/images/refurbished/sony-a7.jpg',
        'basePrice': 85000,
        'storages': ['Body Only', 'Kit 28-70mm'],
        'colors': ['Black'],
        'specs': '24.2 MP BSI Sensor, 4K HDR, 693 AF Points',
      },
      {
        'id': 'cam-nikon-z50',
        'categoryId': 'cat-dslr',
        'brand': 'Nikon',
        'name': 'Nikon Z50',
        'image': 'assets/images/refurbished/nikon-z50ii.png',
        'basePrice': 48000,
        'storages': ['Body Only', 'Kit 16-50mm'],
        'colors': ['Black'],
        'specs': '20.9 MP DX CMOS, Eye-Detection AF, 4K UHD 30p',
      },
      {
        'id': 'cam-nikon-z50ii',
        'categoryId': 'cat-dslr',
        'brand': 'Nikon',
        'name': 'Nikon Z50 II',
        'image': 'assets/images/refurbished/nikon-z50ii.png',
        'basePrice': 62000,
        'storages': ['Body Only', 'Kit 16-50mm', 'Dual Lens Kit'],
        'colors': ['Black'],
        'specs': '20.9 MP DX Sensor, EXPEED 7 Engine, AI Subject Tracking',
      },
      {
        'id': 'cam-nikon-z30',
        'categoryId': 'cat-dslr',
        'brand': 'Nikon',
        'name': 'Nikon Z30',
        'image': 'assets/images/refurbished/nikon-z50ii.png',
        'basePrice': 42000,
        'storages': ['Body Only', 'Kit 16-50mm', 'Vlogger Kit'],
        'colors': ['Black'],
        'specs': '20.9 MP DX Sensor, Vari-angle Screen, Uncropped 4K',
      },
      {
        'id': 'cam-fujifilm-xt5',
        'categoryId': 'cat-dslr',
        'brand': 'Fujifilm',
        'name': 'Fujifilm X-T5',
        'image': 'assets/images/refurbished/fujifilm-xt5.jpg',
        'basePrice': 95000,
        'storages': ['Body Only', 'Kit 18-55mm'],
        'colors': ['Black', 'Silver'],
        'specs': '40.2 MP X-Trans CMOS 5 HR, 6.2K 30p, IBIS',
      },
      // ── Camera Lenses ──
      {
        'id': 'lens-sony-1635gm',
        'categoryId': 'cat-lens',
        'brand': 'Sony',
        'name': 'Sony FE 16-35mm F2.8 GM',
        'image': 'assets/images/refurbished/sony-1635gm.jpg',
        'basePrice': 85000,
        'storages': ['E-Mount Full Frame'],
        'colors': ['Black'],
        'specs': 'F2.8 Constant Aperture, Direct Drive SSM, Nano AR',
      },
      {
        'id': 'lens-canon-rf-24105',
        'categoryId': 'cat-lens',
        'brand': 'Canon',
        'name': 'Canon RF 24-105mm F4 L IS USM',
        'image': 'assets/images/categories/lens.png',
        'basePrice': 68000,
        'storages': ['RF Mount Full Frame'],
        'colors': ['Black'],
        'specs': 'F4 Constant Aperture, 5-Stop Image Stabilization, Nano USM',
      },
      {
        'id': 'lens-nikon-z-2470',
        'categoryId': 'cat-lens',
        'brand': 'Nikon',
        'name': 'Nikon NIKKOR Z 24-70mm F2.8 S',
        'image': 'assets/images/categories/lens.png',
        'basePrice': 92000,
        'storages': ['Z Mount Full Frame'],
        'colors': ['Black'],
        'specs': 'F2.8 Constant, Multi-Focus System, ARNEO & Nano Crystal',
      },
      // ── Video Cameras ──
      {
        'id': 'vid-sony-fx3',
        'categoryId': 'cat-video-camera',
        'brand': 'Sony',
        'name': 'Sony FX3 Cinema Line',
        'image': 'assets/images/categories/video.png',
        'basePrice': 195000,
        'storages': ['Body Only', 'With XLR Handle'],
        'colors': ['Black'],
        'specs': '12.1 MP Full-Frame Exmor R, 4K 120p, S-Cinetone, Active Cooling',
      },
      {
        'id': 'vid-canon-c70',
        'categoryId': 'cat-video-camera',
        'brand': 'Canon',
        'name': 'Canon Cinema EOS C70',
        'image': 'assets/images/categories/video.png',
        'basePrice': 210000,
        'storages': ['Body with Handle'],
        'colors': ['Black'],
        'specs': 'Super 35mm DGO Sensor, 4K 120p, Dual SD Slots, RF Mount',
      },
      // ── Action Cameras ──
      {
        'id': 'act-gopro-hero12',
        'categoryId': 'cat-action-camera',
        'brand': 'GoPro',
        'name': 'GoPro HERO12 Black',
        'image': 'assets/images/categories/action.png',
        'basePrice': 28000,
        'storages': ['Standard Pack', 'Creator Edition'],
        'colors': ['Black with Blue Flecks'],
        'specs': '5.3K 60p, HyperSmooth 6.0, HDR Video, Dual LCD Screens',
      },
      {
        'id': 'act-dji-action4',
        'categoryId': 'cat-action-camera',
        'brand': 'DJI',
        'name': 'DJI Osmo Action 4',
        'image': 'assets/images/categories/action.png',
        'basePrice': 26000,
        'storages': ['Standard Combo', 'Adventure Combo'],
        'colors': ['Dark Gray'],
        'specs': '1/1.3" Sensor, 4K 120fps, 10-bit D-Log M, 18m Waterproof',
      },
      {
        'id': 'act-insta360-x3',
        'categoryId': 'cat-action-camera',
        'brand': 'Insta360',
        'name': 'Insta360 X3 360° Action',
        'image': 'assets/images/categories/action.png',
        'basePrice': 29000,
        'storages': ['Standalone', 'Get-Set Kit'],
        'colors': ['Black'],
        'specs': '5.7K 360 Active HDR, 72MP 360 Photos, 2.29" Touchscreen',
      },
      // ── Gimbals & Stabilizers ──
      {
        'id': 'gim-dji-rs3-pro',
        'categoryId': 'cat-gimbal',
        'brand': 'DJI',
        'name': 'DJI RS 3 Pro Gimbal',
        'image': 'assets/images/categories/gimbal.png',
        'basePrice': 48000,
        'storages': ['Standard', 'Combo Pack with Focus Motor'],
        'colors': ['Carbon Black'],
        'specs': 'Automated Axis Locks, Carbon Fiber Arms, 4.5kg Payload',
      },
      // ── Smartphones ──
      {
        'id': 'phone-iphone-16-pro',
        'categoryId': 'cat-smartphone',
        'brand': 'Apple',
        'name': 'iPhone 16 Pro',
        'image': 'assets/images/refurbished/iphone-15-pro.png',
        'basePrice': 82000,
        'storages': ['128GB', '256GB', '512GB', '1TB'],
        'colors': ['Desert Titanium', 'Natural Titanium', 'White Titanium', 'Black Titanium'],
        'specs': '6.3" ProMotion 120Hz, A18 Pro 3nm, 5x Optical Telephoto',
      },
      {
        'id': 'phone-iphone-15-pro-max',
        'categoryId': 'cat-smartphone',
        'brand': 'Apple',
        'name': 'iPhone 15 Pro Max',
        'image': 'assets/images/refurbished/iphone-15-pro.png',
        'basePrice': 72000,
        'storages': ['256GB', '512GB', '1TB'],
        'colors': ['Natural Titanium', 'Blue Titanium', 'Black Titanium', 'White Titanium'],
        'specs': '6.7" Super Retina XDR, A17 Pro 3nm, 5x Optical Telephoto',
      },
      {
        'id': 'phone-iphone-15-pro',
        'categoryId': 'cat-smartphone',
        'brand': 'Apple',
        'name': 'iPhone 15 Pro',
        'image': 'assets/images/refurbished/iphone-15-pro-blue.jpg',
        'basePrice': 62000,
        'storages': ['128GB', '256GB', '512GB'],
        'colors': ['Blue Titanium', 'Natural Titanium', 'Black Titanium'],
        'specs': '6.1" OLED 120Hz ProMotion, A17 Pro, Action Button',
      },
      {
        'id': 'phone-galaxy-s24-ultra',
        'categoryId': 'cat-smartphone',
        'brand': 'Samsung',
        'name': 'Galaxy S24 Ultra',
        'image': 'assets/images/refurbished/galaxy-s24-ultra.png',
        'basePrice': 68000,
        'storages': ['256GB', '512GB', '1TB'],
        'colors': ['Titanium Gray', 'Titanium Black', 'Titanium Violet'],
        'specs': '6.8" Dynamic AMOLED 2X, Snapdragon 8 Gen 3, S-Pen',
      },
      {
        'id': 'phone-pixel-8-pro',
        'categoryId': 'cat-smartphone',
        'brand': 'Google',
        'name': 'Pixel 8 Pro',
        'image': 'assets/images/refurbished/pixel-8-pro.png',
        'basePrice': 45000,
        'storages': ['128GB', '256GB'],
        'colors': ['Obsidian', 'Bay', 'Porcelain'],
        'specs': '6.7" Super Actua OLED, Google Tensor G3, AI Zoom',
      },
      {
        'id': 'phone-oneplus-12',
        'categoryId': 'cat-smartphone',
        'brand': 'OnePlus',
        'name': 'OnePlus 12',
        'image': 'assets/images/refurbished/oneplus-12.png',
        'basePrice': 44000,
        'storages': ['256GB', '512GB'],
        'colors': ['Flowy Emerald', 'Silky Black'],
        'specs': '6.82" 2K 120Hz ProXDR, Snapdragon 8 Gen 3, 5400mAh',
      },
      // ── Laptops ──
      {
        'id': 'lap-macbook-pro-14',
        'categoryId': 'cat-laptop',
        'brand': 'Apple',
        'name': 'MacBook Pro 14" M3',
        'image': 'assets/images/refurbished/macbook-pro-14.png',
        'basePrice': 110000,
        'storages': ['512GB SSD', '1TB SSD'],
        'colors': ['Space Black', 'Silver'],
        'specs': '14.2" Liquid Retina XDR, Apple M3 Pro, 18GB Unified RAM',
      },
      {
        'id': 'lap-macbook-air-m2',
        'categoryId': 'cat-laptop',
        'brand': 'Apple',
        'name': 'MacBook Air 13" M2',
        'image': 'assets/images/refurbished/macbook-air-m2.png',
        'basePrice': 62000,
        'storages': ['256GB SSD', '512GB SSD'],
        'colors': ['Midnight', 'Starlight', 'Space Gray'],
        'specs': '13.6" Liquid Retina, Apple M2, MagSafe 3',
      },
      {
        'id': 'lap-dell-xps-15',
        'categoryId': 'cat-laptop',
        'brand': 'Dell',
        'name': 'Dell XPS 15',
        'image': 'assets/images/refurbished/dell-xps-15.png',
        'basePrice': 75000,
        'storages': ['512GB SSD', '1TB SSD'],
        'colors': ['Platinum Silver'],
        'specs': '15.6" OLED 3.5K, Intel Core i7 13th Gen, RTX 4060',
      },
      // ── Tablets ──
      {
        'id': 'tab-ipad-pro-m2',
        'categoryId': 'cat-tablet',
        'brand': 'Apple',
        'name': 'iPad Pro 11" M2',
        'image': 'assets/images/refurbished/ipad-pro-m2.jpg',
        'basePrice': 48000,
        'storages': ['128GB', '256GB', '512GB'],
        'colors': ['Space Gray', 'Silver'],
        'specs': '11" Liquid Retina ProMotion 120Hz, Apple M2 Chip',
      },
      {
        'id': 'tab-galaxy-tab-s9',
        'categoryId': 'cat-tablet',
        'brand': 'Samsung',
        'name': 'Galaxy Tab S9',
        'image': 'assets/images/refurbished/galaxy-tab-s9.jpg',
        'basePrice': 42000,
        'storages': ['128GB', '256GB'],
        'colors': ['Graphite', 'Beige'],
        'specs': '11" Dynamic AMOLED 2X 120Hz, Snapdragon 8 Gen 2, S-Pen',
      },
    ];

    var filtered = allModels;
    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') {
      filtered = filtered.where((m) => m['categoryId'] == categoryId).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final s = search.toLowerCase().trim();
      filtered = filtered.where((m) =>
        (m['name'] as String).toLowerCase().contains(s) ||
        (m['brand'] as String).toLowerCase().contains(s)
      ).toList();
    }
    return filtered;
  }

  static List<Map<String, dynamic>> _getFallbackQuestions(String categoryId) {
    if (categoryId == 'cat-smartphone' || categoryId == 'cat-tablet') {
      return [
        {
          'id': 'phone-screen',
          'question': 'Display & Touchscreen Status?',
          'options': [
            {'label': 'Original Flawless Screen', 'sublabel': 'Zero scratches, perfect TrueTone/120Hz', 'adj': 2000},
            {'label': 'Minor Hairline Scratches', 'sublabel': 'Touch & display 100% functional', 'adj': 0},
            {'label': 'Cracked Glass / Black Dots', 'sublabel': 'Display bleeding or lines', 'adj': -6000},
          ],
        },
        {
          'id': 'phone-body',
          'question': 'Back Glass & Metal Frame?',
          'options': [
            {'label': 'Mint / Pristine Condition', 'sublabel': 'Always used in case', 'adj': 1000},
            {'label': 'Minor Edge Dents / Scratches', 'sublabel': 'Standard daily wear', 'adj': 0},
            {'label': 'Cracked Back Glass / Bent', 'sublabel': 'Chassis damage', 'adj': -3500},
          ],
        },
        {
          'id': 'phone-battery',
          'question': 'Battery Health Percentage?',
          'options': [
            {'label': '90% - 100% Health', 'sublabel': 'Excellent battery longevity', 'adj': 1500},
            {'label': '80% - 89% Health', 'sublabel': 'Standard operational health', 'adj': 0},
            {'label': 'Below 80% / Service Alert', 'sublabel': 'Requires battery replacement', 'adj': -3000},
          ],
        },
        {
          'id': 'phone-hardware',
          'question': 'Cameras, FaceID & Microphones?',
          'options': [
            {'label': 'All Cameras & Sensors Perfect', 'sublabel': '0.5x, 1x, 3x, FaceID 100%', 'adj': 0},
            {'label': 'FaceID / Fingerprint Failure', 'sublabel': 'Biometric sensor unavailable', 'adj': -3000},
            {'label': 'Camera Shaking / Foggy Lens', 'sublabel': 'OIS motor or lens flaw', 'adj': -4500},
          ],
        },
      ];
    } else if (categoryId == 'cat-laptop') {
      return [
        {
          'id': 'lap-display',
          'question': 'Screen & Retina Coating?',
          'options': [
            {'label': 'Pristine Flawless Display', 'sublabel': 'No dead pixels or delamination', 'adj': 1500},
            {'label': 'Keyboard Imprints / Micro Scratches', 'sublabel': 'Visible only under direct light', 'adj': 0},
            {'label': 'Cracked Panel / Lines / Stain', 'sublabel': 'Screen replacement needed', 'adj': -7000},
          ],
        },
        {
          'id': 'lap-keyboard',
          'question': 'Keyboard & Trackpad Condition?',
          'options': [
            {'label': 'All Keys & Touchpad Perfect', 'sublabel': 'Smooth typing & gestures', 'adj': 0},
            {'label': 'Sticky / Stiff Keys', 'sublabel': 'Minor key resistance', 'adj': -2500},
            {'label': 'Trackpad Click Defect', 'sublabel': 'Click or haptic unresponsive', 'adj': -4000},
          ],
        },
        {
          'id': 'lap-battery',
          'question': 'Battery Health & Charger?',
          'options': [
            {'label': 'Original Charger + High Health', 'sublabel': 'Holds charge 6+ hours', 'adj': 2000},
            {'label': 'Normal Battery Health', 'sublabel': 'Holds charge 3-5 hours', 'adj': 0},
            {'label': 'Service Battery Warning', 'sublabel': 'Requires replacement', 'adj': -4000},
          ],
        },
        {
          'id': 'lap-body',
          'question': 'Aluminum Body & Hinges?',
          'options': [
            {'label': 'Mint / Solid Hinges', 'sublabel': 'Smooth opening & closing', 'adj': 1500},
            {'label': 'Minor Edge Scuffs', 'sublabel': 'Cosmetic edge rub', 'adj': 0},
            {'label': 'Heavy Dent / Loose Hinge', 'sublabel': 'Chassis deformity', 'adj': -4500},
          ],
        },
      ];
    } else if (categoryId == 'cat-lens') {
      return [
        {
          'id': 'lens-glass',
          'question': 'Optical Glass & Coating Condition?',
          'options': [
            {'label': 'Crystal Clear (No Fungus/Scratches)', 'sublabel': 'Flawless optical glass', 'adj': 2000},
            {'label': 'Minor Dust Specks (No Effect on Image)', 'sublabel': 'Normal internal micro-dust', 'adj': 0},
            {'label': 'Visible Fungus / Deep Scratch', 'sublabel': 'Internal coating haze or fungus', 'adj': -5500},
          ],
        },
        {
          'id': 'lens-motor',
          'question': 'Autofocus & Aperture Blades?',
          'options': [
            {'label': 'Fast Silent AF & Snappy Aperture', 'sublabel': '100% operational', 'adj': 0},
            {'label': 'Sluggish AF / Stiff Focus Ring', 'sublabel': 'Slow motor response', 'adj': -2500},
            {'label': 'AF Hunting Failure / Oily Blades', 'sublabel': 'Aperture stickiness', 'adj': -4500},
          ],
        },
        {
          'id': 'lens-accessories',
          'question': 'Included Lens Accessories?',
          'options': [
            {'label': 'Full Box + Hood + Front & Rear Caps', 'sublabel': 'Complete original bundle', 'adj': 1500},
            {'label': 'Front & Rear Caps Only', 'sublabel': 'Basic essential protection', 'adj': 0},
            {'label': 'Missing Lens Caps', 'sublabel': 'No caps included', 'adj': -1000},
          ],
        },
      ];
    } else {
      return [
        {
          'id': 'cam-power',
          'question': 'Does the camera power on & shoot normally?',
          'options': [
            {'label': 'Powers on & Shoots Perfectly', 'sublabel': 'Normal shutter response & dials', 'adj': 0},
            {'label': 'Intermittent Shutter Lag', 'sublabel': 'Takes photos but occasional pause', 'adj': -3000},
            {'label': 'Does Not Power On', 'sublabel': 'Requires servicing / board check', 'adj': -8000},
          ],
        },
        {
          'id': 'cam-sensor',
          'question': 'Sensor Glass & Viewfinder Condition?',
          'options': [
            {'label': 'Pristine Flawless Sensor', 'sublabel': 'Zero spots, dust or scratches', 'adj': 2000},
            {'label': 'Minor Dust (Easily Cleaned)', 'sublabel': 'Standard sensor dust specks', 'adj': 0},
            {'label': 'Visible Scratches / Fungus', 'sublabel': 'Coating damage or fungus mark', 'adj': -5000},
          ],
        },
        {
          'id': 'cam-body',
          'question': 'Body Cosmetic & Rubber Grip Condition?',
          'options': [
            {'label': 'Like New / Flawless', 'sublabel': 'No scratches, firm rubber grips', 'adj': 1500},
            {'label': 'Good (Minor Rub Marks)', 'sublabel': 'Normal cosmetic edge wear', 'adj': 0},
            {'label': 'Heavy Paint Wear / Peeling', 'sublabel': 'Loose rubber or body dings', 'adj': -3500},
          ],
        },
        {
          'id': 'cam-accessories',
          'question': 'Original Accessories Included?',
          'options': [
            {'label': 'Full Box + Charger + 2 Batteries', 'sublabel': 'Complete packaging & caps', 'adj': 2500},
            {'label': 'Original Charger + 1 Battery', 'sublabel': 'Basic working bundle', 'adj': 0},
            {'label': 'Third-Party Charger Only', 'sublabel': 'No original box/charger', 'adj': -2000},
          ],
        },
        {
          'id': 'cam-shutter',
          'question': 'Estimated Shutter Actuations?',
          'options': [
            {'label': '< 20,000 Shutter Count', 'sublabel': 'Light hobbyist usage', 'adj': 1500},
            {'label': '20,000 - 60,000 Shutter Count', 'sublabel': 'Moderate regular use', 'adj': 0},
            {'label': '> 80,000 Shutter Count', 'sublabel': 'Heavy professional workload', 'adj': -4000},
          ],
        },
      ];
    }
  }

  static final List<Map<String, dynamic>> _fallbackRefurbished = [
    {
      'id': 'ref-phone-15-pro',
      'modelId': 'iphone-15-pro',
      'brand': 'Apple',
      'model': 'iPhone 15 Pro',
      'category': 'Smartphones',
      'condition': 'Superb',
      'storage': '128GB',
      'color': 'Natural Titanium',
      'originalPrice': 134900,
      'sellingPrice': 58999,
      'discount': 56,
      'batteryHealth': '98% Battery',
      'warranty': '12 Months Camsik Care',
      'image': 'assets/images/refurbished/iphone-15-pro.png',
      'gallery': [
        'assets/images/refurbished/iphone-15-pro.png',
        'assets/images/refurbished/iphone-15-pro-natural-back.jpg',
        'assets/images/refurbished/iphone-15-pro-natural-camera.jpg',
      ],
      'specs': '6.1" Super Retina XDR 120Hz, A17 Pro Chip, 48MP Triple Lens',
      'availableUnits': [
        {
          'unitId': 'U-15P-01',
          'storage': '128GB',
          'color': 'Natural Titanium',
          'condition': 'Superb',
          'batteryHealth': '98% Battery',
          'price': 58999,
          'originalPrice': 134900,
          'note': 'Unit 1 · 98% Battery · Like-New Flawless · Original Box',
        },
        {
          'unitId': 'U-15P-02',
          'storage': '256GB',
          'color': 'Blue Titanium',
          'condition': 'Superb',
          'batteryHealth': '99% Battery',
          'price': 64999,
          'originalPrice': 144900,
          'note': 'Unit 2 · 99% Battery · Sealed Packaging · Pristine',
        },
      ],
    },
    {
      'id': 'ref-phone-15-pro-good-black',
      'modelId': 'iphone-15-pro',
      'brand': 'Apple',
      'model': 'iPhone 15 Pro',
      'category': 'Smartphones',
      'condition': 'Good',
      'storage': '128GB',
      'color': 'Black Titanium',
      'originalPrice': 134900,
      'sellingPrice': 52499,
      'discount': 61,
      'batteryHealth': '92% Battery',
      'warranty': '12 Months Camsik Care',
      'image': 'assets/images/refurbished/iphone-15-pro-black.jpg',
      'gallery': [
        'assets/images/refurbished/iphone-15-pro-black.jpg',
        'assets/images/refurbished/iphone-15-pro-black-front.jpg',
      ],
      'specs': '6.1" Super Retina XDR 120Hz, A17 Pro Chip, Black Titanium',
      'availableUnits': [
        {
          'unitId': 'U-15P-03',
          'storage': '128GB',
          'color': 'Black Titanium',
          'condition': 'Good',
          'batteryHealth': '92% Battery',
          'price': 52499,
          'originalPrice': 134900,
          'note': 'Unit 1 · 92% Battery · Screen Pristine · Minor Edge Scuff',
        },
        {
          'unitId': 'U-15P-04',
          'storage': '256GB',
          'color': 'Natural Titanium',
          'condition': 'Good',
          'batteryHealth': '90% Battery',
          'price': 56999,
          'originalPrice': 144900,
          'note': 'Unit 2 · 90% Battery · Tested 45-Point Certified',
        },
      ],
    },
    {
      'id': 'ref-galaxy-s24-ultra',
      'modelId': 'galaxy-s24-ultra',
      'brand': 'Samsung',
      'model': 'Galaxy S24 Ultra',
      'category': 'Smartphones',
      'condition': 'Superb',
      'storage': '256GB',
      'color': 'Titanium Violet',
      'originalPrice': 139999,
      'sellingPrice': 89999,
      'discount': 36,
      'batteryHealth': '100% Battery',
      'warranty': '12 Months Camsik Care',
      'image': 'assets/images/refurbished/galaxy-s24-ultra.png',
      'gallery': [
        'assets/images/refurbished/galaxy-s24-ultra.png',
        'assets/images/refurbished/galaxy-s24-violet.jpg',
      ],
      'specs': '6.8" Dynamic AMOLED 2X, Snapdragon 8 Gen 3, S-Pen Built-in',
      'availableUnits': [
        {
          'unitId': 'U-S24U-01',
          'storage': '256GB',
          'color': 'Titanium Violet',
          'condition': 'Superb',
          'batteryHealth': '100% Battery',
          'price': 89999,
          'originalPrice': 139999,
          'note': 'Unit 1 · 100% Battery · Pristine Display · Full Box',
        },
      ],
    },
    {
      'id': 'ref-canon-rp',
      'modelId': 'canon-eos-rp',
      'brand': 'Canon',
      'model': 'Canon EOS RP',
      'category': 'Cameras',
      'condition': 'Superb',
      'storage': 'Body Only',
      'color': 'Black',
      'originalPrice': 95000,
      'sellingPrice': 52999,
      'discount': 44,
      'batteryHealth': 'Shutter: 2,400',
      'warranty': '12 Months Camsik Care',
      'image': 'assets/images/refurbished/canon-eos-rp.jpg',
      'gallery': [
        'assets/images/refurbished/canon-eos-rp.jpg',
      ],
      'specs': '26.2 MP Full-Frame CMOS, Dual Pixel AF, 4K UHD, RF Mount',
      'availableUnits': [
        {
          'unitId': 'U-CRP-01',
          'storage': 'Body Only',
          'color': 'Black',
          'condition': 'Superb',
          'batteryHealth': 'Shutter: 2,400',
          'price': 52999,
          'originalPrice': 95000,
          'note': 'Unit 1 · Shutter 2,400 · Original Charger & 2 Batteries',
        },
        {
          'unitId': 'U-CRP-02',
          'storage': 'Kit 24-105mm',
          'color': 'Black',
          'condition': 'Superb',
          'batteryHealth': 'Shutter: 3,100',
          'price': 66999,
          'originalPrice': 118000,
          'note': 'Unit 2 · Shutter 3,100 · With RF 24-105mm STM Lens',
        },
      ],
    },
    {
      'id': 'ref-sony-a7',
      'modelId': 'sony-a7',
      'brand': 'Sony',
      'model': 'Sony Alpha A7',
      'category': 'Cameras',
      'condition': 'Superb',
      'storage': 'Body Only',
      'color': 'Black',
      'originalPrice': 75000,
      'sellingPrice': 34999,
      'discount': 53,
      'batteryHealth': 'Shutter: 8,900',
      'warranty': '12 Months Camsik Care',
      'image': 'assets/images/refurbished/sony-a7.jpg',
      'gallery': [
        'assets/images/refurbished/sony-a7.jpg',
      ],
      'specs': '24.3 MP Full-Frame Exmor CMOS, 1080 60p, E-Mount',
      'availableUnits': [
        {
          'unitId': 'U-SA7-01',
          'storage': 'Body Only',
          'color': 'Black',
          'condition': 'Superb',
          'batteryHealth': 'Shutter: 8,900',
          'price': 34999,
          'originalPrice': 75000,
          'note': 'Unit 1 · Shutter 8,900 · Sensor Pristine · Battery & Strap',
        },
      ],
    },
    {
      'id': 'ref-macbook-pro-14',
      'modelId': 'macbook-pro-14',
      'brand': 'Apple',
      'model': 'MacBook Pro 14" M3',
      'category': 'Laptops',
      'condition': 'Superb',
      'storage': '512GB SSD',
      'color': 'Space Black',
      'originalPrice': 169900,
      'sellingPrice': 118999,
      'discount': 30,
      'batteryHealth': '100% (21 Cycles)',
      'warranty': '12 Months Camsik Care',
      'image': 'assets/images/refurbished/macbook-pro-14.png',
      'gallery': [
        'assets/images/refurbished/macbook-pro-14.png',
      ],
      'specs': '14.2" Liquid Retina XDR, Apple M3 Pro, 18GB Unified RAM',
      'availableUnits': [
        {
          'unitId': 'U-MBP-01',
          'storage': '512GB SSD',
          'color': 'Space Black',
          'condition': 'Superb',
          'batteryHealth': '100% (21 Cycles)',
          'price': 118999,
          'originalPrice': 169900,
          'note': 'Unit 1 · 100% Battery · 21 Cycles · 70W MagSafe Adapter',
        },
      ],
    },
    {
      'id': 'ref-macbook-air-m2',
      'modelId': 'macbook-air-m2',
      'brand': 'Apple',
      'model': 'MacBook Air 13" M2',
      'category': 'Laptops',
      'condition': 'Superb',
      'storage': '256GB SSD',
      'color': 'Midnight',
      'originalPrice': 99900,
      'sellingPrice': 62999,
      'discount': 37,
      'batteryHealth': '98% (42 Cycles)',
      'warranty': '12 Months Camsik Care',
      'image': 'assets/images/refurbished/macbook-air-m2.png',
      'gallery': [
        'assets/images/refurbished/macbook-air-m2.png',
      ],
      'specs': '13.6" Liquid Retina, Apple M2, 8GB RAM, MagSafe 3',
      'availableUnits': [
        {
          'unitId': 'U-MBA-01',
          'storage': '256GB SSD',
          'color': 'Midnight',
          'condition': 'Superb',
          'batteryHealth': '98% (42 Cycles)',
          'price': 62999,
          'originalPrice': 99900,
          'note': 'Unit 1 · 98% Battery · Clean Chassis · 30W MagSafe Adapter',
        },
      ],
    },
    {
      'id': 'ref-ipad-pro-m2',
      'modelId': 'ipad-pro-m2',
      'brand': 'Apple',
      'model': 'iPad Pro 11" M2',
      'category': 'Tablets',
      'condition': 'Superb',
      'storage': '128GB',
      'color': 'Space Gray',
      'originalPrice': 81900,
      'sellingPrice': 48999,
      'discount': 40,
      'batteryHealth': '97% Battery',
      'warranty': '12 Months Camsik Care',
      'image': 'assets/images/refurbished/ipad-pro-m2.jpg',
      'gallery': [
        'assets/images/refurbished/ipad-pro-m2.jpg',
      ],
      'specs': '11" Liquid Retina ProMotion 120Hz, Apple M2 Chip, Face ID',
      'availableUnits': [
        {
          'unitId': 'U-IPP-01',
          'storage': '128GB',
          'color': 'Space Gray',
          'condition': 'Superb',
          'batteryHealth': '97% Battery',
          'price': 48999,
          'originalPrice': 81900,
          'note': 'Unit 1 · 97% Battery · Zero Scratches · 20W USB-C Adapter',
        },
      ],
    },
  ];
}
