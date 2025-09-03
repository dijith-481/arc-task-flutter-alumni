import 'package:flutter/material.dart';

class NordColors {
  static const Color polarNight0 = Color(0xFF2E3440);
  static const Color polarNight1 = Color(0xFF3B4252);
  static const Color polarNight2 = Color(0xFF434C5E);
  static const Color polarNight3 = Color(0xFF4C566A);

  static const Color snowStorm0 = Color(0xFFD8DEE9);
  static const Color snowStorm1 = Color(0xFFE5E9F0);
  static const Color snowStorm2 = Color(0xFFECEFF4);

  static const Color frost0 = Color(0xFF8FBCBB);
  static const Color frost1 = Color(0xFF88C0D0);
  static const Color frost2 = Color(0xFF81A1C1);
  static const Color frost3 = Color(0xFF5E81AC);

  static const Color aurora0 = Color(0xFFBF616A);
  static const Color aurora1 = Color(0xFFD08770);
  static const Color aurora2 = Color(0xFFEBCB8B);
  static const Color aurora3 = Color(0xFFA3BE8C);
  static const Color aurora4 = Color(0xFFB48EAD);
}

final ThemeData nordLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: NordColors.frost3,
    onPrimary: NordColors.snowStorm2,
    secondary: NordColors.frost1,
    onSecondary: NordColors.polarNight0,
    error: NordColors.aurora0,
    onError: NordColors.snowStorm2,
    surface: NordColors.snowStorm1,
    onSurface: NordColors.polarNight0,
  ),
  scaffoldBackgroundColor: NordColors.snowStorm2,
  appBarTheme: const AppBarTheme(
    elevation: 0, // No shadow
    backgroundColor: NordColors.snowStorm1,
    foregroundColor: NordColors.polarNight0,
  ),
);

final ThemeData nordDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: NordColors.frost2,
    onPrimary: NordColors.polarNight0,
    secondary: NordColors.frost0,
    onSecondary: NordColors.polarNight0,
    error: NordColors.aurora0,
    onError: NordColors.polarNight0,
    surface: NordColors.polarNight1,
    onSurface: NordColors.snowStorm1,
  ),
  scaffoldBackgroundColor: NordColors.polarNight0,
  appBarTheme: const AppBarTheme(
    elevation: 0, // No shadow
    backgroundColor: NordColors.polarNight1,
    foregroundColor: NordColors.snowStorm1,
  ),
);
