import 'package:flutter/material.dart';
import 'package:hadith_ai/model/hadith_model.dart';

class HadithListScreen extends StatefulWidget {
  final String bookTitle;
  final String bookSlug;
  final String chapterId;
  final String chapterTitle;
  final bool isDarkStatus;

  const HadithListScreen({
    super.key,
    required this.bookTitle,
    required this.bookSlug,
    required this.chapterId,
    required this.chapterTitle,
    required this.isDarkStatus,
  });

  @override
  State<HadithListScreen> createState() => _HadithListScreenState();
}

class _HadithListScreenState extends State<HadithListScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 1100;

    const Color goldColor = Color(0xFFE4C381);
    const Color primaryTeal = Color(0xFF14532D);
    const Color darkBg = Color(0xFF0D1F1D);
    const Color darkCardBg = Color(0xFF111817);

    return Scaffold(
      backgroundColor: widget.isDarkStatus ? darkBg : const Color(0xFFF3F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          color: widget.isDarkStatus ? const Color(0xFF112A27) : primaryTeal,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: !isWeb,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Column(
                  crossAxisAlignment: isWeb
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.bookTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      widget.chapterTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
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
      body: Stack(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: FutureBuilder<List<HadithModel>>(
                // future: HadithApiService().fetchHadiths(widget.bookSlug, widget.chapterId),
                future: Future.value([]), // আপনার এপিআই কল এখানে দিন
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: goldColor),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "লোড করতে সমস্যা হয়েছে!",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "কোনো হাদিস পাওয়া যায়নি।",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final hadiths = snapshot.data!;

                  return ListView.separated(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: 100,
                    ),
                    itemCount: hadiths.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildHadithCard(
                        hadiths[index],
                        widget.isDarkStatus,
                        isWeb,
                        goldColor,
                        primaryTeal,
                        darkCardBg,
                      );
                    },
                  );
                },
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1100),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: FloatingActionButton.extended(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: primaryTeal,
                  elevation: 4,
                  icon: const Icon(Icons.menu_open, color: Colors.white),
                  label: const Text(
                    'সূচিপত্র',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: widget.isDarkStatus ? darkBg : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              width: screenWidth,
              child: _buildBottomNav(widget.isDarkStatus, goldColor, isWeb),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHadithCard(
    HadithModel hadith,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  hadith.hadithNumber,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? gold : teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "হাদিস নং: ${hadith.hadithNumber}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? gold : teal,
                    ),
                  ),
                ),
                // হাদিসের গ্রেড (সহীহ/হাসান) দেখানো
                if (hadith.grade.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(hadith.gradeColor),
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      hadith.grade,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(int.parse(hadith.gradeColor)),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            Text(
              hadith.narrator,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (hadith.arabicText.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  hadith.arabicText,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 22,
                    height: 1.8,
                    color: isDark ? Colors.white : Colors.black,
                    fontFamily: 'Amiri',
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              hadith.translation,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
              ),
            ),

            // ট্যাগস (যদি থাকে)
            if (hadith.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  spacing: 8,
                  children: hadith.tags
                      .map(
                        (tag) => Text(
                          "#$tag",
                          style: TextStyle(color: gold, fontSize: 12),
                        ),
                      )
                      .toList(),
                ),
              ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _cardActionIcon(Icons.share_outlined, isDark),
                _cardActionIcon(Icons.bookmark_border, isDark),
                _cardActionIcon(Icons.copy_outlined, isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardActionIcon(IconData icon, bool isDark) {
    return Icon(icon, color: isDark ? Colors.white38 : Colors.grey, size: 22);
  }

  Widget _buildBottomNav(bool isDark, Color gold, bool isWeb) {
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
