import 'package:flutter/material.dart';
import 'package:hadith_ai/logic/bookmark_service.dart';
import 'package:hadith_ai/screens/chapter_list_screen.dart';
import 'package:hadith_ai/screens/dashboard_screen.dart';
import 'package:hadith_ai/screens/splash_screen.dart';
import 'package:hadith_ai/widgets/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Initialization
  await Hive.initFlutter();


  // 'app_cache'
  await Hive.openBox('app_cache');

  // bookmark service initialization
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

      themeMode: ThemeMode.system,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,

      // call to splash screen
      home: const SplashScreen(),

      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/chapters/')) {
          final String bookSlug = settings.name!.replaceFirst('/chapters/', '');
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
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1)
        : "")
        .join(' ');
  }
}