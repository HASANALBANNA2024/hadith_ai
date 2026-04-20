import 'package:flutter/material.dart';
import 'package:hadith_ai/api_service/hadith_api_service.dart';
import 'package:hadith_ai/model/chapter_model.dart';

import 'hadith_list_screen.dart';

class ChapterListScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // এখানে ১১০০ এর বদলে ৭০০/৮০০ দিলে ছোট ওয়েব উইন্ডোতেও ওয়েব লেআউট কাজ করবে
    final bool isLargeScreen = screenWidth > 800;

    const Color goldColor = Color(0xFFE4C381);
    const Color primaryTeal = Color(0xFF14532D);
    const Color darkBg = Color(0xFF0D1F1D);
    const Color darkCardBg = Color(0xFF111817);

    return Scaffold(
      backgroundColor: isDarkStatus ? darkBg : const Color(0xFFF3F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          color: isDarkStatus ? const Color(0xFF112A27) : primaryTeal,
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
              bookTitle,
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
          // ওয়েবে স্ক্রিন খুব চওড়া না হয়ে মাঝখানে থাকবে
          constraints: BoxConstraints(
            maxWidth: isLargeScreen ? 900 : double.infinity,
          ),
          child: Column(
            children: [
              _buildTopActions(isDarkStatus, primaryTeal),
              Expanded(
                child: FutureBuilder<List<ChapterModel>>(
                  future: HadithApiService().fetchChapters(bookSlug),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
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

                    // debug print
                    final chapters = snapshot.data!;
                    return isLargeScreen
                        ? GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // ওয়েবে পাশাপাশি ২টা কার্ড
                                  childAspectRatio: 3.5,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount: chapters.length,
                            itemBuilder: (context, index) => _buildChapterCard(
                              context,
                              chapters[index],
                              isDarkStatus,
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
                              isDarkStatus,
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
      // ওয়েব এ বটম নেভবার ছোট দেখানোর জন্য
      bottomNavigationBar: isLargeScreen
          ? const SizedBox.shrink() // ওয়েবে চাইলে মেনু উপরে রাখতে পারেন, আপাতত বটম অফ করে দিলাম
          : _buildBottomNav(isDarkStatus, goldColor, darkBg),
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
          // Row(
          //   children: [
          //     _buildActionIcon(Icons.bookmark_outline, isDark, teal),
          //     const SizedBox(width: 10),
          //     _buildActionIcon(Icons.share_outlined, isDark, teal),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: isDark
            ? []
            : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isDark ? Colors.white70 : primaryColor,
          size: 22,
        ),
        onPressed: () {},
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
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      color: isDark ? darkCard : Colors.white,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HadithListScreen(
                bookTitle: bookTitle,
                bookSlug: bookSlug,
                chapterId: chapter.chapterId.toString(),
                chapterTitle: chapter.chapterTitle,
                isDarkStatus: isDark,
              ),
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2E2B) : const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              chapter.chapterNumber,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? gold : teal,
              ),
            ),
          ),
        ),
        title: Text(
          chapter.chapterTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          'হাদিস সংখ্যা: ${chapter.hadithCount ?? 0}', // null হলে ০ দেখাবে
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark, Color gold, Color darkBg) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkBg : Colors.white,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'হোম'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'গ্রন্থসমূহ',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'অনুসন্ধান'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: 'সংরক্ষিত',
          ),
        ],
      ),
    );
  }
}
