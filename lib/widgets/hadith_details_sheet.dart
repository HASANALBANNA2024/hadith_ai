import 'package:flutter/material.dart';
import '../model/hadith_model.dart';

class HadithDetailsSheet extends StatelessWidget {
  final HadithModel hadith;
  final bool isDark;

  const HadithDetailsSheet({
    super.key,
    required this.hadith,
    required this.isDark,
  });

  Color _getGradeColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradeColor = _getGradeColor(hadith.gradeColor);
    final textTheme = isDark ? Colors.white : Colors.black87;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // বই ও গ্রেড সেকশন
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${hadith.bookName} | নং ${hadith.hadithNumber}",
                          style: const TextStyle(
                            color: Color(0xFFB8860B),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      _buildGradeBadge(hadith.grade, gradeColor),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // আরবি টেক্সট (সবসময় থাকবে)
                  if (hadith.arabicText.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                      ),
                      child: Text(
                        hadith.arabicText,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Amiri',
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // বর্ণনাকারী ও অনুবাদ
                  if (hadith.narrator.isNotEmpty) _buildLabel("বর্ণনাকারী: ${hadith.narrator}"),
                  const SizedBox(height: 12),
                  if (hadith.translation.isNotEmpty)
                    Text(
                      hadith.translation,
                      style: TextStyle(fontSize: 17, height: 1.6, color: textTheme),
                    ),

                  // রেফারেন্স (যদি থাকে)
                  if (hadith.reference.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    Text(
                      "রেফারেন্স: ${hadith.reference}",
                      style: const TextStyle(color: Colors.blueGrey, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],

                  const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(thickness: 0.5)),

                  // ব্যাখ্যা (খালি থাকলে UI দেখাবে না)
                  if (hadith.explanation.isNotEmpty && hadith.explanation != 'ব্যাখ্যা পাওয়া যায়নি।') ...[
                    _buildSectionHeader(Icons.lightbulb_outline_rounded, "হাদিসের ব্যাখ্যা", Colors.amber),
                    const SizedBox(height: 12),
                    _buildContentText(hadith.explanation),
                    const SizedBox(height: 30),
                  ],

                  // রাবী পরিচিতি (খালি থাকলে UI দেখাবে না)
                  if (hadith.narratorBio.isNotEmpty && hadith.narratorBio != 'জীবনী পাওয়া যায়নি।') ...[
                    _buildSectionHeader(Icons.person_pin_rounded, "রাবী বা বর্ণনাকারী পরিচিতি", Colors.teal),
                    const SizedBox(height: 12),
                    _buildContentText(hadith.narratorBio),
                    const SizedBox(height: 30),
                  ],

                  // ট্যাগস (খালি থাকলে UI দেখাবে না)
                  if (hadith.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: hadith.tags.map((tag) => _buildTagChip(tag)).toList(),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // হেল্পার মেথডগুলো আগের মতোই থাকবে...
  Widget _buildGradeBadge(String grade, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(30), border: Border.all(color: color.withOpacity(0.5))),
      child: Text(grade, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(children: [Icon(icon, size: 22, color: color), const SizedBox(width: 10), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]);
  }

  Widget _buildContentText(String text) {
    return Text(text, style: TextStyle(fontSize: 15, height: 1.6, color: isDark ? Colors.white70 : Colors.black54));
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic));
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: Text("#$tag", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
    );
  }
}