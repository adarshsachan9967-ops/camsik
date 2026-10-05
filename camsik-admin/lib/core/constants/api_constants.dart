class ApiConstants {
  ApiConstants._();

  // Primary Server & API Base URL
  static const String serverUrl = "https://casmik-one.vercel.app";
  static const String baseUrl = "$serverUrl/api";

  // Fallback Server URLs for local development / testing
  static const List<String> fallbackUrls = [
    'https://casmik-one.vercel.app',
    'https://casmik.vercel.app',
    'http://10.0.2.2:4028',
    'http://localhost:4028',
  ];

  // ── Authentication Endpoints ──
  static const String login = "$baseUrl/auth/login";
  static const String refreshToken = "$baseUrl/auth/refresh-token";

  // ── Admin Command & Analytics ──
  static const String overview = "$baseUrl/admin/overview";

  // ── Orders Management ──
  static const String orders = "$baseUrl/orders";
  static const String orderMessages = "$baseUrl/orders/messages";

  // ── Partners Network ──
  static const String partners = "$baseUrl/partners";

  // ── Field Logistics & Fleet ──
  static const String deliveryAgents = "$baseUrl/delivery-agents";

  // ── Media & Proof Upload ──
  static const String imageKitAuth = "$baseUrl/imagekit/auth";
  static const String imageKitUpload = "$baseUrl/imagekit/upload";
}
