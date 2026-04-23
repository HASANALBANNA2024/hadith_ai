import 'package:flutter/material.dart';
import 'package:hadith_ai/screens/bookmark_screen.dart';
import 'package:hadith_ai/widgets/settings_sheet.dart';

class CustomBottomNav extends StatelessWidget {
  final bool isDark;
  final Color gold;
  final bool isWeb;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.isDark,
    required this.gold,
    required this.isWeb,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // স্ক্রিন সাইজ চেক করা
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // ওয়েব হলে একটা নির্দিষ্ট চওড়া থাকবে, মোবাইল হলে পুরো স্ক্রিন
      width: isWeb ? 1100 : screenWidth,
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1F1D) : Colors.white,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: currentIndex,
        selectedItemColor: gold,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        iconSize: isWeb ? 32 : 24,
        onTap: (index) {
          if (index == 2) {
            // বুকমার্ক স্ক্রিনে যাওয়ার জন্য
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookmarkScreen(isDark: isDark),
              ),
            );
          } else if (index == 3) {
            // সেটিংস আইটেমে ক্লিক করলে শুধুমাত্র UI শিটটি ওপেন হবে
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                // শুধু ডার্ক মোড স্ট্যাটাস পাস করছি, বাকিগুলো পরে অ্যাড করবেন
                return SettingsSheet(isDarkMode: isDark);
              },
            );
          } else {
            // অন্য ট্যাবের জন্য মেইন স্ক্রিনের স্টেট আপডেট করবে
            onTap(index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Books'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: 'Save',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
