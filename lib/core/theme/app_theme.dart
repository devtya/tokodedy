import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Custom color constants (both themes) ──

  // Dark theme
  static const Color darkBackground   = Color(0xFF0D1117);
  static const Color darkSurface      = Color(0xFF161B1F);
  static const Color darkSurfaceAlt   = Color(0xFF1C2227);
  static const Color darkBorder       = Color(0xFF262C31);
  static const Color darkText         = Color(0xFFE6E8EB);
  static const Color darkTextSub      = Color(0xFF8B949E);
  static const Color darkGreen        = Color(0xFF3FB37F);
  static const Color darkAmber        = Color(0xFFD2984A);
  static const Color darkBlue         = Color(0xFF5B8DD0);
  static const Color darkPurple       = Color(0xFF9370B8);
  static const Color darkRed          = Color(0xFFD9776E);

  // Light theme
  static const Color lightBackground  = Color(0xFFF7F4EE);
  static const Color lightSurface     = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt  = Color(0xFFF0EBE1);
  static const Color lightBorder      = Color(0xFFE5DDCF);
  static const Color lightText        = Color(0xFF2B2925);
  static const Color lightTextSub     = Color(0xFF8A8071);
  static const Color lightGreen       = Color(0xFF357C56);
  static const Color lightAmber       = Color(0xFFAD7E36);
  static const Color lightBlue        = Color(0xFF456DA0);
  static const Color lightPurple      = Color(0xFF7A5C97);
  static const Color lightRed         = Color(0xFFB85950);

  // ── Backward-compatible aliases ──
  static const Color primaryGreen     = lightGreen;
  static const Color accentGreen      = lightGreen;
  static const Color darkGreenAlias   = darkGreen;
  static const Color warningOrange    = Color(0xFFD2984A);
  static const Color warningRed       = lightRed;
  static const Color error            = lightRed;
  static const Color primary          = Color(0xFF3FB37F);
  static const Color onPrimary        = Color(0xFF04140C);
  static const Color white            = Color(0xFFFFFFFF);
  static const Color surface          = Color(0xFF161B1F);
  static const Color border           = Color(0xFF262C31);
  static const Color neutralGrey      = Color(0xFF8A8071);
  static const Color grey             = Color(0xFF8A8071);
  static const Color lightGrey        = Color(0xFF999999);
  static const Color lightTextSecondary = Color(0xFF8A8071);
  static const Color surfaceContainerLow = Color(0xFF141414);
  static const Color surfaceInput     = Color(0xFF161B1F);
  static const Color background       = Color(0xFF0D1117);
  static const Color info             = Color(0xFF3498DB);
  static const Color warning          = Color(0xFFFF9800);
  static const Color errorSoft        = Color(0x14B85950);

  // ── Light Theme ──
  static ThemeData get lightTheme {
    final scheme = ColorScheme.light(
      primary: lightGreen,
      onPrimary: Colors.white,
      secondary: lightBlue,
      onSecondary: Colors.white,
      surface: lightSurface,
      onSurface: lightText,
      surfaceContainerHighest: lightSurfaceAlt,
      outline: lightBorder,
      outlineVariant: lightBorder,
      error: lightRed,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: lightText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: lightGreen,
          letterSpacing: 0,
        ),
        iconTheme: IconThemeData(color: lightTextSub),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: lightBorder, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 1.5,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: lightGreen,
        unselectedItemColor: lightTextSub,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightGreen,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w800, color: lightText,
            letterSpacing: -0.5,
          ),
          titleMedium: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, color: lightText,
          ),
          bodyMedium: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w500, color: lightText,
          ),
          bodySmall: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, color: lightTextSub,
          ),
        ),
      ),
    );
  }

  // ── Dark Theme ──
  static ThemeData get darkTheme {
    final scheme = ColorScheme.dark(
      primary: darkGreen,
      onPrimary: const Color(0xFF04140C),
      secondary: darkBlue,
      onSecondary: Colors.white,
      surface: darkSurface,
      onSurface: darkText,
      surfaceContainerHighest: darkSurfaceAlt,
      outline: darkBorder,
      outlineVariant: darkBorder,
      error: darkRed,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: darkText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: darkGreen,
          letterSpacing: 0,
        ),
        iconTheme: IconThemeData(color: darkTextSub),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: const Color(0xFF04140C),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkGreen,
        unselectedItemColor: darkTextSub,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkGreen,
        foregroundColor: Color(0xFF04140C),
        elevation: 4,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w800, color: darkText,
            letterSpacing: -0.5,
          ),
          titleMedium: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, color: darkText,
          ),
          bodyMedium: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w500, color: darkText,
          ),
          bodySmall: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, color: darkTextSub,
          ),
        ),
      ),
    );
  }
}
