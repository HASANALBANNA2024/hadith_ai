import 'package:flutter/material.dart';
import 'package:hadith_ai/api_service/hadith_api_service.dart';
import 'package:hadith_ai/model/chapter_model.dart';

import 'hadith_list_screen.dart';

class ChapterListScreen extends StatefulWidget {
  final String bookTitle;
  final String bookSlug;
  final bool isDarkStatus;

  const ChapterListScreen({
    super.key,
    required this.bookTitle,
    required this.bookSlug,
    required this.isDarkStatus,
  });

  @override
  State<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  // কালার ভেরিয়েবলগুলো এখানে ডিফাইন করা হয়েছে যাতে পুরো ক্লাসে ব্যবহার করা যায়
  final Color goldColor = const Color(0xFFE4C381);
  final Color primaryTeal = const Color(0xFF14532D);
  final Color darkBg = const Color(0xFF0D1F1D);
  final Color darkCardBg = const Color(0xFF111817);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // ছোট ওয়েব উইন্ডোতেও ওয়েব লেআউট কাজ করার জন্য ১১০০ পিক্সেল কন্ডিশন
    final bool isLargeScreen = screenWidth > 1100;

    return Scaffold(
      backgroundColor: widget.isDarkStatus ? darkBg : const Color(0xFFF3F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          color: widget.isDarkStatus ? const Color(0xFF112A27) : primaryTeal,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.bookTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          // web screen view constraints
          constraints: BoxConstraints(
            maxWidth: isLargeScreen ? 900 : double.infinity,
          ),
          child: Column(
            children: [
              _buildTopActions(widget.isDarkStatus, primaryTeal),
              Expanded(
                child: FutureBuilder<List<ChapterModel>>(
                  future: HadithApiService().fetchChapters(widget.bookSlug),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: goldColor),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "তথ্য লোড করতে সমস্যা হয়েছে!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "কোনো অধ্যায় পাওয়া যায়নি।",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    final chapters = snapshot.data!;
                    return isLargeScreen
                        ? GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // ওয়েবে পাশাপাশি ২টা কার্ড
                                  childAspectRatio: 5.0,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount: chapters.length,
                            itemBuilder: (context, index) => _buildChapterCard(
                              context,
                              chapters[index],
                              widget.isDarkStatus,
                              goldColor,
                              primaryTeal,
                              darkCardBg,
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            itemCount: chapters.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) => _buildChapterCard(
                              context,
                              chapters[index],
                              widget.isDarkStatus,
                              goldColor,
                              primaryTeal,
                              darkCardBg,
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(
        widget.isDarkStatus,
        goldColor,
        darkBg,
      ),
    );
  }

  Widget _buildTopActions(bool isDark, Color teal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "অধ্যায়সমূহ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(
    BuildContext context,
    ChapterModel chapter,
    bool isDark,
    Color gold,
    Color teal,
    Color darkCard,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      color: isDark ? darkCard : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HadithListScreen(
                bookTitle: widget.bookTitle,
                bookSlug: widget.bookSlug,
                chapterId: chapter.chapterNumber,

                chapterTitle: chapter.chapterTitle,
                isDarkStatus: isDark,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A2E2B)
                      : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    chapter.chapterNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? gold : teal,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  chapter.chapterTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.withOpacity(0.5),
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark, Color gold, Color darkBg) {
    return Container(
      color: isDark ? darkBg : Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1100),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark ? Colors.white10 : Colors.black12,
                      width: 0.5,
                    ),
                  ),
                ),
                child: BottomNavigationBar(
                  currentIndex: 1,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: gold,
                  unselectedItemColor: Colors.grey,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_filled),
                      label: 'হোম',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book),
                      label: 'গ্রন্থসমূহ',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark_outline),
                      label: 'সংরক্ষিত',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'সেটিংস',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
