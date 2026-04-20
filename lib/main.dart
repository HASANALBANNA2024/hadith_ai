import 'package:flutter/material.dart';
import 'package:hadith_ai/screens/splash_screen.dart';
import 'package:hadith_ai/widgets/app_theme.dart'; // এখানে // থেকে একটি / কমিয়ে দেওয়া হয়েছে

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hadith AI',
      debugShowCheckedModeBanner: false,

      // থিম কানেকশন
      themeMode: ThemeMode.system,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,

      home: const SplashScreen(),
    );
  }
}
