import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/admin_models.dart';

class ApiService {
  static const List<String> _baseUrls = [
    'https://casmik-one.vercel.app',
    'https://casmik.vercel.app',
    'http://10.0.2.2:4028',
    'http://localhost:4028',
  ];

  static String? _workingBaseUrl;

  static Future<String> _getBaseUrl() async {
    if (_workingBaseUrl != null) return _workingBaseUrl!;
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 4);

    for (final base in _baseUrls) {
      try {
        final uri = Uri.parse('$base/api/orders?limit=1');
        final req = await client.getUrl(uri);
        final resp = await req.close();
        if (resp.statusCode >= 200 && resp.statusCode < 500) {
          _workingBaseUrl = base;
          client.close();
          return base;
        }
      } catch (_) {}
    }
    client.close();
    _workingBaseUrl = _baseUrls.first;
    return _baseUrls.first;
  }

  static Future<Map<String, dynamic>?> _get(String path) async {
    final base = await _getBaseUrl();
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final uri = Uri.parse('$base$path');
      final req = await client.getUrl(uri);
      req.headers.set('Content-Type', 'application/json');
      req.headers.set('Accept', 'application/json');
      final resp = await req.close();
      final body = await resp.transform(utf8.decoder).join();
      client.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return jsonDecode(body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('ApiService GET error [$path]: $e');
    } finally {
      client.close();
    }
    return null;
  }

  static Future<Map<String, dynamic>?> _post(String path, Map<String, dynamic> data) async {
    final base = await _getBaseUrl();
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final uri = Uri.parse('$base$path');
      final req = await client.postUrl(uri);
      req.headers.set('Content-Type', 'application/json');
      req.headers.set('Accept', 'application/json');
      req.add(utf8.encode(jsonEncode(data)));
      final resp = await req.close();
      final body = await resp.transform(utf8.decoder).join();
      client.close();
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('ApiService POST error [$path]: $e');
    } finally {
      client.close();
    }
    return null;
  }

  static Future<Map<String, dynamic>?> _patch(String path, Map<String, dynamic> data) async {
    final base = await _getBaseUrl();
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final uri = Uri.parse('$base$path');
      final req = await client.patchUrl(uri);
      req.headers.set('Content-Type', 'application/json');
      req.headers.set('Accept', 'application/json');
      req.add(utf8.encode(jsonEncode(data)));
      final resp = await req.close();
      final body = await resp.transform(utf8.decoder).join();
      client.close();
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('ApiService PATCH error [$path]: $e');
    } finally {
      client.close();
    }
    return null;
  }

  /// Authenticate Admin
  static Future<AdminUser?> login(String email, String password) async {
    final res = await _post('/api/auth/login', {
      'email': email.trim(),
      'password': password.trim(),
    });

    if (res != null && res['success'] == true) {
      final userData = res['user'] as Map<String, dynamic>? ?? {};
      final role = userData['role']?.toString().toLowerCase();
      if (role == 'admin' || role == 'superadmin') {
        return AdminUser.fromJson(userData);
      }
    }
    return null;
  }

  /// Get live platform overview analytics
  static Future<Map<String, dynamic>?> fetchOverview() async {
    final res = await _get('/api/admin/overview');
    if (res != null && res['success'] == true && res['data'] != null) {
      return res['data'] as Map<String, dynamic>;
    }
    return null;
  }

  /// Get all platform orders with optional filtering
  static Future<List<AdminOrder>> fetchOrders({
    String? search,
    String? status,
    String? type,
  }) async {
    final params = <String>[];
    if (search != null && search.isNotEmpty) params.add('search=${Uri.encodeComponent(search)}');
    if (status != null && status != 'all') params.add('status=${Uri.encodeComponent(status)}');
    if (type != null && type != 'all') params.add('type=${Uri.encodeComponent(type)}');

    final query = params.isNotEmpty ? '?${params.join('&')}' : '';
    final res = await _get('/api/orders$query');

    if (res != null && res['success'] == true && res['orders'] is List) {
      final list = res['orders'] as List;
      return list.map((e) => AdminOrder.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  /// Assign or update order status
  static Future<bool> updateOrder({
    required String orderId,
    String? status,
    String? notes,
    String? assignedPartnerId,
    String? assignedPartnerName,
    String? assignedRiderId,
    String? assignedRiderName,
  }) async {
    final res = await _patch('/api/orders', {
      'orderId': orderId,
      'status': ?status,
      'notes': ?notes,
      'assignedPartnerId': ?assignedPartnerId,
      'assignedPartnerName': ?assignedPartnerName,
      'assignedRiderId': ?assignedRiderId,
      'assignedRiderName': ?assignedRiderName,
    });
    return res != null && res['success'] == true;
  }

  /// Fetch Partner directory
  static Future<List<AdminPartner>> fetchPartners() async {
    final res = await _get('/api/partners');
    if (res != null && res['success'] == true && res['partners'] is List) {
      final list = res['partners'] as List;
      return list.map((e) => AdminPartner.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  /// Update Partner status (active / suspended)
  static Future<bool> updatePartnerStatus({
    required String partnerId,
    required String status,
  }) async {
    final res = await _patch('/api/partners', {
      'id': partnerId,
      'status': status,
    });
    return res != null && res['success'] == true;
  }

  /// Fetch Delivery Fleet
  static Future<List<AdminDeliveryAgent>> fetchDeliveryAgents() async {
    final res = await _get('/api/delivery-agents');
    if (res != null && res['success'] == true && res['agents'] is List) {
      final list = res['agents'] as List;
      return list.map((e) => AdminDeliveryAgent.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  /// Update Agent duty status
  static Future<bool> updateAgentDutyStatus({
    required String agentId,
    required String dutyStatus,
  }) async {
    final res = await _patch('/api/delivery-agents', {
      'id': agentId,
      'dutyStatus': dutyStatus,
    });
    return res != null && res['success'] == true;
  }
}
