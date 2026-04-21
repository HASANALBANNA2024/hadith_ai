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

  // ২. বক্স ওপেন করুন
  // টিপস: বক্সের নামগুলো 'DownloadLogic' এর ভ্যারিয়েবল থেকে নেওয়াই ভালো
  await Hive.openBox(DownloadLogic.metaBoxName);
  await Hive.openBox(DownloadLogic.cacheBoxName);

  // ৩. অন্যান্য সার্ভিস ইনিশিয়ালাইজ
  await BookmarkService.init();

  // ৪. অ্যাপ শুরুর সময় ডাটা ক্যাশ করা
  // সতর্কতা: এটি যদি অনেক বেশি সময় নেয়, তবে স্প্ল্যাশ স্ক্রিনে লোডিং দেখাবে
  try {
    await DownloadLogic.cacheAllDataOnStart();
  } catch (e) {
    print("Startup Cache Error: $e");
  }

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