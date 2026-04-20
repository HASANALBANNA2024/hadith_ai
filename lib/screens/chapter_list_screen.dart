import 'package:flutter/material.dart';

import 'hadith_list_screen.dart';

class ChapterListScreen extends StatelessWidget {
  final String bookTitle;
  final bool
  isDarkStatus; // ড্যাশবোর্ড থেকে ডার্ক মোড স্ট্যাটাস রিসিভ করার জন্য

  const ChapterListScreen({
    super.key,
    required this.bookTitle,
    required this.isDarkStatus,
  });

  @override
  Widget build(BuildContext context) {
    // এখানে আপনার দেওয়া ১১০০px উইডথ লজিক
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 1100;

    // আপনার ড্যাশবোর্ডের সেই নির্দিষ্ট কালার প্যালেট
    const Color goldColor = Color(0xFFE4C381);
    const Color primaryTeal = Color(0xFF14532D);
    const Color darkBg = Color(0xFF0D1F1D);
    const Color darkCardBg = Color(0xFF111817);

    final List<Map<String, String>> chaptersData = [
      {'id': '১', 'title': 'ওহীর সূচনা অধ্যায়', 'count': '১-৭ টি হাদিস'},
      {'id': '২', 'title': 'ঈমান অধ্যায়', 'count': '৮-৫৮ টি হাদিস'},
      {'id': '৩', 'title': 'ইলম বা জ্ঞান অধ্যায়', 'count': '৫৯-৮২ টি হাদিস'},
      {'id': '৪', 'title': 'ওযু অধ্যায়', 'count': '৮৩-১৪৭ টি হাদিস'},
      {'id': '৫', 'title': 'গোসল অধ্যায়', 'count': '১৪৮-১৬৯ টি হাদিস'},
    ];

    return Scaffold(
      // ড্যাশবোর্ড থেকে আসা স্ট্যাটাস অনুযায়ী ব্যাকগ্রাউন্ড চেঞ্জ হবে
      backgroundColor: isDarkStatus ? darkBg : const Color(0xFFF3F4F6),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          color: isDarkStatus ? const Color(0xFF112A27) : primaryTeal,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: isWeb ? false : true,
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
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionIcon(
                      Icons.bookmark_outline,
                      isDarkStatus,
                      primaryTeal,
                    ),
                    const SizedBox(width: 10),
                    _buildActionIcon(
                      Icons.share_outlined,
                      isDarkStatus,
                      primaryTeal,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: 5,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    // ১. চ্যাপ্টার ডাটা থেকে নাম নিয়ে নিন (যদি আপনার লিস্টের নাম chaptersData হয়)
                    final String chapterTitle = chaptersData[index]['title']!;

                    return _buildChapterCard(
                      context, // ২. এটি যোগ করুন (BuildContext)
                      index + 1, // id
                      chapterTitle, // ৩. এটি যোগ করুন (Chapter Name)
                      isDarkStatus,
                      isWeb,
                      goldColor,
                      primaryTeal,
                      darkCardBg,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        color: isDarkStatus ? darkBg : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              width: screenWidth,
              child: _buildDashboardStyleNav(isDarkStatus, goldColor, isWeb),
            ),
          ],
        ),
      ),
    );
  }

  // --- হেল্পার উইজেটগুলো নিচে দেওয়া হলো ---

  Widget _buildActionIcon(IconData icon, bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        shape: BoxShape.circle,
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

  // chapter
  Widget _buildChapterCard(
    BuildContext context, // নেভিগেশনের জন্য context লাগবে
    int id,
    String chapterName, // চ্যাপ্টারের নাম পাস করতে হবে
    bool isDark,
    bool isWeb,
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
          // --- এখানে কল হবে HadithListScreen ---
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HadithListScreen(
                bookTitle: "সহীহ বুখারী", // আপনার ভেরিয়েবল থেকে আসবে
                chapterTitle: chapterName, // এই চ্যাপ্টারের নাম যাবে
                isDarkStatus: isDark, // ডার্ক মোড স্ট্যাটাস
              ),
            ),
          );
        },
        contentPadding: EdgeInsets.all(isWeb ? 20.0 : 12.0),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2E2B) : const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$id',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? gold : teal,
              ),
            ),
          ),
        ),
        title: Text(
          chapterName, // ডাইনামিক নাম শো করবে
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: const Text(
          '১-১০ টি হাদিস',
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.withOpacity(0.3),
          size: 16,
        ),
      ),
    );
  }
  // chapter

  Widget _buildDashboardStyleNav(bool isDark, Color gold, bool isWeb) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black12,
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'সেটিংস'),
        ],
      ),
    );
  }
}
