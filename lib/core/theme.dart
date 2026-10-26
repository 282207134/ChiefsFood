import 'package:flutter/material.dart';

const orange = Color(0xFFFFA000);
const muted = Color(0xFF929292);

ThemeData appTheme(bool dark) {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: orange,
        brightness: dark ? Brightness.dark : Brightness.light,
      ).copyWith(
        primary: orange,
        onPrimary: Colors.black,
        surface: dark ? const Color(0xFF262626) : const Color(0xFFFCFCFC),
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    fontFamily: 'Poppins',
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: dark ? Colors.white : const Color(0xFF111111),
        height: 1.3,
      ),
      headlineSmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: const TextStyle(fontSize: 14, height: 1.6),
      bodySmall: const TextStyle(fontSize: 12, color: muted, height: 1.5),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF303030) : Colors.white,
      hintStyle: const TextStyle(color: Color(0xFFB5B5B5), fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: dark ? const Color(0xFF484848) : const Color(0xFFE5E5E5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: dark ? const Color(0xFF484848) : const Color(0xFFE5E5E5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: orange),
      ),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: orange,
      thumbColor: orange,
      overlayColor: Color(0x1AFFA000),
    ),
    dividerColor: dark ? const Color(0xFF454545) : const Color(0xFFE9E9E9),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        color: muted,
      ),
    ),
  );
}
