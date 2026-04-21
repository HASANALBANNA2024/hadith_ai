import 'package:flutter/material.dart';
import 'package:hadith_ai/logic/bookmark_service.dart';
import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hadith_ai/screens/chapter_list_screen.dart';
import 'package:hadith_ai/screens/dashboard_screen.dart';
import 'package:hadith_ai/screens/splash_screen.dart';
import 'package:hadith_ai/widgets/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // final apiService = HadithApiService();
  // WidgetsFlutterBinding.ensureInitialized();
  // print("--- API Debugging Start ---");
  // await apiService.checkBookData("musnad-ahmad");
  // await apiService.checkBookData("silsila-sahiha");
  // print("--- API Debugging End ---");
  WidgetsFlutterBinding.ensureInitialized();
  // ১. হাইভ ইনিশিয়ালাইজ করুন
  await Hive.initFlutter();

  // ২. আপনার ডাউনলোড মেটাডাটা বক্সটি ওপেন করুন (এটি না করলে এরর যাবে না)
  await Hive.openBox('download_metadata');

  // Hive
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

      // থিম সেটআপ
      themeMode: ThemeMode.system,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,

      // অ্যাপের শুরু হবে স্প্ল্যাশ স্ক্রিন দিয়ে
      home: const SplashScreen(),

      // ডাইনামিক রাউটিং হ্যান্ডেলার
      onGenerateRoute: (settings) {
        // যদি রুট '/chapters/' দিয়ে শুরু হয়
        if (settings.name != null && settings.name!.startsWith('/chapters/')) {
          // ইউআরএল বা রুট থেকে বুক স্লাগ বের করা (যেমন: sahih-bukhari)
          final String bookSlug = settings.name!.replaceFirst('/chapters/', '');

          // বর্তমান থিম অনুযায়ী ডার্ক মোড চেক করা
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return MaterialPageRoute(
            builder: (context) => ChapterListScreen(
              bookSlug: bookSlug,
              bookTitle: _getFormattedTitle(
                bookSlug,
              ),
              isDarkStatus: isDark,
            ),
          );
        }

     return MaterialPageRoute(builder: (context) => HomeScreen());
      },
    );
  }


  String _getFormattedTitle(String slug) {
    try {
      return slug
          .split('-')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');
    } catch (e) {
      return "Hadith Book";
    }
  }
}
