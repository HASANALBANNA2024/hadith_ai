import 'package:flutter/material.dart';
import 'package:hadith_ai/screens/bookmark_screen.dart';
import 'package:hadith_ai/widgets/settings_sheet.dart';

class CustomBottomNav extends StatelessWidget {
  final bool isDark;
  final Color gold;
  final bool isWeb;
  final int currentIndex;
  final Function(int) onTap;
  final Function(bool) onThemeChanged;

  const CustomBottomNav({
    super.key,
    required this.isDark,
    required this.gold,
    required this.isWeb,
    required this.currentIndex,
    required this.onTap,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // screen size check
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookmarkScreen(isDark: isDark, onThemeChanged: onThemeChanged),
              ),
            );
          } else if (index == 3) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                // এখন আর এখানে রেড লাইন আসবে না
                return SettingsSheet(
                  isDarkMode: isDark,
                  onThemeChanged: onThemeChanged,
                );
              },
            );
          } else {
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
