import 'package:flutter/material.dart';
import 'package:hadith_ai/logic/bookmark_service.dart';
import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hadith_ai/widgets/app_theme.dart';
import 'package:hadith_ai/widgets/custom_bottom_nav.dart';
import 'package:hadith_ai/widgets/hadith_details_sheet.dart';
import 'package:hadith_ai/widgets/share_hadith.dart';

class BookmarkScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeChanged;


  const BookmarkScreen({super.key, required this.isDark,required this.onThemeChanged,});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<HadithModel> bookmarkedHadiths = [];
  final int _currentIndex = 2;

  late bool _localIsDark;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _localIsDark = widget.isDark;
  }

  void _loadBookmarks() {
    final data = BookmarkService.getAllBookmarks();
    if (mounted) {
      setState(() => bookmarkedHadiths = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 1100;

    final Color gold = AppThemes.accentGold;
    final Color scaffoldBg = widget.isDark
        ? AppThemes.darkBackground
        : AppThemes.lightBackground;
    final Color appBarBg = widget.isDark
        ? const Color(0xFF0D1F1D)
        : AppThemes.primaryGreen;
    final Color textColor = widget.isDark ? Colors.white : Colors.black87;
    final Color cardBg = widget.isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBg,
      // AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          color: appBarBg,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1100,
              ), // content area in web view 1100px
              child: AppBar(
                backgroundColor: Colors
                    .transparent,
                elevation: 0,
                centerTitle: true,
                leading: isWeb
                    ? null
                    : IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                title: Text(
                  'বুকমার্কস',
                  style: TextStyle(
                    color: gold,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  if (bookmarkedHadiths.isNotEmpty)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_sweep_outlined,
                        color: Colors.redAccent,
                      ),
                      onPressed: _showClearAllDialog,
                    ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      body: bookmarkedHadiths.isEmpty
          ? _buildEmptyState(textColor, gold)
          : Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: ListView.builder(
                  key: const ValueKey('bookmark_list_view'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: bookmarkedHadiths.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildBookmarkCard(
                        bookmarkedHadiths[index],
                        cardBg,
                        textColor,
                        gold,
                      ),
                    );
                  },
                ),
              ),
            ),
      // BottomNav

      bottomNavigationBar: Container(
        color: _localIsDark ? const Color(0xFF0D1F1D) : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              width: screenWidth,
              child: CustomBottomNav(
                isDark: _localIsDark,       // লোকাল ভেরিয়েবল ব্যবহার করুন
                gold: gold,
                isWeb: isWeb,
                currentIndex: _currentIndex,
                onThemeChanged: (newThemeValue) {
                  setState(() {
                    _localIsDark = newThemeValue; // থিম চেঞ্জ হলে স্টেট আপডেট হবে
                  });
                  // যদি মেইন অ্যাপের থিমও আপডেট করতে চান তবে নিচের লাইনটি কল করুন
                  widget.onThemeChanged(newThemeValue);
                },
                onTap: (index) {
                  // বুকমার্ক স্ক্রিন থেকে অন্য ট্যাবে যাওয়ার লজিক
                  if (index != 2) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildBookmarkCard(
    HadithModel hadith,
    Color bg,
    Color txt,
    Color gold,
  ) {
    return GestureDetector(
      key: ValueKey(hadith.hadithId),
      // to click full details sheet open for hadith
      onTap: () => _showHadithDetail(hadith),
      child: Card(
        color: bg,
        elevation: 1,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: widget.isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Book and Grade
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded, color: gold, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        hadith.bookName,
                        style: TextStyle(
                          color: gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    hadith.grade,
                    style: TextStyle(
                      color: gold.withOpacity(0.8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // arabic text in short on card
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  hadith.arabicText,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 2, // 2 line text
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    color: Color(0xFF4CAF50),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                hadith.translation,
                maxLines: 2, // only  two first in card
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: txt.withOpacity(0.9),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 0.3),
              const SizedBox(height: 8),

              // Hadith number and action button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hadith#: ${hadith.hadithNumber}",
                    style: TextStyle(color: txt.withOpacity(0.5), fontSize: 11),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share_outlined, size: 18),
                        onPressed: () => shareHadith(hadith),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark_remove_rounded,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                        onPressed: () async {
                          await BookmarkService.removeBookmark(hadith.hadithId);
                          _loadBookmarks();
                        },
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHadithDetail(HadithModel hadith) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          HadithDetailSheet(hadith: hadith, isDarkMode: widget.isDark),
    ).then((_) => _loadBookmarks());
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: const Text("all clear ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("NO"),
          ),
          TextButton(
            onPressed: () async {
              await BookmarkService.clearAll();
              _loadBookmarks();
              Navigator.pop(context);
            },
            child: const Text("yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color txt, Color gold) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 80,
            color: gold.withOpacity(0.2),
          ),
          const SizedBox(height: 15),
          Text(
            "No Bookmark",
            style: TextStyle(color: txt.withOpacity(0.5), fontSize: 16),
          ),
        ],
      ),
    );
  }
}
