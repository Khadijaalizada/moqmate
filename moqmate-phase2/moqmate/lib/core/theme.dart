import 'package:flutter/material.dart';

class AppColors {
  static const wine = Color(0xFF580D22);
  static const burgundy = Color(0xFF800E2F);
  static const crimson = Color(0xFFA4133C);
  static const ruby = Color(0xFFC9194A);
  static const rose = Color(0xFFFF4D6D);
  static const pink = Color(0xFFFF758F);
  static const blush = Color(0xFFFF90A3);
  static const petal = Color(0xFFFFB3C0);
  static const mist = Color(0xFFFFCCD5);
  static const snow = Color(0xFFFFF0F3);
}

ThemeData buildTheme() {
  const scheme = ColorScheme.light(
    primary: AppColors.crimson,
    onPrimary: Colors.white,
    secondary: AppColors.wine,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF2B0A14),
    error: Color(0xFFB00020),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.snow,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.wine,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.crimson,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.crimson),
    ),
  );
}
