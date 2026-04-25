import 'package:flutter/material.dart';
import 'package:hadith_ai/screens/hadith_detail_screen.dart';

class CategoryHelper {
  static final List<String> allHadithSubjects = [
    'Faith (Iman)', 'Prayer', 'Fast (Ramadan)', 'Zakat & Charity', 'Hajj & Umrah',
    'Ethics (Akhlaq)', 'Purity (Taharah)', 'Supplications (Dua)', 'Good Character', 'Honesty',
    'Patience (Sabr)', 'Gratitude (Shukr)', 'Modesty (Haya)', 'Repentance (Tawbah)', 'Sincerity',
    'Marriage (Nikah)', 'Divorce', 'Family Life', 'Parental Rights', 'Neighbor Rights',
    'Children Rights', 'Kinship Bonds', 'Social Manners', 'Friendship',
    'Business Ethics', 'Financial Transactions', 'Inheritance', 'Judicial Matters', 'Witnesses',
    'Oaths & Vows', 'Endowments (Waqf)', 'Borrowing & Debts',
    'Seeking Knowledge', 'Prophetic Sunnah', 'Hadith Sciences', 'Exegesis (Tafsir)', 'Sermons',
    'Jihad (Struggle)', 'Self-Discipline', 'Martyrdom', 'Remembrance of Allah', 'Night Prayer (Tahajjud)',
    'Prophetic Medicine', 'Food & Drinks', 'Clothing & Adornment', 'Travel & Etiquette', 'Dreams & Visions',
    'Health & Sickness', 'Animal Rights', 'Environment',
    'Judgement Day', 'Paradise (Jannah)', 'Hellfire (Jahannam)', 'Signs of Qiyamah', 'Death & Grave',
    'Intercession (Shafaat)', 'The Mahdi', 'Dajjal (Antichrist)',
    'Stories of Prophets', 'Life of Sahaba', 'Sacrifice (Udhiya)', 'Hunting', 'Games & Sports'
  ];

  static Widget buildDashboardCategories({
    required BuildContext context,
    required Color border,
    required Color textC,
    required Color bg,
    required bool isWeb,
    required bool isDark,
  }) {
    final int showLimit = isWeb ? 5 : 2;
    final displayTags = allHadithSubjects.take(showLimit).toList();
    final Color effectiveBorder = isDark ? border : Colors.black87;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1100),
        width: double.infinity,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: [
            // dashboard item click
            ...displayTags.map((t) => InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => _navigateToDetails(context, t, isDark),
              child: _buildItem(t, effectiveBorder, textC, bg, isWeb),
            )),

            InkWell(
              onTap: () => showAllCategories(context, border, textC, bg, isWeb, isDark),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 25 : 16,
                  vertical: isWeb ? 12 : 8,
                ),
                decoration: BoxDecoration(
                  color: effectiveBorder.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: effectiveBorder, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Show All",
                      style: TextStyle(
                          color: textC,
                          fontSize: isWeb ? 15 : 13,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.add_circle_outline, size: 16, color: textC),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showAllCategories(
      BuildContext context, Color border, Color textC, Color bg, bool isWeb, bool isDark
      ) {
    final Color effectiveBorder = isDark ? border : Colors.black87;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.70,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF03221F) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
              border: Border.all(color: effectiveBorder.withOpacity(0.3), width: 1),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 18),
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: effectiveBorder.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  "Explore All Subjects",
                  style: TextStyle(
                    color: effectiveBorder,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 25),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: allHadithSubjects.map((t) => InkWell(
                        borderRadius: BorderRadius.circular(30),
                        // bottom sheet item click
                        onTap: () {
                          Navigator.pop(context); // sheet close
                          _navigateToDetails(context, t, isDark);
                        },
                        child: _buildItem(t, effectiveBorder, textC, bg, isWeb),
                      )).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Navigation logic
  static void _navigateToDetails(BuildContext context, String category, bool isDark) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HadithDetailScreen(
          categoryName: category,
          isDark: isDark,
        ),
      ),
    );
  }

  static Widget _buildItem(String title, Color border, Color textC, Color bg, bool isWeb) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 25 : 18,
        vertical: isWeb ? 12 : 9,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: border.withOpacity(0.4), width: 1.2),
      ),
      child: Text(
        title,
        style: TextStyle(
            color: textC,
            fontSize: isWeb ? 15 : 13,
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}