import 'package:flutter/material.dart';

/// Design tokens and theme configuration for Habit Tracker.
/// Derived directly from the brand logo (`assets/habit.png`):
/// - Cobalt Blue (#174E8F) & Electric Azure (#0371FD)
/// - Warm Tangerine Orange (#FB923C / #C2410C / #EA580C)
/// Complies with Antislop guidelines:
/// - 2-3 core colors + 1 deliberate accent (R-29)
/// - WCAG AA compliant contrast (R-25)
/// - Differentiated radius hierarchy (R-11)
/// - Working Light and Dark themes (R-21, R-34)
class AppTheme {
  // Dark Palette (Deep Midnight Navy)
  static const Color darkBg = Color(0xFF0C1424);
  static const Color darkSurface = Color(0xFF152238);
  static const Color darkSurfaceElevated = Color(0xFF1C2D4A);
  static const Color darkBorder = Color(0xFF243754);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFA0ABBA);

  // Light Palette
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);

  // Brand Identity Colors (Directly from assets/habit.png)
  static const Color logoCobalt = Color(0xFF174E8F);
  static const Color logoAzure = Color(0xFF0371FD);
  static const Color logoOrange = Color(0xFFFB923C);
  static const Color logoOrangeDark = Color(0xFFC2410C);
  static const Color logoOrangePrimary = Color(0xFFEA580C);

  // Semantic Aliases for clean usage across screens
  static const Color primaryBrandDark = logoAzure;
  static const Color primaryBrandLight = logoCobalt;
  static const Color accentOrangeDark = logoOrange;
  static const Color accentOrangeLight = logoOrangeDark;

  // Backward-compatible aliases
  static const Color emeraldPrimary = logoAzure;
  static const Color emeraldDark = logoCobalt;

  // Destructive Colors
  static const Color danger = Color(0xFFEF4444);

  // Border Radii
  static const double radiusCard = 16.0;
  static const double radiusButton = 12.0;
  static const double radiusInput = 10.0;

  // Web Layout Constraint
  static const double maxContentWidth = 640.0;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: logoAzure,
        secondary: logoOrange,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        outline: darkBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: darkTextSecondary, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: darkBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: logoAzure, width: 2),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: logoCobalt,
        secondary: logoOrangeDark,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        outline: lightBorder,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBg,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lightSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: lightTextSecondary, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: lightBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: logoCobalt, width: 2),
        ),
      ),
    );
  }

  // Consistent heatmap colors in Logo Cobalt & Azure tone with Orange milestone
  static const Map<int, Color> heatmapColors = {
    1: Color(0xFF162A45),
    2: Color(0xFF183B6B),
    3: Color(0xFF174E8F),
    4: Color(0xFF1B62B8),
    5: Color(0xFF1E75E0),
    6: Color(0xFF0371FD),
    7: Color(0xFF2589FE),
    8: Color(0xFF5BA3FE),
    9: Color(0xFF8EBEFE),
    10: Color(0xFFFB923C), // 100% completion in Logo Tangerine
  };
}
