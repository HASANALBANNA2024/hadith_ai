import 'package:flutter/material.dart';
import 'package:hadith_ai/logic/bookmark_service.dart';
import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hadith_ai/widgets/share_hadith.dart';

class HadithDetailSheet extends StatefulWidget {
  final HadithModel hadith;
  final bool isDarkMode;

  const HadithDetailSheet({
    super.key,
    required this.hadith,
    required this.isDarkMode,
  });

  @override
  State<HadithDetailSheet> createState() => _HadithDetailSheetState();
}

class _HadithDetailSheetState extends State<HadithDetailSheet> {
  @override
  Widget build(BuildContext context) {
    // কালার কনফিগারেশন
    const Color goldColor = Color(0xFFE4C381);
    const Color darkGreen = Color(0xFF004D40);

    final Color bgColor = widget.isDarkMode
        ? const Color(0xFF121212)
        : Colors.white;
    final Color cardColor = widget.isDarkMode
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF8F9FA);
    final Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final Color secTxt = widget.isDarkMode ? Colors.white70 : Colors.black54;

    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 800;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
                        if (widget.hadith.arabicText.isNotEmpty)
                          _buildArabicTextBlock(darkGreen, textColor),

                        const SizedBox(height: 25),

                        // অনুবাদ
                        _buildTranslationBlock(goldColor, textColor),

                        // ব্যাখ্যা (যদি থাকে)
                        if (widget.hadith.explanation.isNotEmpty) ...[
                          const SizedBox(height: 25),
                          _buildSection(
                            Icons.lightbulb_outline_rounded,
                            'হাদিসের ব্যাখ্যা',
                            widget.hadith.explanation,
                            goldColor,
                            textColor,
                            secTxt,
                            cardColor,
                          ),
                        ],

                        // ইমাম পরিচিতি (যদি থাকে)
                        if (widget.hadith.narratorBio.isNotEmpty &&
                            widget.hadith.narratorBio != "তথ্য নেই।") ...[
                          const SizedBox(height: 20),
                          _buildSection(
                            Icons.history_edu_rounded,
                            'ইমাম পরিচিতি',
                            widget.hadith.narratorBio,
                            goldColor,
                            textColor,
                            secTxt,
                            cardColor,
                          ),
                        ],

                        // ট্যাগস (যদি থাকে)
                        if (widget.hadith.tags.isNotEmpty) ...[
                          const SizedBox(height: 25),
                          _buildTags(widget.hadith.tags, goldColor),
                        ],

                        const SizedBox(height: 20),

                        // রেফারেন্স
                        _buildSection(
                          Icons.menu_book_rounded,
                          'রেফারেন্স',
                          widget.hadith.reference,
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

  // ড্র্যাগ হ্যান্ডেল
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

  // টপ হেডার (বুকমার্ক ও শেয়ার বাটন সহ)
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
                widget.hadith.grade,
                style: TextStyle(
                  color: goldColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.hadith.bookName,
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
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    BookmarkService.isBookmarked(widget.hadith.hadithId)
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 22,
                    color: goldColor,
                  ),
                  onPressed: () async {
                    if (BookmarkService.isBookmarked(widget.hadith.hadithId)) {
                      await BookmarkService.removeBookmark(
                        widget.hadith.hadithId,
                      );
                    } else {
                      await BookmarkService.addBookmark(widget.hadith);
                    }
                    if (mounted) {
                      setState(() {});
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            BookmarkService.isBookmarked(widget.hadith.hadithId)
                                ? "বুকমার্ক করা হয়েছে"
                                : "বুকমার্ক থেকে সরানো হয়েছে",
                          ),
                          duration: const Duration(milliseconds: 800),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () => shareHadith(widget.hadith),
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
                widget.hadith.chapterName,
                style: TextStyle(color: secTxt, fontSize: 13, height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '#${widget.hadith.hadithNumber}',
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

  // আরবী টেক্সট ব্লক
  Widget _buildArabicTextBlock(Color darkGreen, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.black26 : darkGreen.withOpacity(0.04),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        widget.hadith.arabicText,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 26,
          fontFamily: 'Amiri',
          height: 1.8,
          color: widget.isDarkMode ? Colors.white : darkGreen,
        ),
      ),
    );
  }

  // অনুবাদ ব্লক
  Widget _buildTranslationBlock(Color goldColor, Color txt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'বর্ণনায়: ${widget.hadith.narrator}',
          style: TextStyle(
            color: goldColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.hadith.translation,
          style: TextStyle(color: txt, fontSize: 16, height: 1.6),
        ),
      ],
    );
  }

  // ট্যাগস উইজেট
  Widget _buildTags(List<String> tags, Color goldColor) {
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

  // জেনারেল সেকশন (ব্যাখ্যা, পরিচিতি, রেফারেন্স এর জন্য)
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
