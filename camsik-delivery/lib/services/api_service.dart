import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/delivery_models.dart';

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

  /// Delivery Agent Login
  static Future<Map<String, dynamic>> login(String identifier, String password) async {
    final res = await _post('/api/auth/login', {
      'identifier': identifier,
      'password': password,
      'role': 'delivery',
    });

    if (res != null && res['success'] == true) {
      final agentData = res['agent'] ?? res['user'];
      return {
        'success': true,
        'agent': DeliveryAgentUser.fromJson(Map<String, dynamic>.from(agentData)),
        'message': res['message'] ?? 'Logged in successfully',
      };
    }

    return {
      'success': false,
      'message': res?['message'] ?? 'Unable to connect to Camsik server. Please check your phone/password.',
    };
  }

  /// Fetch delivery & pickup tasks
  static Future<List<DeliveryTask>> fetchTasks({
    String? deliveryAgentId,
    String? status,
    String? search,
  }) async {
    final queryParams = <String>[];
    if (deliveryAgentId != null && deliveryAgentId.isNotEmpty) {
      queryParams.add('deliveryAgentId=$deliveryAgentId');
    }
    if (status != null && status.isNotEmpty && status != 'all') {
      queryParams.add('status=$status');
    }
    if (search != null && search.isNotEmpty) {
      queryParams.add('search=${Uri.encodeComponent(search)}');
    }

    final path = '/api/orders${queryParams.isNotEmpty ? '?${queryParams.join('&')}' : ''}';
    final res = await _get(path);

    if (res != null && res['success'] == true && res['orders'] is List) {
      return (res['orders'] as List)
          .map((item) => DeliveryTask.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return [];
  }

  /// Update task status / verify OTP
  static Future<bool> updateTaskStatus({
    required String orderId,
    required String status,
    String? notes,
  }) async {
    final res = await _patch('/api/orders', {
      'orderId': orderId,
      'status': status,
      'notes': ?notes,
    });
    return res != null && res['success'] == true;
  }

  /// Toggle agent online / offline state
  static Future<bool> updateAgentStatus({
    required String agentId,
    required String status,
  }) async {
    final res = await _patch('/api/delivery-agents', {
      'id': agentId,
      'status': status,
    });
    return res != null && res['success'] == true;
  }
}
