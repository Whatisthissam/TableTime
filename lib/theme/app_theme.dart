import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme defines the visual design system tokens extracted directly
/// from the Stitch design specification for TableTime.
class AppTheme {
  // Brand Color Tokens
  static const Color primary = Color(0xFFC2410C); // Deep Terracotta
  static const Color primaryLight = Color(0xFFFFEDD5); // Soft Terracotta Peach
  static const Color secondary = Color(0xFFD97706); // Golden Amber
  static const Color secondaryLight = Color(0xFFFEF3C7); // Soft Amber
  
  // Dietary & Status Accents
  static const Color vegGreen = Color(0xFF16A34A); // Emerald Green
  static const Color vegGreenLight = Color(0xFFDCFCE7); // Mint Green
  static const Color nonVegRed = Color(0xFFDC2626); // Crimson Red
  static const Color nonVegRedLight = Color(0xFFFEE2E2); // Soft Red
  static const Color occupiedGrey = Color(0xFF9CA3AF); // Neutral Grey
  static const Color occupiedBg = Color(0xFFF3F4F6); // Grey Container

  // Canvas & Surface Hierarchy
  static const Color background = Color(0xFFFFF8F4); // Warm Cream Canvas
  static const Color surface = Color(0xFFFFFBF7); // Base Card Surface
  static const Color surfaceContainerLow = Color(0xFFFBF8F5); // Card backdrops
  static const Color surfaceContainer = Color(0xFFF5EFEA); // Grouping, inputs, chips
  static const Color surfaceContainerHigh = Color(0xFFEFE7E0); // Dividers, borders
  
  // Neutrals & Typography
  static const Color onSurface = Color(0xFF1E1B18); // Deep Warm Espresso
  static const Color onSurfaceVariant = Color(0xFF44403C); // Warm Charcoal
  static const Color outline = Color(0xFF78716C); // Muted Stone
  static const Color outlineVariant = Color(0xFFD6CECA);

  // Elevation & Ambient Warm Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF44403C).withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get primaryButtonShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.25),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ];

  static List<BoxShadow> get floatingBarShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.18),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  // Geometries
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2Xl = 24.0;
  static const double radiusPill = 9999.0;

  /// Material 3 ThemeData configured for TableTime
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        error: nonVegRed,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainer: surfaceContainer,
        surfaceContainerHigh: surfaceContainerHigh,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: -0.3,
          height: 1.25,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: -0.2,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onSurfaceVariant,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurfaceVariant,
          height: 1.45,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: outline,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: outline,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusPill),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: surfaceContainerHigh,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
