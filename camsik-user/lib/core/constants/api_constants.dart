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
  static const String register = "$baseUrl/auth/signup";
  static const String sendOtp = "$baseUrl/auth/send-otp";
  static const String verifyOtp = "$baseUrl/auth/verify-otp";
  static const String refreshToken = "$baseUrl/auth/refresh-token";
  static const String getProfile = "$baseUrl/auth/me";

  // ── Catalog & Home Endpoints ──
  static const String banners = "$baseUrl/banners";
  static const String categories = "$baseUrl/categories";
  static const String models = "$baseUrl/models";
  static const String questions = "$baseUrl/questions";
  static const String refurbished = "$baseUrl/refurbished";
  static const String rentals = "$baseUrl/rentals";

  // ── Orders & Transactions Endpoints ──
  static const String orders = "$baseUrl/orders";
  static const String createOrder = "$baseUrl/orders";

  // ── Location & Miscellaneous ──
  static const String cities = "$baseUrl/cities";
}
