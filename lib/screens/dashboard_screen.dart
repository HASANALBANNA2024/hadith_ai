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
  bool isExpanded = false; // এটি স্টেট ক্লাসের ভেতরে থাকতে হবে

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
                    // const SizedBox(height: 20),
                    _buildHeader('দ্রুত অ্যাক্সেস', textColor, isWeb),
                    _buildQuickAccessRow(
                      cardBg,
                      gold,
                      borderColor,
                      textColor,
                      isWeb,
                    ),

                    // const SizedBox(height: 20),
                    _buildHeader('হাদীস বিষয়ভিত্তিক', textColor, isWeb),
                    _buildCategoryWrap(borderColor, textColor, cardBg, isWeb),

                    // const SizedBox(height: 20),
                    _buildHeader('দৈনন্দিন জীবনের হাদীস', textColor, isWeb),
                    _buildDailyLifeSection(
                      cardBg,
                      borderColor,
                      textColor,
                      AppThemes.primaryGreen,
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
    final List<String> sahihSittahSlugs = [
      'sahih-bukhari',
      'sahih-muslim',
      'al-tirmidhi',
      'abu-dawood',
      'ibn-e-majah',
      'sunan-nasai',
    ];

    final filteredBooks = books
        .where((b) => sahihSittahSlugs.contains(b.bookSlug))
        .toList();

    // --- আপডেট: কলাম সংখ্যা লজিক ---
    // আপনার রিকোয়ারমেন্ট অনুযায়ী ৭০০ এর বেশি হলে ৪টি, ১১০০ এর বেশি হলে ৬টি
    int columns = width > 1100 ? 6 : (width > 700 ? 4 : (width > 500 ? 3 : 2));

    // আইটেম কাউন্ট নির্ধারণ (Toggle Logic)
    int displayCount = (width <= 500 && !isExpanded) ? 2 : filteredBooks.length;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // বাটনকে ডানপাশে রাখবে
      children: [
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: isWeb ? 1.0 : (width <= 500 ? 1.15 : 0.92),
          ),
          itemBuilder: (context, i) {
            final book = filteredBooks[i];
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
                        bookTitle: book.bookName,
                        bookSlug: book.bookSlug,
                        isDarkStatus: _isDark,
                      ),
                      settings: RouteSettings(
                        name: '/chapters/${book.bookSlug}',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        dynamicIcon,
                        color: dynamicColor,
                        size: isWeb ? 28 : 24,
                      ),
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // বাটন শুধুমাত্র মোবাইল ভিউতে এবং কিতাব বেশি থাকলে ডানপাশে দেখাবে
        if (width <= 500 && filteredBooks.length > 2)
          Padding(
            padding: EdgeInsets.zero,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              icon: Icon(
                isExpanded
                    ? Icons.arrow_back_ios_new_outlined
                    : Icons.arrow_drop_down_circle_outlined,
                color: const Color(0xFFB8860B),
                size: 18,
              ),
              label: Text(
                isExpanded ? "কম দেখুন" : "সব দেখুন",
                style: const TextStyle(
                  color: Color(0xFFB8860B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
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

  Widget _buildQuickAccessRow(
    Color bg,
    Color gold,
    Color border,
    Color textC,
    bool isWeb,
  ) {
    final allItems = [
      {'n': 'History', 'i': Icons.history_rounded},
      {'n': 'Notes', 'i': Icons.sticky_note_2_outlined},
      {'n': 'Bookmark', 'i': Icons.bookmark_border_rounded},
      {'n': 'Download', 'i': Icons.download_outlined},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: allItems.map((e) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 4,
              ), // কার্ডগুলোর মাঝে গ্যাপ
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border.withOpacity(0.5)),
                // হালকা শ্যাডো দিতে পারেন প্রিমিয়াম লুকের জন্য
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(e['i'] as IconData, color: gold, size: isWeb ? 28 : 22),
                  const SizedBox(height: 8),
                  Text(
                    e['n'] as String,
                    maxLines: 1, // এক লাইনে রাখার জন্য
                    overflow: TextOverflow.ellipsis, // নাম বড় হলে ডট ডট দেখাবে
                    style: TextStyle(
                      color: textC,
                      fontSize: isWeb ? 13 : 10,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
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
