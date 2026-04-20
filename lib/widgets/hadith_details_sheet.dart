import 'package:flutter/material.dart';
import 'package:hadith_ai/model/hadith_model.dart';

class HadithDetailSheet extends StatelessWidget {
  final HadithModel hadith;
  final bool isDark;

  const HadithDetailSheet({
    super.key,
    required this.hadith,
    required this.isDark,
  });

  // কালার কনভার্টার (API থেকে আসা হেক্স কোড হ্যান্ডেল করার জন্য)
  Color _parseColor(String hexColor) {
    try {
      String cleanHex = hexColor.replaceAll('#', '').replaceAll('0x', '');
      if (cleanHex.length == 6) cleanHex = 'FF$cleanHex';
      return Color(int.parse(cleanHex, radix: 16));
    } catch (e) {
      // ডিফল্ট সবুজ কালার যদি কালার কোড না পাওয়া যায়
      return const Color(0xFF4CAF50);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradeColor = _parseColor(hadith.gradeColor);
    final themeBg = isDark ? const Color(0xFF121212) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA);
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth > 800 ? screenWidth * 0.2 : 20;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: themeBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // ড্র্যাগ হ্যান্ডেল
              const SizedBox(height: 12),
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
                  children: [
                    // ১. আপডেট করা হেডার কার্ড (বই ও অধ্যায়)
                    _buildHeaderCard(cardBg, textColor, secondaryTextColor),
                    const SizedBox(height: 20),

                    // ২. আরবি টেক্সট ব্লক
                    if (hadith.arabicText.isNotEmpty)
                      _buildArabicBlock(gradeColor),

                    const SizedBox(height: 20),

                    // ৩. আপডেট করা বর্ণনাকারী ও অনুবাদ (Overflow Fixed)
                    _buildTranslationBlock(textColor, secondaryTextColor, cardBg),

                    const SizedBox(height: 20),

                    // ৪. হাদিসের মান ও ট্যাগস
                    _buildGradeAndTags(gradeColor, secondaryTextColor),

                    const Divider(height: 40, thickness: 0.5),

                    // ৫. বিস্তারিত ব্যাখ্যা (উর্দু/বাংলা শরহ)
                    if (hadith.explanation.isNotEmpty && hadith.explanation != 'ব্যাখ্যা পাওয়া যায়নি।')
                      _buildInfoSection(
                        Icons.auto_stories_rounded,
                        'হাদিসের বিস্তারিত ব্যাখ্যা',
                        hadith.explanation,
                        Colors.amber,
                        textColor,
                        secondaryTextColor,
                      ),

                    const SizedBox(height: 20),

                    // ৬. রেফারেন্স নম্বর
                    if (hadith.reference.isNotEmpty)
                      _buildReferenceBlock(secondaryTextColor),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- আপডেট করা হেডার কার্ড (বই ও অধ্যায় সঠিকভাবে দেখানোর জন্য) ---
  Widget _buildHeaderCard(Color bg, Color txt, Color secTxt) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.library_books_outlined, size: 18, color: Colors.amber[700]),
              const SizedBox(width: 8),
              // Expanded ব্যবহার করা হয়েছে যাতে বড় নাম কেটে না যায়
              Expanded(
                child: Text(
                    hadith.bookName,
                    style: TextStyle(color: secTxt, fontSize: 13, fontWeight: FontWeight.w500)
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.bookmark_border_rounded, size: 18, color: Colors.green[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    hadith.chapterName,
                    style: TextStyle(color: secTxt, fontSize: 13)
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.5),
          Text(
            'হাদিস নং: ${hadith.hadithNumber}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: txt, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  // --- আরবি টেক্সট ডিজাইন ---
  Widget _buildArabicBlock(Color gradeColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: gradeColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gradeColor.withOpacity(0.15)),
      ),
      child: Text(
        hadith.arabicText,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          fontSize: 26,
          fontFamily: 'Amiri',
          height: 1.9,
          fontWeight: FontWeight.w500,
          color: Color(0xFF13532D),
        ),
      ),
    );
  }

  // --- আপডেট করা বর্ণনাকারী ব্লক (Overflow ফিক্সড করা হয়েছে) ---
  Widget _buildTranslationBlock(Color txt, Color secTxt, Color bg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.person_pin_rounded, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 10),
              // Expanded ব্যবহার করায় এখন আর হলুদ স্ট্রাইপ (Overflow) আসবে না
              Expanded(
                child: Text(
                  'বর্ণনায়: ${hadith.narrator}',
                  style: TextStyle(
                      color: secTxt,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          hadith.translation,
          style: TextStyle(
              color: txt,
              fontSize: 17,
              height: 1.6,
              fontWeight: FontWeight.w400
          ),
        ),
      ],
    );
  }

  Widget _buildGradeAndTags(Color gradeColor, Color secTxt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('হাদিসের মান:', style: TextStyle(color: secTxt, fontSize: 13)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: gradeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: gradeColor.withOpacity(0.5)),
              ),
              child: Text(
                hadith.grade,
                style: TextStyle(color: gradeColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        if (hadith.tags.isNotEmpty) ...[
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hadith.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text('#$tag', style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
            )).toList(),
          ),
        ]
      ],
    );
  }

  Widget _buildInfoSection(IconData icon, String title, String content, Color iconCol, Color txt, Color secTxt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconCol, size: 22),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(color: txt, fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Text(content, style: TextStyle(color: secTxt, fontSize: 15, height: 1.6)),
      ],
    );
  }

  Widget _buildReferenceBlock(Color secTxt) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: secTxt.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.tag, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(
              'রেফারেন্স: ${hadith.reference}',
              style: TextStyle(color: secTxt, fontSize: 13, fontWeight: FontWeight.bold)
          ),
        ],
      ),
    );
  }
}