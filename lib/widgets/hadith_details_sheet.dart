import 'package:flutter/material.dart';
import 'package:hadith_ai/model/hadith_model.dart';

class HadithDetailSheet extends StatelessWidget {
  final HadithModel hadith;
  // কনস্ট্রাক্টরে directly 'isDarkMode' প্যারামিটার নেওয়া হচ্ছে
  final bool isDarkMode;

  const HadithDetailSheet({
    super.key,
    required this.hadith,
    required this.isDarkMode,
  });

  Color _parseColor(String hexColor) {
    try {
      String cleanHex = hexColor.replaceAll('#', '').replaceAll('0x', '');
      if (cleanHex.length == 6) cleanHex = 'FF$cleanHex';
      return Color(int.parse(cleanHex, radix: 16));
    } catch (e) {
      return const Color(0xFF4CAF50); // Fallback কালার
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradeColor = _parseColor(hadith.gradeColor);

    // --- আপনি যে কালারগুলো দিয়েছেন, সেগুলো এখানে ডিফাইন করা হলো ---
    const Color goldColor = Color(0xFFE4C381);
    const Color darkGreen = Color(0xFF004D40);

    final Color bgColor = isDarkMode
        ? const Color(0xFF0F0F0F)
        : const Color(0xFFF5F7F9);
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    // secondaryText এর জন্য text color কে একটু হালকা করা হয়েছে
    final Color secTxt = isDarkMode ? Colors.white70 : Colors.black54;

    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 800; // সহজ ওয়েব ডিটেকশন

    return DraggableScrollableSheet(
      // ১. full height এ ওপেন হবে (১.০)
      initialChildSize: 1.0,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          // ২. অ্যান্ড্রয়েড/আইওএস-এ sheet-এর ওপরে কোনো গ্যাপ থাকবে না
          decoration: BoxDecoration(
            color: bgColor, //bgColor ব্যবহার করা হয়েছে
            borderRadius: isWeb
                ? const BorderRadius.vertical(top: Radius.circular(28))
                : BorderRadius.zero,
          ),
          child: isWeb
              // ৩. Web-এ ১০০০ পিক্সেল কন্টেইনার
              ? _buildWebLayout(
                  scrollController,
                  goldColor,
                  darkGreen,
                  cardColor,
                  textColor,
                  secTxt,
                )
              // ৪. অ্যান্ড্রয়েড/আইওএস-এ পুরো পেজ-এর মতো লুক
              : _buildMobileLayout(
                  scrollController,
                  goldColor,
                  darkGreen,
                  cardColor,
                  textColor,
                  secTxt,
                ),
        );
      },
    );
  }

  // --- ওয়েব লেআউট (১০০০ পিক্সেল কন্টেইনার) ---
  Widget _buildWebLayout(
    ScrollController scrollController,
    Color goldColor,
    Color darkGreen,
    Color cardBg,
    Color textColor,
    Color secTxt,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Container(
          color: isDarkMode
              ? Colors.black.withOpacity(0.05)
              : Colors.black.withOpacity(0.01),
          child: Column(
            children: [
              _buildDragHandle(goldColor),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 30,
                  ),
                  children: _buildContentList(
                    goldColor,
                    darkGreen,
                    cardBg,
                    textColor,
                    secTxt,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- অ্যান্ড্রয়েড/আইওএস লেআউট (পুরো পেজ লুক) ---
  Widget _buildMobileLayout(
    ScrollController scrollController,
    Color goldColor,
    Color darkGreen,
    Color cardBg,
    Color textColor,
    Color secTxt,
  ) {
    return Column(
      children: [
        _buildDragHandle(goldColor),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: _buildContentList(
              goldColor,
              darkGreen,
              cardBg,
              textColor,
              secTxt,
            ),
          ),
        ),
      ],
    );
  }

  // --- কন্টেন্ট লিস্ট (আরবী, বর্ণনা, অনুবাদ, ব্যাখ্যা) ---
  List<Widget> _buildContentList(
    Color goldColor,
    Color darkGreen,
    Color cardBg,
    Color textColor,
    Color secTxt,
  ) {
    return [
      // ১. নতুন ডিজাইন করা টপ হেডার (badge, book, actions / chapter, hadith no)
      _buildNewTopHeader(goldColor, textColor, secTxt),

      const SizedBox(height: 10),
      const Divider(height: 1, thickness: 0.5),
      const SizedBox(height: 25),

      // ২. আরবী টেক্সট ব্লক (প্রোফেশনাল লুক)
      if (hadith.arabicText.isNotEmpty)
        _buildArabicTextBlock(darkGreen, textColor, cardBg),

      const SizedBox(height: 25),

      // ৩. অনুবাদ (প্রোফেশনাল লুক)
      _buildTranslationBlock(goldColor, textColor, secTxt, cardBg),

      const Divider(height: 50, thickness: 0.5),

      // ৪. হাদিসের ব্যাখ্যা (উর্দু/বাংলা শরহ)
      if (hadith.explanation.isNotEmpty &&
          hadith.explanation != 'ব্যাখ্যা পাওয়া যায়নি।')
        _buildSection(
          Icons.auto_stories,
          'হাদিসের বিস্তারিত ব্যাখ্যা',
          hadith.explanation,
          goldColor,
          textColor,
          secTxt,
        ),

      const SizedBox(height: 25),

      // ৫. রেফারেন্স নম্বর
      if (hadith.reference.isNotEmpty)
        _buildSection(
          Icons.history_edu,
          'রেফারেন্স ও টীকা',
          hadith.reference,
          goldColor,
          textColor,
          secTxt,
        ),

      const SizedBox(height: 50),
    ];
  }

  // --- ড্র্যাগ হ্যান্ডেল ---
  Widget _buildDragHandle(Color goldColor) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 45,
          height: 5,
          decoration: BoxDecoration(
            color: isDarkMode ? goldColor.withOpacity(0.3) : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // --- আপনার রিকোয়ারমেন্ট অনুযায়ী নতুন হেডার ডিজাইন ---
  Widget _buildNewTopHeader(Color goldColor, Color txt, Color secTxt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // রো ১: বামে ব্যাজ, সেন্টারে বইয়ের নাম, ডানে অ্যাকশন বাটন
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // দুই প্রান্ত ফিক্সড করার জন্য
          children: [
            // ক) বামে গ্রেড ব্যাজ
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                // ব্যাজের ব্যাকগ্রাউন্ড goldColor দিয়ে হালকা করা হয়েছে
                color: goldColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: goldColor.withOpacity(0.4)),
              ),
              child: Text(
                hadith.grade,
                style: TextStyle(
                  color: goldColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),

            // খ) একদম সেন্টারে বইয়ের নাম
            Expanded(
              child: Center(
                child: Text(
                  hadith.bookName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secTxt,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // গ) ডানে বুকমার্ক এবং শেয়ার
            Row(
              mainAxisSize: MainAxisSize.min, // রো-টিকে ছোট রাখার জন্য
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border_rounded, size: 22),
                  color: goldColor.withOpacity(
                    0.8,
                  ), //goldColor ব্যবহার করা হয়েছে
                  visualDensity:
                      VisualDensity.compact, // বাটনগুলোকে কাছাকাছি আনার জন্য
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined, size: 22),
                  color: goldColor.withOpacity(
                    0.8,
                  ), //goldColor ব্যবহার করা হয়েছে
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20), // দুই লাইনের মাঝে গ্যাপ
        // রো ২: এক লাইনে অধ্যায়ের নাম এবং হাদিস নম্বর
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              CrossAxisAlignment.center, // ভার্টিক্যালি সেন্টার করার জন্য
          children: [
            // ঘ) অধ্যায়ের নাম
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark_outline,
                    size: 16,
                    color: Colors.green[600],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hadith.chapterName,
                      style: TextStyle(
                        color: secTxt,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 15), // অধ্যায় এবং নম্বরের মাঝে গ্যাপ
            // ঙ) হাদিস নম্বর (ফন্ট একটু বড় এবং বোল্ড)
            Text(
              'হাদিস নম্বর: ${hadith.hadithNumber}',
              style: TextStyle(
                color: txt,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- প্রোফেশনাল আরবী টেক্সট ব্লক (প্রদান করা কালার অনুযায়ী) ---
  Widget _buildArabicTextBlock(Color darkGreen, Color textColor, Color cardBg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      decoration: BoxDecoration(
        // ১. ডার্ক মোডে পুরোপুরি কালো ব্যাকগ্রাউন্ড (কালো কাগজ)
        // ২. লাইট মোডে খুব হালকা কার্ড ব্যাকগ্রাউন্ড
        color: isDarkMode ? Colors.black : cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15), // হালকা রাউন্ডেড কর্নার
        // কোনো বর্ডার (Border.all) ব্যবহার করা হয়নি
      ),
      child: Text(
        hadith.arabicText,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 30, // বড় এবং পরিষ্কার ফন্ট সাইজ
          fontFamily: 'Amiri', // আরবী ফন্ট থাকলে ব্যবহার করুন
          height: 1.8, // লাইনের মাঝে পর্যাপ্ত জায়গা
          // ১. ডার্ক মোডে পুরোপুরি সাদা টেক্সট কালার (সাদা কালি)
          // ২. লাইট মোডে আপনার দেওয়া 'darkGreen' কালার
          color: isDarkMode ? Colors.white : darkGreen,
          fontWeight: FontWeight.w500, // টেক্সট একটু মোটা করার জন্য
        ),
      ),
    );
  }

  // --- প্রোফেশনাল অনুবাদ ব্লক ---
  Widget _buildTranslationBlock(
    Color goldColor,
    Color txt,
    Color secTxt,
    Color bg,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // বর্ণনাকারী (Badge Style)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.08)
                : Colors.grey[100]!,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_pin_rounded,
                size: 18,
                color: goldColor.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'বর্ণনায়: ${hadith.narrator}',
                  style: TextStyle(
                    color: secTxt,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // অনুবাদ (Translation)
        Text(
          hadith.translation,
          style: TextStyle(
            color: txt,
            fontSize: 18,
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // --- সেকশন বিল্ডার (ব্যাখ্যা, জীবনী এবং রেফারেন্সের জন্য) ---
  Widget _buildSection(
    IconData icon,
    String title,
    String content,
    Color goldColor,
    Color txt,
    Color secTxt,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: goldColor.withOpacity(0.9), size: 22),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: txt,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(color: secTxt, fontSize: 16, height: 1.6),
        ),
      ],
    );
  }
}
