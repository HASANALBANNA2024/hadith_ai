import 'package:flutter/material.dart';

class HadithListScreen extends StatefulWidget {
  final String bookTitle;
  final String chapterTitle;
  final bool isDarkStatus;

  const HadithListScreen({
    super.key,
    required this.bookTitle,
    required this.chapterTitle,
    required this.isDarkStatus,
  });

  @override
  State<HadithListScreen> createState() => _HadithListScreenState();
}

class _HadithListScreenState extends State<HadithListScreen> {
  // ডামি ডাটা (আপনার প্রজেক্ট অনুযায়ী আসবে)
  final List<Map<String, String>> hadithData = [
    {
      'number': '১',
      'title': 'হাদিস ১: নিয়তের উপর আমল',
      'narrator': 'বর্ণনায়: উমর ইবনুল খাত্তাব (রা.)',
      'text':
          'সকল আমল নিয়তের উপর নির্ভরশীল। প্রত্যেক ব্যক্তি তাই পাবে যার সে নিয়ত করবে।',
    },
    {
      'number': '২',
      'title': 'হাদিস ২: ওহী অবতীর্ণ হওয়া',
      'narrator': 'বর্ণনায়: আয়েশা (রা.)',
      'text':
          'রাসূলুল্লাহ (সাঃ)-এর প্রতি ওহী অবতীর্ণ হওয়া শুরু হয় সত্য স্বপ্নের মাধ্যমে...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 1100;

    // কালার প্যালেট (আপনার ড্যাশবোর্ড অনুযায়ী)
    const Color goldColor = Color(0xFFE4C381);
    const Color primaryTeal = Color(0xFF14532D);
    const Color darkBg = Color(0xFF0D1F1D);
    const Color darkCardBg = Color(0xFF111817);

    return Scaffold(
      backgroundColor: widget.isDarkStatus ? darkBg : const Color(0xFFF3F4F6),

      // AppBar ১১০০px উইডথ-এ লকড
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
                centerTitle: isWeb ? false : true,
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
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      widget.chapterTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 100,
                ),
                itemCount: hadithData.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildHadithCard(
                    hadithData[index],
                    widget.isDarkStatus,
                    isWeb,
                    goldColor,
                    primaryTeal,
                    darkCardBg,
                  );
                },
              ),
            ),
          ),

          // 'সূচিপত্র' ফ্লোটিং বাটন (১১০০px লজিক সহ)
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

      // বটম বার ১১০০px উইডথ-এ
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

  // হাদিস কার্ড ডিজাইন
  Widget _buildHadithCard(
    Map<String, String> hadith,
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
                  hadith['number']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? gold : teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hadith['title']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? gold : teal,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            Text(
              hadith['narrator']!,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hadith['text']!,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
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

  // বটম নেভিগেশন (আপনার ড্যাশবোর্ড অনুযায়ী)
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
