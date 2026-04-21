import 'package:flutter/material.dart';
import 'package:hadith_ai/logic/bookmark_service.dart';
import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hadith_ai/widgets/app_theme.dart';
import 'package:hadith_ai/widgets/hadith_details_sheet.dart'; // পাথ চেক করুন
import 'package:hadith_ai/widgets/share_hadith.dart';

class BookmarkScreen extends StatefulWidget {
  final bool isDark;
  const BookmarkScreen({super.key, required this.isDark});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<HadithModel> bookmarkedHadiths = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  // ডাটা লোড করার ফাংশন
  void _loadBookmarks() {
    setState(() {
      bookmarkedHadiths = BookmarkService.getAllBookmarks();
    });
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
    final Color cardBg = widget.isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = widget.isDark ? Colors.white : Colors.black87;
    final Color borderColor = widget.isDark
        ? Colors.white10
        : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'বুকমার্কস',
          style: TextStyle(
            color: gold,
            fontSize: isWeb ? 22 : 18,
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
              onPressed: () => _showClearAllDialog(),
              tooltip: "সব মুছুন",
            ),
        ],
      ),
      body: bookmarkedHadiths.isEmpty
          ? _buildEmptyState(textColor, gold)
          : Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: bookmarkedHadiths.length,
                  itemBuilder: (context, index) {
                    final hadith = bookmarkedHadiths[index];
                    return GestureDetector(
                      onTap: () => _showHadithDetail(hadith),
                      child: _buildBookmarkCard(
                        hadith,
                        cardBg,
                        borderColor,
                        textColor,
                        gold,
                        isWeb,
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  // ডিটেইল শিট দেখানোর ফাংশন
  void _showHadithDetail(HadithModel hadith) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          HadithDetailSheet(hadith: hadith, isDarkMode: widget.isDark),
    ).then((_) => _loadBookmarks()); // শিট বন্ধ হলে লিস্ট রিফ্রেশ হবে
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          "সব মুছে ফেলবেন?",
          style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          "আপনি কি নিশ্চিত যে সব বুকমার্ক ডিলিট করতে চান?",
          style: TextStyle(
            color: widget.isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("না"),
          ),
          TextButton(
            onPressed: () async {
              await BookmarkService.clearAll();
              _loadBookmarks();
              if (mounted) Navigator.pop(context);
            },
            child: const Text("হ্যাঁ", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(
    HadithModel hadith,
    Color bg,
    Color border,
    Color txt,
    Color gold,
    bool isWeb,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: border),
        boxShadow: [
          if (!widget.isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.menu_book_rounded, color: gold, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          hadith.bookName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: gold,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: gold.withOpacity(0.2)),
                  ),
                  child: Text(
                    hadith.grade,
                    style: TextStyle(
                      color: gold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  hadith.arabicText,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    height: 1.6,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  hadith.translation,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: txt,
                    fontSize: isWeb ? 15 : 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "হাদিস নং: ${hadith.hadithNumber}",
                  style: TextStyle(color: txt.withOpacity(0.5), fontSize: 11),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined, size: 20),
                      color: gold,
                      onPressed: () =>
                          shareHadith(hadith), // আপনার গ্লোবাল শেয়ার ফাংশন
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.bookmark_remove_rounded,
                        size: 22,
                        color: Colors.redAccent,
                      ),
                      onPressed: () async {
                        await BookmarkService.removeBookmark(hadith.hadithId);
                        _loadBookmarks();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("বুকমার্ক সরানো হয়েছে"),
                              duration: Duration(milliseconds: 800),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border_rounded,
              size: 60,
              color: gold.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "কোনো বুকমার্ক সেভ করা নেই",
            style: TextStyle(
              color: txt.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
