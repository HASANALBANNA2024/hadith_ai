import 'package:flutter/material.dart';
import 'package:hadith_ai/logic/bookmark_service.dart';
import 'package:hadith_ai/screens/chapter_list_screen.dart';
import 'package:hadith_ai/screens/dashboard_screen.dart';
import 'package:hadith_ai/screens/splash_screen.dart';
import 'package:hadith_ai/widgets/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hadith_ai/download/download_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ১. হাইভ ইনিশিয়ালাইজ করুন
  await Hive.initFlutter();

  // ২. প্রয়োজনীয় সব বক্স ওপেন করুন (app_cache সহ)
  await Hive.openBox('download_metadata');
  await Hive.openBox('app_cache'); // এই লাইনটি না থাকলে "Box not found" এরর আসবে

  // ৩. অন্যান্য সার্ভিস ইনিশিয়ালাইজ
  await BookmarkService.init();

  // ৪. অ্যাপ শুরুর সময় ডাটা ক্যাশ করা (অপশনাল কিন্তু ভালো প্র্যাকটিস)
  // এটি ব্যাকগ্রাউন্ডে কিতাব এবং চ্যাপ্টার লিস্ট রেডি রাখবে
  await DownloadLogic.cacheAllDataOnStart();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hadith AI',
      debugShowCheckedModeBanner: false,

      // থিম সেটআপ
      themeMode: ThemeMode.system,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,

      // অ্যাপের শুরু হবে স্প্ল্যাশ স্ক্রিন দিয়ে
      home: const SplashScreen(),

      // ডাইনামিক রাউটিং হ্যান্ডেলার
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/chapters/')) {
          final String bookSlug = settings.name!.replaceFirst('/chapters/', '');

          // রাউটের ভেতর ডার্ক মোড চেক করার সঠিক উপায়
          final isDark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

          return MaterialPageRoute(
            builder: (context) => ChapterListScreen(
              bookSlug: bookSlug,
              bookTitle: _getFormattedTitle(bookSlug),
              isDarkStatus: isDark,
            ),
          );
        }

        // ডিফল্ট রাুট (যদি কোনো রাুট ম্যাচ না করে)
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      },
    );
  }

  // স্লাগ থেকে সুন্দর টাইটেল তৈরি করা (sahih-bukhari -> Sahih Bukhari)
  String _getFormattedTitle(String slug) {
    try {
      if (slug.isEmpty) return "Hadith Book";
      return slug
          .split('-')
          .map((word) => word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1)
          : "")
          .join(' ');
    } catch (e) {
      return "Hadith Book";
    }
  }
}