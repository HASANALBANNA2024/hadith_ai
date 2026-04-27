import 'package:flutter/material.dart';
import 'package:hadith_ai/ai_chatbot/aura_chat_bot.dart';
import 'package:hadith_ai/logic/bookmark_service.dart';
import 'package:hadith_ai/screens/chapter_list_screen.dart';
import 'package:hadith_ai/screens/dashboard_screen.dart';
import 'package:hadith_ai/screens/splash_screen.dart';
import 'package:hadith_ai/widgets/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Required for plugin initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Open necessary boxes
  await Hive.openBox('app_cache');

  // Initialize the bookmark service
  await BookmarkService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hadith AI',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      // Setting themeMode to system ensures it follows mobile settings
      themeMode: ThemeMode.system,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,

      // Using builder to wrap the entire app with Aura ChatBot.
      // We pass the global 'child' so it stays on top of every page.
      builder: (context, child) {
        return AuraChatBot(
          // Logic: Service is ready when child is not null
          isServiceReady: child != null,
          child: child!,
        );
      },

      // Initial route
      home: const SplashScreen(),

      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/chapters/')) {
          final String bookSlug = settings.name!.replaceFirst('/chapters/', '');

          // Better way to detect brightness from context
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return MaterialPageRoute(
            builder: (context) => ChapterListScreen(
              bookSlug: bookSlug,
              bookTitle: _getFormattedTitle(bookSlug),
              isDarkStatus: isDark,
            ),
          );
        }

        return MaterialPageRoute(builder: (context) => const HomeScreen());
      },
    );
  }

  String _getFormattedTitle(String slug) {
    if (slug.isEmpty) return "Hadith Book";
    return slug
        .split('-')
        .map(
          (word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : "",
        )
        .join(' ');
  }
}
