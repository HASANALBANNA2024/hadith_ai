import 'package:flutter/material.dart';
import 'package:hadith_ai/logic/bookmark_service.dart';
import 'package:hadith_ai/screens/chapter_list_screen.dart';
import 'package:hadith_ai/screens/dashboard_screen.dart';
import 'package:hadith_ai/screens/splash_screen.dart';
import 'package:hadith_ai/widgets/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ১. হাইভ ইনিশিয়ালাইজ করুন
  await Hive.initFlutter();

  // ২. বক্স ওপেন করুন (শুধুমাত্র ডাটা সেভ রাখার জন্য)
  // 'app_cache' নাম ব্যবহার করা হয়েছে যা আমাদের HadithApiService-এ আছে
  await Hive.openBox('app_cache');

  // ৩. বুকমার্ক সার্ভিস ইনিশিয়ালাইজ
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

      // প্রথমে স্প্ল্যাশ স্ক্রিন দেখাবে যা ইন্টারনেট চেক করবে
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
        // ডিফল্ট রাউট
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      },
    );
  }

  // স্লাগ থেকে সুন্দর টাইটেল বানানোর ফাংশন
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