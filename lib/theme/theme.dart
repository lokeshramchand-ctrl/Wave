// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF4A90E2); // Calm Blue
  static const Color accentBlue = Color(0xFF50BFE6); // Sky Accent
  static const Color lightBackground = Color(0xFFF6F9FC); // Soft White
  static const Color darkBackground = Color(0xFF0A0F2C); // Navy
  static const Color cardLight = Color(0xFFE6F0FA); // Frosted Light
  static const Color cardDark = Color(0xFF1B2A49); // Frosted Dark

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: lightBackground,
      fontFamily: 'SF Pro Display',
      splashFactory: NoSplash.splashFactory,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: accentBlue,
        background: lightBackground,
        surface: cardLight,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black87,
      ),
      cardColor: cardLight,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
        bodyMedium: TextStyle(fontSize: 16, fontFamily: 'SF Pro Display'),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: darkBackground,
      fontFamily: 'SF Pro Display',
      splashFactory: NoSplash.splashFactory,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: const Color.fromARGB(0, 255, 255, 255),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryBlue,
        secondary: accentBlue,
        background: darkBackground,
        surface: cardDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white70,
      ),
      cardColor: cardDark,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontFamily: 'SF Pro Display',
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'SF Pro Display',
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.white70,
          fontFamily: 'SF Pro Display',
        ),
      ),
      useMaterial3: true,
    );
  }
}
