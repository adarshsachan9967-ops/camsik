import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7C3AED), // Premium Purple
        primary: const Color(0xFF7C3AED),
        secondary: const Color(0xFF2563EB),
        surface: const Color(0xFFF8FAFC),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        color: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A), // Dark Luxury Slate
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
