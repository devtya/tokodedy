import 'package:flutter/material.dart';

class AppTheme {
  // ═══════════════════════════════════════════════════════════════════ 
  //  PALETTE — seluruh warna aplikasi didefinisikan di sini 
  //  Guna: 1) konsistensi visual, 2) mudah diubah di satu tempat 
  // ═══════════════════════════════════════════════════════════════════ 

  // ── Neutral ────────────────────────────────────────────────────── 
  static const Color background = Color(0xFF0D0D0D); 
  static const Color surface = Color(0xFF1E1E1E); 
  static const Color border = Color(0xFF2A2A2A); 
  static const Color divider = Color(0xFF333333); 
  static const Color grey = Color(0xFF666666); 
  static const Color white = Color(0xFFFFFFFF); 
  static const Color white06 = Color(0x0FFFFFFF); // white 6% 
  static const Color white03 = Color(0x08FFFFFF); // white 3% 
  static const Color white02 = Color(0x05FFFFFF); // white 2% 

  // ── Primary (Green) ────────────────────────────────────────────── 
  static const Color primary = Color(0xFF2ECC71); 
  static const Color onPrimary = Color(0xFF0A2E17); 
  static const Color primaryContainer = Color(0xFF0F4C2A); 
  static const Color primaryContainerLight = Color(0xFF1A6B3A); 
  static const Color primarySoft = Color(0x1F2ECC71); // 12% opacity 
  static const Color primaryBorder = Color(0x33FFFFFF); // green border variant 

  // ── Status ─────────────────────────────────────────────────────── 
  static const Color error = Color(0xFFE74C3C); 
  static const Color errorSoft = Color(0x14E74C3C); // 8% opacity 
  static const Color errorBorder = Color(0x4DE74C3C); // 30% opacity 
  static const Color warning = Color(0xFFFF9800); 
  static const Color info = Color(0xFF3498DB); 
  static const Color success = Color(0xFF2ECC71); 

  // ── Surface variants ───────────────────────────────────────────── 
  static const Color surfaceContainerLow = Color(0xFF141414); 
  static const Color surfaceInput = Color(0xFF1E1E1E); 

  // ═══════════════════════════════════════════════════════════════════ 
  //  LIGHT PALETTE — override untuk light theme 
  // ═══════════════════════════════════════════════════════════════════ 

  static const Color lightBackground = Color(0xFFF5F5F5); 
  static const Color lightSurface = Color(0xFFFFFFFF); 
  static const Color lightBorder = Color(0xFFE0E0E0); 
  static const Color lightDivider = Color(0xFFEEEEEE); 
  static const Color lightGrey = Color(0xFF999999); 
  static const Color lightText = Color(0xFF1A1A1A); 
  static const Color lightTextSecondary = Color(0xFF666666); 

  // ═══════════════════════════════════════════════════════════════════ 
  //  BACKWARD-COMPATIBLE ALIASES 
  //  Masih dipakai oleh halaman/widget lama. Setara dengan palette di 
  //  atas agar tetap konsisten. 
  // ═══════════════════════════════════════════════════════════════════ 

  static const Color primaryGreen = primary; 
  static const Color accentGreen = primary; 
  static const Color lightGreen = primaryContainer; 
  static const Color darkGreen = onPrimary; 
  static const Color warningRed = error; 
  static const Color warningOrange = warning; 
  static const Color neutralGrey = grey; 

  // ═══════════════════════════════════════════════════════════════════ 
  //  DARK THEME 
  //  Semua komponen Material tema gelap dikonfigurasi di sini. 
  //  Guna: konsistensi antar halaman & mudah di-maintain. 
  // ═══════════════════════════════════════════════════════════════════ 

