import 'package:flutter/material.dart';

class AppThemes {
  static const Color primaryGreen = Color(0xFF004D40);
  static const Color accentGold = Color(0xFFFFD700);
  static const Color darkBackground = Color(0xFF020404);
  static const Color lightBackground = Color(0xFFF2F5F5);

  static const Color darkCardBg = Color(0xFF111817);
  static const Color lightCardBg = Colors.white;

  // --- Light Theme ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // colorScheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      primary: primaryGreen,
      surface: lightBackground,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: accentGold),
      titleTextStyle: TextStyle(
        color: accentGold,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
  );

  // --- Dark Theme ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: accentGold,
      surface: darkBackground,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D1F1D),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: accentGold),
      titleTextStyle: TextStyle(
        color: accentGold,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0D1F1D),
      selectedItemColor: accentGold,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
  );
}
