import 'package:flutter/material.dart';
import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hadith_ai/widgets/share_hadith.dart';

class HadithDetailSheet extends StatelessWidget {
  final HadithModel hadith;
  final bool isDarkMode;

  const HadithDetailSheet({
    super.key,
    required this.hadith,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    const Color goldColor = Color(0xFFE4C381);
    const Color darkGreen = Color(0xFF004D40);

    final Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDarkMode
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF8F9FA);
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color secTxt = isDarkMode ? Colors.white70 : Colors.black54;

    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 800;

    return DraggableScrollableSheet(
      initialChildSize: 0.7, // ৭০% স্ক্রিন দখল করবে
      minChildSize: 0.4,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              _buildDragHandle(goldColor),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 800 : double.infinity,
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      children: [
                        _buildNewTopHeader(goldColor, textColor, secTxt),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(height: 1, thickness: 0.5),
                        ),

                        // আরবী টেক্সট
                        if (hadith.arabicText.isNotEmpty)
                          _buildArabicTextBlock(
                            darkGreen,
                            textColor,
                            cardColor,
                          ),

                        const SizedBox(height: 25),

                        // অনুবাদ
                        _buildTranslationBlock(goldColor, textColor, secTxt),

                        // ডাইনামিক সেকশন: ব্যাখ্যা (যদি থাকে)
                        if (hadith.explanation.isNotEmpty) ...[
                          const SizedBox(height: 25),
                          _buildSection(
                            Icons.lightbulb_outline_rounded,
                            'হাদিসের ব্যাখ্যা',
                            hadith.explanation,
                            goldColor,
                            textColor,
                            secTxt,
                            cardColor,
                          ),
                        ],

                        // ডাইনামিক সেকশন: ইমাম পরিচিতি (যদি থাকে)
                        if (hadith.narratorBio.isNotEmpty &&
                            hadith.narratorBio != "তথ্য নেই।") ...[
                          const SizedBox(height: 20),
                          _buildSection(
                            Icons.history_edu_rounded,
                            'ইমাম পরিচিতি',
                            hadith.narratorBio,
                            goldColor,
                            textColor,
                            secTxt,
                            cardColor,
                          ),
                        ],

                        // ডাইনামিক সেকশন: ট্যাগস (যদি থাকে)
                        if (hadith.tags.isNotEmpty) ...[
                          const SizedBox(height: 25),
                          _buildTags(hadith.tags, goldColor, textColor),
                        ],

                        const SizedBox(height: 20),

                        // রেফারেন্স
                        _buildSection(
                          Icons.menu_book_rounded,
                          'রেফারেন্স',
                          hadith.reference,
                          goldColor,
                          textColor,
                          secTxt,
                          cardColor,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(Color goldColor) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: goldColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildNewTopHeader(Color goldColor, Color txt, Color secTxt) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: goldColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: goldColor.withOpacity(0.4)),
              ),
              child: Text(
                hadith.grade,
                style: TextStyle(
                  color: goldColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            Expanded(
              child: Text(
                hadith.bookName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: goldColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              children: [
                Icon(Icons.bookmark_border_rounded, size: 20, color: secTxt),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () => shareHadith(hadith),
                  icon: const Icon(Icons.share_outlined, size: 22),
                  color: goldColor.withOpacity(0.8),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                hadith.chapterName,
                style: TextStyle(color: secTxt, fontSize: 13, height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              'Hadith#${hadith.hadithNumber}',
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

  Widget _buildArabicTextBlock(
    Color darkGreen,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black26 : darkGreen.withOpacity(0.04),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        hadith.arabicText,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 28,
          fontFamily: 'Amiri',
          height: 1.7,
          color: isDarkMode ? Colors.white : darkGreen,
        ),
      ),
    );
  }

  Widget _buildTranslationBlock(Color goldColor, Color txt, Color secTxt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'বর্ণনায়: ${hadith.narrator}',
          style: TextStyle(
            color: goldColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          hadith.translation,
          style: TextStyle(color: txt, fontSize: 17, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildTags(List<String> tags, Color goldColor, Color textColor) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: goldColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "#$tag",
                style: TextStyle(
                  color: goldColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSection(
    IconData icon,
    String title,
    String content,
    Color goldColor,
    Color txt,
    Color secTxt,
    Color cardColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: goldColor, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: txt,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(color: secTxt, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