  static ThemeData get darkTheme { 
    return ThemeData( 
      useMaterial3: true, 
      brightness: Brightness.dark, 
      scaffoldBackgroundColor: background, 
      fontFamily: 'Roboto', 

      colorScheme: const ColorScheme.dark( 
        primary: primary, 
        onPrimary: onPrimary, 
        primaryContainer: primaryContainer, 
        secondary: primary, 
        onSecondary: onPrimary, 
        error: error, 
        surface: surface, 
        onSurface: white, 
        outline: border, 
      ), 

      appBarTheme: const AppBarTheme( 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        centerTitle: false, 
        scrolledUnderElevation: 0, 
      ), 

      cardTheme: CardThemeData( 
        color: surface, 
        elevation: 0, 
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(14), 
          side: const BorderSide(color: border, width: 1.5), 
        ), 
      ), 

      inputDecorationTheme: InputDecorationTheme( 
        filled: true, 
        fillColor: surface, 
        contentPadding: const EdgeInsets.symmetric( 
          horizontal: 14, 
          vertical: 10, 
        ), 
        labelStyle: const TextStyle( 
          color: grey, 
          fontSize: 9, 
          letterSpacing: 1.5, 
        ), 
        hintStyle: const TextStyle(color: grey, fontSize: 13), 
        border: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: border, width: 1.5), 
        ), 
        enabledBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: border, width: 1.5), 
        ), 
        focusedBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: primary, width: 1.5), 
        ), 
        errorBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: error, width: 1.5), 
        ), 
        focusedErrorBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: error, width: 1.5), 
        ), 
      ), 

      elevatedButtonTheme: ElevatedButtonThemeData( 
        style: ElevatedButton.styleFrom( 
          backgroundColor: primary, 
          foregroundColor: onPrimary, 
          elevation: 0, 
          padding: const EdgeInsets.symmetric(vertical: 14), 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(12), 
          ), 
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15), 
        ), 
      ), 

      outlinedButtonTheme: OutlinedButtonThemeData( 
        style: OutlinedButton.styleFrom( 
          foregroundColor: white, 
          side: const BorderSide(color: border, width: 1.5), 
          padding: const EdgeInsets.symmetric(vertical: 14), 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(12), 
          ), 
          textStyle: const TextStyle(fontWeight: FontWeight.w700), 
        ), 
      ), 

      floatingActionButtonTheme: const FloatingActionButtonThemeData( 
        backgroundColor: primary, 
        foregroundColor: onPrimary, 
      ), 

      switchTheme: SwitchThemeData( 
        thumbColor: WidgetStateProperty.resolveWith((states) { 
          if (states.contains(WidgetState.selected)) return primary; 
          return Colors.grey; 
        }), 
        trackColor: WidgetStateProperty.resolveWith((states) { 
          if (states.contains(WidgetState.selected)) { 
            return primary.withValues(alpha: 0.3); 
          } 
          return const Color(0xFF333333); 
        }), 
      ), 

      snackBarTheme: SnackBarThemeData( 
        backgroundColor: surface, 
        contentTextStyle: const TextStyle(color: white), 
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(10), 
          side: const BorderSide(color: border), 
        ), 
        behavior: SnackBarBehavior.floating, 
      ), 

      dividerTheme: const DividerThemeData( 
        color: border, 
        thickness: 1, 
        space: 1, 
      ), 
    ); 
  } 

  // ═══════════════════════════════════════════════════════════════════ 
  //  LIGHT THEME 
  // ═══════════════════════════════════════════════════════════════════ 

  static ThemeData get lightTheme { 
    return ThemeData( 
      useMaterial3: true, 
      brightness: Brightness.light, 
      scaffoldBackgroundColor: lightBackground, 
      fontFamily: 'Roboto', 

      colorScheme: const ColorScheme.light( 
        primary: primary, 
        onPrimary: Colors.white, 
        primaryContainer: Color(0xFFD5F5E3), 
        secondary: primary, 
        onSecondary: Colors.white, 
        error: error, 
        surface: lightSurface, 
        onSurface: lightText, 
        outline: lightBorder, 
      ), 

      appBarTheme: const AppBarTheme( 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        centerTitle: false, 
        scrolledUnderElevation: 0, 
      ), 

      cardTheme: CardThemeData( 
        color: lightSurface, 
        elevation: 0, 
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(14), 
          side: const BorderSide(color: lightBorder, width: 1.5), 
        ), 
      ), 

      inputDecorationTheme: InputDecorationTheme( 
        filled: true, 
        fillColor: lightBackground, 
        contentPadding: const EdgeInsets.symmetric( 
          horizontal: 14, 
          vertical: 10, 
        ), 
        labelStyle: const TextStyle( 
          color: lightGrey, 
          fontSize: 9, 
          letterSpacing: 1.5, 
        ), 
        hintStyle: const TextStyle(color: lightGrey, fontSize: 13), 
        border: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: lightBorder, width: 1.5), 
        ), 
        enabledBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: lightBorder, width: 1.5), 
        ), 
        focusedBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: primary, width: 1.5), 
        ), 
        errorBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: error, width: 1.5), 
        ), 
        focusedErrorBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: error, width: 1.5), 
        ), 
      ), 

      elevatedButtonTheme: ElevatedButtonThemeData( 
        style: ElevatedButton.styleFrom( 
          backgroundColor: primary, 
          foregroundColor: Colors.white, 
          elevation: 0, 
          padding: const EdgeInsets.symmetric(vertical: 14), 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(12), 
          ), 
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15), 
        ), 
      ), 

      outlinedButtonTheme: OutlinedButtonThemeData( 
        style: OutlinedButton.styleFrom( 
          foregroundColor: lightText, 
          side: const BorderSide(color: lightBorder, width: 1.5), 
          padding: const EdgeInsets.symmetric(vertical: 14), 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(12), 
          ), 
          textStyle: const TextStyle(fontWeight: FontWeight.w700), 
        ), 
      ), 

      floatingActionButtonTheme: const FloatingActionButtonThemeData( 
        backgroundColor: primary, 
        foregroundColor: Colors.white, 
      ), 

      switchTheme: SwitchThemeData( 
        thumbColor: WidgetStateProperty.resolveWith((states) { 
          if (states.contains(WidgetState.selected)) return primary; 
          return Colors.grey; 
        }), 
        trackColor: WidgetStateProperty.resolveWith((states) { 
          if (states.contains(WidgetState.selected)) { 
            return primary.withValues(alpha: 0.3); 
          } 
          return const Color(0xFFCCCCCC); 
        }), 
      ), 

      snackBarTheme: SnackBarThemeData( 
        backgroundColor: lightSurface, 
        contentTextStyle: const TextStyle(color: lightText), 
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(10), 
          side: const BorderSide(color: lightBorder), 
        ), 
        behavior: SnackBarBehavior.floating, 
      ), 

      dividerTheme: const DividerThemeData( 
        color: lightDivider, 
        thickness: 1, 
        space: 1, 
      ), 
    ); 
  }
}
