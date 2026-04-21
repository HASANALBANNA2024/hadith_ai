import 'package:flutter/material.dart';
import 'package:hadith_ai/api_service/hadith_api_service.dart';
import 'package:hadith_ai/model/hadith_book_model.dart';
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
    final bool isWeb = screenWidth > 1100;

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

      appBar: PreferredSize(
        // এখানে হাইট কমিয়ে ৪৫-৫০ এর মধ্যে রাখলে এটি অনেক স্লিম দেখাবে
        preferredSize: Size.fromHeight(isWeb ? 60 : 48),
        child: AppBar(
          backgroundColor: appBarBg,
          elevation: 0,
          automaticallyImplyLeading: false, // বাড়তি জায়গা খালি করবে
          title: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              // মোবাইল এবং ওয়েব অনুযায়ী প্যাডিং অ্যাডজাস্ট করা হয়েছে
              padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // টাইটেল - ফন্ট সাইজ এবং স্পেসিং অপ্টিমাইজড
                  Text(
                    'আল-হাদীস',
                    style: TextStyle(
                      color: gold,
                      fontSize: isWeb
                          ? 24
                          : 20, // সামান্য কমানো হয়েছে ক্লিনিংয়ের জন্য
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),

                  // থিম টগল (আইকন এবং সুইচকে একটি ছোট রো-তে রাখা হয়েছে)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: gold.withOpacity(0.8),
                        size: isWeb ? 22 : 18,
                      ),
                      // ট্রান্সফর্ম ব্যবহার করে সুইচটিকে ছোট করা হয়েছে
                      Transform.scale(
                        scale: isWeb ? 0.8 : 0.7,
                        child: Switch(
                          value: _isDark,
                          activeColor: gold,
                          onChanged: (value) => setState(() => _isDark = value),
                        ),
                      ),
                    ],
                  ),

                  // সার্চ বাটন - যদি চ্যাটবট থাকে তবে এটি ছোট রাখা ভালো
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.search_rounded,
                      color: gold,
                      size: isWeb ? 26 : 22,
                    ),
                    onPressed: () {
                      // সার্চ লজিক
                    },
                  ),
                ],
              ),
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
                    // const SizedBox(height: 10),
                    _buildHeader('আজকের হাদিস', textColor, isWeb),
                    _buildHeroCard(cardBg, gold, borderColor, textColor, isWeb),

                    // const SizedBox(height: 20),
                    _buildHeader('হাদীস গ্রন্থসমূহ', textColor, isWeb),

                    // --- API API Integration Started ---
                    // --- হাদীস গ্রন্থসমূহ সেকশন ---
                    FutureBuilder<List<HadithBookModel>>(
                      // এখানে আপনার সার্ভিস মেথডটি কল হচ্ছে
                      future: HadithApiService().fetchAllBooks(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(
                                color: Color(0xFFE4C381),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              "ডাটা লোড করতে সমস্যা হয়েছে!",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "কোনো গ্রন্থ পাওয়া যায়নি।",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        final allBooks = snapshot.data!;
                        final displayedBooks = _showAllBooks
                            ? allBooks
                            : allBooks.take(6).toList();

                        return _buildBookGrid(
                          screenWidth,
                          cardBg,
                          borderColor,
                          textColor,
                          isWeb,
                          displayedBooks,
                        );
                      },
                    ),

                    _buildSeeAllButton(
                      _showAllBooks,
                      () => setState(() => _showAllBooks = !_showAllBooks),
                      gold,
                      isWeb,
                    ),

                    // const SizedBox(height: 20),
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

                    // const SizedBox(height: 20),
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

                    // const SizedBox(height: 20),
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

                    // const SizedBox(height: 20),
                    _buildHeader('সাম্প্রতিক পঠিত', textColor, isWeb),
                    _buildRecentReadCard(cardBg, borderColor, textColor, isWeb),

                    // const SizedBox(height: 50),
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

  // --- Helper Widgets ---

  Widget _buildBookGrid(
    double width,
    Color bg,
    Color border,
    Color textC,
    bool isWeb,
    List<HadithBookModel> books,
  ) {
    // final filteredBooks = books.where((book) {
    //   return book.hadithCount != null && book.hadithCount != '0' && book.hadithCount != '';
    // }).toList();
    final filteredBooks = books;

    int columns = width > 1100 ? 6 : (width > 800 ? 4 : (width > 500 ? 3 : 2));

    final List<IconData> islamicIcons = [
      Icons.menu_book_rounded,
      Icons.auto_stories,
      Icons.book_rounded,
      Icons.import_contacts,
      Icons.library_books,
      Icons.collections_bookmark_rounded,
    ];

    final List<Color> iconColors = [
      const Color(0xFFE4C381),
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFF44336),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredBooks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: isWeb ? 1.0 : 0.92,
      ),
      itemBuilder: (context, i) {
        final book = filteredBooks[i]; // এখান থেকে বইয়ের ডেটা পাওয়া যাচ্ছে
        final dynamicIcon = islamicIcons[i % islamicIcons.length];
        final dynamicColor = iconColors[i % iconColors.length];

        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: border.withOpacity(0.3), width: 1),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterListScreen(
                    bookTitle:
                        book.bookName, // 'book' অবজেক্ট থেকে নাম নেওয়া হয়েছে
                    bookSlug: book
                        .bookSlug, // 'book' অবজেক্ট থেকে স্ল্যাগ নেওয়া হয়েছে
                    isDarkStatus: _isDark, // আপনার বর্তমান থিম স্ট্যাটাস
                  ),
                  // ওয়েব ইউজারদের জন্য রাউট সেটিংস
                  settings: RouteSettings(name: '/chapters/${book.bookSlug}'),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(dynamicIcon, color: dynamicColor, size: isWeb ? 28 : 24),
                  const SizedBox(height: 6),
                  Text(
                    book.bookNameArabic ?? "",
                    style: const TextStyle(
                      color: Color(0xFFB8860B),
                      fontSize: 14,
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.bookName,
                    style: TextStyle(
                      color: textC,
                      fontWeight: FontWeight.w900,
                      fontSize: isWeb ? 12 : 10.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 6,
                  //     vertical: 2,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: textC.withOpacity(0.05),
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  //   // child: Text(
                  //   //   "${book.hadithCount} HADITHS",
                  //   //   style: TextStyle(
                  //   //     color: textC.withOpacity(0.6),
                  //   //     fontSize: 8,
                  //   //     fontWeight: FontWeight.bold,
                  //   //   ),
                  //   // ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // (বাকি সকল হেল্পার মেথড যেমন Header, SearchSection, HeroCard, BottomNav ইত্যাদি আপনার অরিজিনাল কোডের মতোই থাকবে)

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
    return Center(
      child: Container(
        // ম্যাক্স উইডথ ওয়েব এর জন্য আরও একটু কমিয়ে স্লিম করা হয়েছে
        constraints: BoxConstraints(maxWidth: isWeb ? 500 : double.infinity),
        height: isWeb ? 42 : 38, // হাইট আরও কমানো হয়েছে
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.03),
          ),
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: isWeb ? 15 : 13, // ফন্ট সাইজ কমানো হয়েছে
          ),
          decoration: InputDecoration(
            hintText: 'হাদীস বা দোয়া খুঁজুন...',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.grey[500],
              size: isWeb ? 20 : 18,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(
              bottom: 2,
            ), // টেক্সট ভার্টিক্যাল এলাইনমেন্ট
            isDense: true,
          ),
        ),
      ),
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
    final allTags = ['ঈমান', 'নামায', 'রোযা', 'হজ্জ', 'আখলাক', 'দুয়া ও যিকির'];
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: allTags
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
                  style: TextStyle(color: textC, fontSize: isWeb ? 15 : 13),
                ),
              ),
            )
            .toList(),
      ),
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
    ];
    return Column(
      children: allItems
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

  // daily hadith section
  Widget _buildHeroCard(
    Color bg,
    Color gold,
    Color border,
    Color textC,
    bool isWeb,
  ) {
    return Container(
      width: double.infinity,
      // constraints যোগ করা হয়েছে যাতে খুব বেশি লম্বা না হয় আবার ওভারফ্লোও না করে
      constraints: BoxConstraints(
        minHeight: isWeb ? 120 : 100, // একটি মিনিমাম স্লিম হাইট
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 30 : 16,
        vertical: isWeb ? 20 : 14,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border.withOpacity(0.4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // এটিই ওভারফ্লো আটকানোর প্রধান অস্ত্র
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ছোট আইকন
          Icon(Icons.auto_awesome, color: gold, size: isWeb ? 24 : 18),

          const SizedBox(height: 10),

          Text(
            "“প্রকৃত মুসলিম সেই ব্যক্তি, যার জিহ্বা ও হাত থেকে অন্য মুসলিম নিরাপদ থাকে।”",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textC,
              fontSize: isWeb ? 17 : 13, // স্লিম লুকের জন্য সাইজ কমানো
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "- সহীহ বুখারী",
            style: TextStyle(
              color: gold,
              fontWeight: FontWeight.bold,
              fontSize: isWeb ? 13 : 11,
            ),
          ),
        ],
      ),
    );
  }
  // hero card ended

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
