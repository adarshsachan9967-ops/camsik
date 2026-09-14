class EnvConfig {
  static const String supabaseUrl = "https://vyzdfzcxsuhcbjfpdmjh.supabase.co";
  static const String supabaseAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ5emRmemN4c3VoY2JqZnBkbWpoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc1OTMzNzksImV4cCI6MjEwMzE2OTM3OX0.kyWIAqBRda2ZEAp6RwefpVQfYcTngVxqe0EZevPxYRI";

  // MongoDB Atlas Configuration
  static const String mongodbUri =
      "mongodb+srv://adarshsachan9967_db_user:aQCPwwzcilQGVHhU@camsik.oxiqz3o.mongodb.net";
  static const String mongodbDbName = "casmik";

  // ImageKit Configuration
  static const String imagekitId = "avdarinn";
  static const String imagekitUrlEndpoint = "https://ik.imagekit.io/avdarinn";
  static const String imagekitPublicKey =
      "public_uzSklsoDFlGNoIPGFtTdcYJU32Y=";
  static const String imagekitPrivateKey =
      "private_Zgjm0jSmxe2S76y3kkULZ5nzEvo=";
  static const String imagekitFolder = "casmik";

  /// Generates full ImageKit URL given an image path or fileName
  static String getImageKitUrl(String path, {String? transformation}) {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final folderPath = cleanPath.startsWith(imagekitFolder)
        ? cleanPath
        : '$imagekitFolder/$cleanPath';
    if (transformation != null && transformation.isNotEmpty) {
      return "$imagekitUrlEndpoint/tr:$transformation/$folderPath";
    }
    return "$imagekitUrlEndpoint/$folderPath";
  }
}
