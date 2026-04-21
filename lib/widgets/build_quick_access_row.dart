import 'package:flutter/material.dart';
import 'package:hadith_ai/screens/bookmark_screen.dart';

Widget buildQuickAccessRow(
  BuildContext context,
  bool isDark, // ২য় প্যারামিটার: _isDark
  Color bg, // ৩য় প্যারামিটার: cardBg
  Color gold, // ৪র্থ প্যারামিটার: gold
  Color border, // ৫র্থ প্যারামিটার: borderColor
  Color textC, // ৬ষ্ঠ প্যারামিটার: textColor
  bool isWeb, // ৭ম প্যারামিটার: isWeb
) {
  final allItems = [
    {'n': 'History', 'i': Icons.history_rounded},
    {'n': 'Notes', 'i': Icons.sticky_note_2_outlined},
    {'n': 'Bookmark', 'i': Icons.bookmark_border_rounded},
    {'n': 'Download', 'i': Icons.download_outlined},
  ];

  return Container(
    width: double.infinity,
    padding: EdgeInsets.only(top: isWeb ? 10 : 0, bottom: isWeb ? 20 : 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: allItems.map((e) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (e['n'] == 'Bookmark') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookmarkScreen(isDark: isDark),
                  ),
                );
              }
              // অন্যান্য লজিক এখানে...
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(vertical: isWeb ? 16 : 12),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black26
                        : Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(e['i'] as IconData, color: gold, size: isWeb ? 28 : 22),
                  const SizedBox(height: 6),
                  Text(
                    e['n'] as String,
                    style: TextStyle(
                      color: textC,
                      fontSize: isWeb ? 13 : 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
