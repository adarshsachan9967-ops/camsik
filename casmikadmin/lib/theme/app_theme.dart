// THEME LOCK: dark — source: explicit user prompt (#0A0A0A background, white text)
// Scaffold.backgroundColor = AppTheme.backgroundDark — ALL screens

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors
  static const Color casmikGreen = Color(0xFF00C853);
  static const Color casmikGreenMuted = Color(0x4000C853);
  static const Color casmikGreenDim = Color(0x1A00C853);

  // Dark surfaces
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF141414);
  static const Color surfaceVariantDark = Color(0xFF1E1E1E);
  static const Color surfaceElevatedDark = Color(0xFF242424);
  static const Color borderDark = Color(0xFF2A2A2A);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textMuted = Color(0xFF666666);

  // Semantic
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF2196F3);

  // Light surfaces (required by framework)
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: casmikGreen,
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFF003314),
      onPrimaryContainer: Color(0xFFB9F6CA),
      secondary: Color(0xFF1E1E1E),
      onSecondary: Color(0xFFFFFFFF),
      surface: surfaceDark,
      onSurface: textPrimary,
      error: error,
      onError: Color(0xFFFFFFFF),
      outline: Color(0xFF3A3A3A),
      outlineVariant: Color(0xFF2A2A2A),
      inverseSurface: Color(0xFFE6E6E6),
      onInverseSurface: Color(0xFF1A1A1A),
    ),
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(color: textPrimary),
        displayMedium: TextStyle(color: textPrimary),
        displaySmall: TextStyle(color: textPrimary),
        headlineLarge: TextStyle(color: textPrimary),
        headlineMedium: TextStyle(color: textPrimary),
        headlineSmall: TextStyle(color: textPrimary),
        titleLarge: TextStyle(color: textPrimary),
        titleMedium: TextStyle(color: textPrimary),
        titleSmall: TextStyle(color: textPrimary),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textMuted),
        labelLarge: TextStyle(color: textPrimary),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textMuted),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: borderDark, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceVariantDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: casmikGreen, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error),
      ),
      labelStyle: const TextStyle(color: textMuted),
      hintStyle: const TextStyle(color: textMuted),
    ),
    dividerTheme: const DividerThemeData(color: borderDark, thickness: 1),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceVariantDark,
      selectedColor: casmikGreenDim,
      labelStyle: const TextStyle(color: textSecondary, fontSize: 12),
      side: const BorderSide(color: borderDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: casmikGreen,
      unselectedLabelColor: textMuted,
      indicatorColor: casmikGreen,
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.light(
      primary: casmikGreen,
      onPrimary: Colors.white,
      surface: surfaceLight,
      onSurface: const Color(0xFF1A1A1A),
      error: error,
      onError: Colors.white,
      outline: const Color(0xFFCCCCCC),
    ),
    textTheme: GoogleFonts.interTextTheme(),
  );
}
