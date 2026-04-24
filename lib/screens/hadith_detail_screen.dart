import 'package:flutter/material.dart';

class HadithDetailScreen extends StatelessWidget {
  final String categoryName;
  final bool isDark; // থিম স্ট্যাটাস পাস করবেন

  // আপাতত ডামি ডাটা, পরে n8n থেকে আসবে
  final List<Map<String, String>> hadithList = [
    {
      "text": "The Prophet (ﷺ) said: 'The best among you are those who have the best manners and character.'",
      "reference": "Sahih Bukhari: 6035"
    },
    {
      "text": "The Prophet (ﷺ) said: 'None of you truly believes until he loves for his brother what he loves for himself.'",
      "reference": "Sahih Bukhari: 13"
    },
    {
      "text": "The Prophet (ﷺ) said: 'Allah is gentle and He loves gentleness, and He rewards for gentleness what He does not reward for harshness.'",
      "reference": "Sahih Muslim: 2593"
    },
  ];

  HadithDetailScreen({super.key, required this.categoryName, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // কালার স্কিম
    final Color goldColor = const Color(0xFFFFD700);
    final Color scaffoldBg = isDark ? const Color(0xFF021B19) : Colors.white;
    final Color cardBg = isDark ? const Color(0xFF03221F) : Colors.grey;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color borderCol = isDark ? goldColor.withOpacity(0.4) : Colors.black87.withOpacity(0.2);

    // স্ক্রিন সাইজ চেক (Web vs Mobile)
    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 800;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // ডিফল্ট ব্যাক বাটন বন্ধ করে আমরা কাস্টম বসাবো
        title: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100), // ১১০০ পিক্সেল লিমিট
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // কাস্টম ব্যাক বাটন (যাতে এটি ১১০০px এর ভেতর থাকে)
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: isDark ? goldColor : Colors.black87, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),

                // টাইটেল
                Expanded(
                  child: Text(
                    categoryName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? goldColor : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                // ডান পাশে ব্যালেন্স রাখার জন্য একটি খালি সাইজড বক্স (যাতে টাইটেল ঠিক মাঝখানে থাকে)
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100), // ওয়েবের জন্য ১১০০ পিক্সেল রুল
          padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: hadithList.length,
                  itemBuilder: (context, index) {
                    return _buildHadithCard(
                      hadithList[index]['text']!,
                      hadithList[index]['reference']!,
                      cardBg,
                      textColor,
                      borderCol,
                      goldColor,
                      isWeb,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // হাদিস কার্ড উইজেট
  Widget _buildHadithCard(
      String text,
      String ref,
      Color bg,
      Color textC,
      Color bColor,
      Color gold,
      bool isWeb
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(isWeb ? 30 : 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: bColor, width: 1.5),
        boxShadow: [
          if (!isDark) BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // আলংকারিক কোটেশন আইকন
          Icon(Icons.format_quote_rounded, color: gold.withOpacity(0.5), size: 30),

          Text(
            text,
            style: TextStyle(
              color: textC,
              fontSize: isWeb ? 20 : 16,
              height: 1.6,
              fontFamily: 'serif', // হাদিসের জন্য একটু ক্লাসিক লুক
            ),
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 0.5, color: Colors.grey),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // রেফারেন্স ট্যাগ
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ref,
                  style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),

              // অ্যাকশন বাটনসমূহ
              Row(
                children: [
                  _actionButton(Icons.copy_rounded, isDark),
                  const SizedBox(width: 10),
                  _actionButton(Icons.share_rounded, isDark),
                  const SizedBox(width: 10),
                  _actionButton(Icons.bookmark_border_rounded, isDark),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
      ),
      child: Icon(icon, size: 18, color: isDark ? Colors.white60 : Colors.black54),
    );
  }
}