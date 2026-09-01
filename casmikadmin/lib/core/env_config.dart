class EnvConfig {
  static const String supabaseUrl = "https://vyzdfzcxsuhcbjfpdmjh.supabase.co";
  static const String supabaseAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ5emRmemN4c3VoY2JqZnBkbWpoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc1OTMzNzksImV4cCI6MjEwMzE2OTM3OX0.kyWIAqBRda2ZEAp6RwefpVQfYcTngVxqe0EZevPxYRI";

  // MongoDB Atlas Configuration
  static const String mongodbUri =
      "mongodb+srv://adarshsachan7071_db_user:WhVdi8oaPTqFJZAP@casmikk.nfgequ6.mongodb.net/?appName=casmikk";
  static const String mongodbDbName = "casmik";

  // ImageKit Configuration
  static const String imagekitId = "v8swalwfs";
  static const String imagekitUrlEndpoint = "https://ik.imagekit.io/v8swalwfs";
  static const String imagekitPublicKey =
      "public_BEIY/mfZ/cGwCuJpaYzOJ9UIapM=";
  static const String imagekitPrivateKey =
      "private_3m79CXKzWsW2hXu/jnRvcohOAHQ=";
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
