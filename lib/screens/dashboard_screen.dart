import 'package:flutter/material.dart';
import 'package:hadith_ai/screens/chapter_list_screen.dart';
import 'package:hadith_ai/widgets/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDark = true;

  // all section control variable
  bool _showAllBooks = false;
  bool _showAllQuickAccess = false;
  bool _showAllCategories = false;
  bool _showAllDailyLife = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 950;

    final Color gold = AppThemes.accentGold;
    final Color scaffoldBg = _isDark
        ? AppThemes.darkBackground
        : AppThemes.lightBackground;
    final Color appBarBg = _isDark
        ? const Color(0xFF0D1F1D)
        : AppThemes.primaryGreen;
    final Color cardBg = _isDark ? const Color(0xFF111817) : Colors.white;
    final Color textColor = _isDark ? Colors.white : Colors.black87;
    final Color borderColor = _isDark
        ? Colors.white10
        : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: true,
        title: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              children: [
                Text(
                  'আল-হাদীস',
                  style: TextStyle(
                    color: gold,
                    fontSize: isWeb ? 28 : 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  _isDark ? Icons.dark_mode : Icons.light_mode,
                  color: gold,
                  size: isWeb ? 24 : 18,
                ),
                Switch(
                  value: _isDark,
                  activeColor: gold,
                  onChanged: (value) => setState(() => _isDark = value),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: gold, size: isWeb ? 30 : 24),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // search section
            Container(
              color: appBarBg,
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 40, top: 10),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildSearchSection(isWeb, _isDark),
                ),
              ),
            ),

            // body content
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1100),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildHeader('আজকের হাদিস', textColor, isWeb),
                    _buildHeroCard(cardBg, gold, borderColor, textColor, isWeb),

                    const SizedBox(height: 20),
                    _buildHeader('হাদীস গ্রন্থসমূহ', textColor, isWeb),
                    _buildBookGrid(
                      screenWidth,
                      cardBg,
                      borderColor,
                      textColor,
                      isWeb,
                    ),
                    _buildSeeAllButton(
                      _showAllBooks,
                      () => setState(() => _showAllBooks = !_showAllBooks),
                      gold,
                      isWeb,
                    ),

                    const SizedBox(height: 20),
                    _buildHeader('দ্রুত অ্যাক্সেস', textColor, isWeb),
                    _buildQuickAccessRow(
                      cardBg,
                      gold,
                      borderColor,
                      textColor,
                      isWeb,
                    ),
                    _buildSeeAllButton(
                      _showAllQuickAccess,
                      () => setState(
                        () => _showAllQuickAccess = !_showAllQuickAccess,
                      ),
                      gold,
                      isWeb,
                    ),

                    const SizedBox(height: 20),
                    _buildHeader('হাদীস বিষয়ভিত্তিক', textColor, isWeb),
                    _buildCategoryWrap(borderColor, textColor, cardBg, isWeb),
                    _buildSeeAllButton(
                      _showAllCategories,
                      () => setState(
                        () => _showAllCategories = !_showAllCategories,
                      ),
                      gold,
                      isWeb,
                    ),

                    const SizedBox(height: 20),
                    _buildHeader('দৈনন্দিন জীবনের হাদীস', textColor, isWeb),
                    _buildDailyLifeSection(
                      cardBg,
                      borderColor,
                      textColor,
                      AppThemes.primaryGreen,
                      isWeb,
                    ),
                    _buildSeeAllButton(
                      _showAllDailyLife,
                      () => setState(
                        () => _showAllDailyLife = !_showAllDailyLife,
                      ),
                      gold,
                      isWeb,
                    ),

                    const SizedBox(height: 20),
                    _buildHeader('সাম্প্রতিক পঠিত', textColor, isWeb),
                    _buildRecentReadCard(cardBg, borderColor, textColor, isWeb),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: _isDark ? const Color(0xFF0D1F1D) : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: isWeb ? 1100 : screenWidth,
              child: _buildBottomNav(_isDark, appBarBg, gold, isWeb),
            ),
          ],
        ),
      ),
    );
  }

  // ---Helper Widgets ---

  Widget _buildHeader(String title, Color color, bool isWeb) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isWeb ? 22 : 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSeeAllButton(
    bool isExpanded,
    VoidCallback onTap,
    Color gold,
    bool isWeb,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: gold,
          size: 20,
        ),
        label: Text(
          isExpanded ? 'কম দেখুন' : 'সব দেখুন',
          style: TextStyle(
            color: gold,
            fontWeight: FontWeight.bold,
            fontSize: isWeb ? 15 : 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(bool isWeb, bool isDark) {
    return Container(
      constraints: BoxConstraints(maxWidth: isWeb ? 650 : double.infinity),
      height: isWeb ? 50 : 45,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Center(
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: isWeb ? 16 : 14,
          ),
          decoration: InputDecoration(
            hintText: 'হাদীস খুঁজুন...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
              size: isWeb ? 22 : 20,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildBookGrid(
    double width,
    Color bg,
    Color border,
    Color textC,
    bool isWeb,
  ) {
    final allBooks = [
      {'t': 'সহীহ বুখারী', 'c': '৭৫৬৩', 'color': Colors.teal},
      {'t': 'সহীহ মুসলিম', 'c': '৭৫০০', 'color': Colors.green},
      {'t': 'সুনান আবু দাউদ', 'c': '৫২৭৪', 'color': Colors.orange},
      {'t': 'সুনান তিরমিযী', 'c': '৩৯৫৬', 'color': Colors.red},
      {'t': 'সুনান নাসাঈ', 'c': '৫৭৫৮', 'color': Colors.blue},
      {'t': 'ইবনে মাজাহ', 'c': '৪৩৪১', 'color': Colors.purple},
      {'t': 'মুয়াত্তা মালিক', 'c': '১৭২০', 'color': Colors.brown},
      {'t': 'রিয়াদুস সালেহীন', 'c': '১৯০৫', 'color': Colors.indigo},
    ];

    // _showAllBooks ভেরিয়েবলটি আপনার স্টেট অনুযায়ী কাজ করবে
    final displayedBooks = _showAllBooks ? allBooks : allBooks.take(6).toList();
    int columns = width > 1000 ? 6 : (width > 700 ? 4 : 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayedBooks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: isWeb ? 1.0 : 0.85,
      ),
      itemBuilder: (context, i) {
        final book = displayedBooks[i];

        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // বইয়ের নাম নিয়ে ChapterListScreen-এ নেভিগেশন
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterListScreen(
                    bookTitle: book['t'] as String,
                    isDarkStatus:
                        _isDark, // আপনার ড্যাশবোর্ডের ডার্ক মোড ভেরিয়েবলটি এখানে দিন
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: book['color'] as Color,
                  size: isWeb ? 35 : 24,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    book['t'] as String,
                    style: TextStyle(
                      color: textC,
                      fontWeight: FontWeight.bold,
                      fontSize: isWeb ? 14 : 11,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickAccessRow(
    Color bg,
    Color gold,
    Color border,
    Color textC,
    bool isWeb,
  ) {
    final allItems = [
      {'n': 'পছন্দ', 'i': Icons.favorite_border},
      {'n': 'ইতিহাস', 'i': Icons.history},
      {'n': 'নোটস', 'i': Icons.edit_note},
      {'n': 'সেভ', 'i': Icons.bookmark_border},
      {'n': 'শেয়ার', 'i': Icons.share},
      {'n': 'ডাউনলোড', 'i': Icons.download},
      {'n': 'তালিক', 'i': Icons.list_alt},
      {'n': 'সেটিংস', 'i': Icons.settings_outlined},
    ];
    final displayedItems = _showAllQuickAccess
        ? allItems
        : allItems.take(6).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = isWeb ? 6 : 3;
        double spacing = 10.0;
        double cardWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
            crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: displayedItems.map((e) {
            return Container(
              width: cardWidth,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(e['i'] as IconData, color: gold, size: isWeb ? 26 : 22),
                  const SizedBox(height: 8),
                  Text(
                    e['n'] as String,
                    style: TextStyle(
                      color: textC,
                      fontSize: isWeb ? 14 : 11,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCategoryWrap(Color border, Color textC, Color bg, bool isWeb) {
    final allTags = [
      'ঈমান',
      'নামায',
      'রোযা',
      'হজ্জ',
      'আখলাক',
      'দুয়া ও যিকির',
      'জান্নাত',
      'জাহান্নাম',
      'লেনদেন',
      'পরিবার',
      'কুরআন',
      'হাদীস',
      'তওবা',
      'সালাত',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // all show more
        List<String> displayedTags;

        if (_showAllCategories) {
          displayedTags = allTags;
        } else {
          // mobile view and web view
          double estimatedTagWidth = isWeb ? 120 : 90;
          int tagsPerRow = (constraints.maxWidth / estimatedTagWidth).floor();
          displayedTags = allTags.take(tagsPerRow).toList();
        }

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.start,
            children: displayedTags
                .map(
                  (t) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 25 : 16,
                      vertical: isWeb ? 12 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: border),
                    ),
                    child: Text(
                      t,
                      style: TextStyle(
                        color: textC,
                        fontSize: isWeb ? 15 : 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildDailyLifeSection(
    Color bg,
    Color border,
    Color textC,
    Color iconC,
    bool isWeb,
  ) {
    final allItems = [
      'সকালে ও সন্ধ্যায় পড়ার দোয়া',
      'খাওয়ার আদব ও সুন্নাত',
      'ঘুমের দোয়া ও আমল',
      'মসজিদে প্রবেশের দুয়া',
      'রাস্তার হক',
      'পোশাক পরিধান',
    ];
    final displayedItems = _showAllDailyLife
        ? allItems
        : allItems.take(3).toList();

    return Column(
      children: displayedItems
          .map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(isWeb ? 25 : 15),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.stars_rounded,
                    size: isWeb ? 28 : 22,
                    color: iconC,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(color: textC, fontSize: isWeb ? 18 : 14),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildHeroCard(
    Color bg,
    Color gold,
    Color border,
    Color textC,
    bool isWeb,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWeb ? 45 : 24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, color: gold, size: isWeb ? 40 : 26),
          const SizedBox(height: 20),
          Text(
            "“প্রকৃত মুসলিম সেই ব্যক্তি, যার জিহ্বা ও হাত থেকে অন্য মুসলিম নিরাপদ থাকে।”",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textC,
              fontSize: isWeb ? 22 : 16,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "- সহীহ বুখারী",
            style: TextStyle(color: gold, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReadCard(Color bg, Color border, Color textC, bool isWeb) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_book, color: Colors.orange),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "সহীহ বুখারী - হাদিস নং ১",
                  style: TextStyle(color: textC, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "নিশ্চয়ই নিয়তের ওপর আমল নির্ভরশীল...",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isDark, Color bg, Color gold, bool isWeb) {
    return Container(
      // gap of bottom
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1F1D) : Colors.white,
        boxShadow: [
          BoxShadow(
            // light mode
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
            // blurRadius: 15,
            // spreadRadius: 0,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: gold,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        iconSize: isWeb ? 32 : 24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'হোম'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'গ্রন্থসমূহ',
          ),
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
