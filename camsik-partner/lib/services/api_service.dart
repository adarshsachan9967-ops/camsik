import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/partner_models.dart';

class ApiService {
  static const List<String> _baseUrls = [
    'https://casmik-one.vercel.app',
    'https://casmik.vercel.app',
    'http://10.0.2.2:4028',
    'http://localhost:4028',
  ];

  static String? _resolvedBaseUrl;

  static Future<Map<String, dynamic>?> _get(String path) async {
    final client = HttpClient()..connectionTimeout = const Duration(milliseconds: 3000);
    final urlsToTry = _resolvedBaseUrl != null
        ? [_resolvedBaseUrl!, ..._baseUrls.where((u) => u != _resolvedBaseUrl)]
        : _baseUrls;

    for (final base in urlsToTry) {
      try {
        final uri = Uri.parse('$base$path');
        final request = await client.getUrl(uri).timeout(const Duration(milliseconds: 3000));
        request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
        final response = await request.close().timeout(const Duration(milliseconds: 3000));

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

  static Future<Map<String, dynamic>?> _post(String path, Map<String, dynamic> data) async {
    final client = HttpClient()..connectionTimeout = const Duration(milliseconds: 3500);
    final urlsToTry = _resolvedBaseUrl != null
        ? [_resolvedBaseUrl!, ..._baseUrls.where((u) => u != _resolvedBaseUrl)]
        : _baseUrls;

    for (final base in urlsToTry) {
      try {
        final uri = Uri.parse('$base$path');
        final request = await client.postUrl(uri).timeout(const Duration(milliseconds: 3500));
        request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
        request.write(jsonEncode(data));
        final response = await request.close().timeout(const Duration(milliseconds: 3500));

        final responseBody = await response.transform(utf8.decoder).join();
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _resolvedBaseUrl = base;
          final decoded = jsonDecode(responseBody);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded);
          }
        } else {
          try {
            return Map<String, dynamic>.from(jsonDecode(responseBody));
          } catch (_) {}
        }
      } catch (_) {}
    }
    client.close();
    return null;
  }

  static Future<Map<String, dynamic>?> _patch(String path, Map<String, dynamic> data) async {
    final client = HttpClient()..connectionTimeout = const Duration(milliseconds: 3500);
    final urlsToTry = _resolvedBaseUrl != null
        ? [_resolvedBaseUrl!, ..._baseUrls.where((u) => u != _resolvedBaseUrl)]
        : _baseUrls;

    for (final base in urlsToTry) {
      try {
        final uri = Uri.parse('$base$path');
        final request = await client.patchUrl(uri).timeout(const Duration(milliseconds: 3500));
        request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
        request.write(jsonEncode(data));
        final response = await request.close().timeout(const Duration(milliseconds: 3500));

        final responseBody = await response.transform(utf8.decoder).join();
        if (response.statusCode >= 200 && response.statusCode < 300) {
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

  /// Authenticate Partner
  static Future<Map<String, dynamic>> login(String identifier, String password) async {
    final res = await _post('/api/auth/login', {
      'identifier': identifier,
      'password': password,
      'role': 'partner',
    });

    if (res != null && res['success'] == true) {
      final partnerData = res['partner'] ?? res['user'];
      return {
        'success': true,
        'partner': PartnerUser.fromJson(Map<String, dynamic>.from(partnerData)),
        'message': res['message'] ?? 'Logged in successfully',
      };
    }

    return {
      'success': false,
      'message': res?['message'] ?? 'Unable to connect to Camsik server. Please check your credentials.',
    };
  }

  /// Fetch partner orders from backend
  static Future<List<PartnerOrder>> fetchOrders({
    String? partnerId,
    String? status,
    String? type,
    String? search,
  }) async {
    final queryParams = <String>[];
    if (partnerId != null && partnerId.isNotEmpty) queryParams.add('partnerId=$partnerId');
    if (status != null && status.isNotEmpty && status != 'all') queryParams.add('status=$status');
    if (type != null && type.isNotEmpty && type != 'all') queryParams.add('type=$type');
    if (search != null && search.isNotEmpty) queryParams.add('search=${Uri.encodeComponent(search)}');

    final path = '/api/orders${queryParams.isNotEmpty ? '?${queryParams.join('&')}' : ''}';
    final res = await _get(path);

    if (res != null && res['success'] == true && res['orders'] is List) {
      return (res['orders'] as List)
          .map((item) => PartnerOrder.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return [];
  }

  /// Update order status, QA inspection score, or final counter-offer
  static Future<bool> updateOrder({
    required String orderId,
    required String status,
    double? finalPrice,
    int? inspectionScore,
    String? notes,
  }) async {
    final payload = <String, dynamic>{
      'orderId': orderId,
      'status': status,
    };
    if (finalPrice != null) payload['finalPrice'] = finalPrice;
    if (inspectionScore != null) payload['inspectionScore'] = inspectionScore;
    if (notes != null) payload['notes'] = notes;

    final res = await _patch('/api/orders', payload);
    return res != null && res['success'] == true;
  }

  /// Update partner profile details
  static Future<bool> updatePartnerProfile(String partnerId, Map<String, dynamic> updates) async {
    final payload = {'id': partnerId, ...updates};
    final res = await _patch('/api/partners', payload);
    return res != null && res['success'] == true;
  }
}
