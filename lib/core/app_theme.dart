import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF175BB8);
  static const Color primarySoft = Color(0xFFE8F0FF);
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF18263B);
  static const Color muted = Color(0xFF526178);
  static const Color outline = Color(0xFFD5DCE8);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF176147);
  static const Color successSoft = Color(0xFFE5F3EC);
  static const Color warning = Color(0xFF795400);
  static const Color warningSoft = Color(0xFFFFF2CC);
  static const Color danger = Color(0xFFAC3034);
  static const Color dangerSoft = Color(0xFFFCEAEC);
  static const Color disabled = Color(0xFFE3E7ED);
  static const Color disabledInk = Color(0xFF627087);
  static const Color nav = Color(0xFFF0F4FB);

  static ThemeData get light {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      onPrimary: onPrimary,
      surface: surface,
      onSurface: ink,
      error: danger,
      outline: outline,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      colorScheme: baseScheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 64,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: ink,
          height: 28 / 22,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: ink,
          height: 36 / 28,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: ink,
          height: 28 / 22,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: ink,
          height: 28 / 20,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ink,
          height: 24 / 16,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ink,
          height: 20 / 14,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: muted,
          height: 16 / 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: disabled,
          disabledForegroundColor: disabledInk,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: surface,
          foregroundColor: primary,
          disabledForegroundColor: disabledInk,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          side: const BorderSide(color: outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: muted,
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: muted,
        ),
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: muted,
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: danger,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: danger, width: 1.5),
        ),
      ),
    );
  }
}
