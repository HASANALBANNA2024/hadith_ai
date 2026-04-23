import 'package:flutter/material.dart';

class SettingsSheet extends StatefulWidget {
  final bool isDarkMode;

  const SettingsSheet({super.key, required this.isDarkMode});

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  // কন্টেন্ট কন্ট্রোল ভ্যারিয়েবল
  bool _showTranslation = true;
  bool _showArabic = true;
  bool _showNarrator = true;

  @override
  Widget build(BuildContext context) {
    const Color goldColor = Color(0xFFE4C381);

    // থিমের উপর ভিত্তি করে ব্যাকগ্রাউন্ড ও টেক্সট কালার
    final Color bgColor = widget.isDarkMode
        ? const Color(0xFF121212)
        : Colors.white;
    final Color txtColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final Color cardIconBg = goldColor.withOpacity(0.1);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ড্র্যাগ হ্যান্ডেল
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: goldColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Text(
            "Settings",
            style: TextStyle(
              color: goldColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildSectionTitle("Content Controls"),

                _buildSettingItem(
                  Icons.translate,
                  "Show Translation",
                  Switch(
                    value: _showTranslation,
                    activeColor: goldColor,
                    onChanged: (v) => setState(() => _showTranslation = v),
                  ),
                  goldColor,
                  txtColor,
                  cardIconBg,
                ),

                _buildSettingItem(
                  Icons.menu_book_outlined,
                  "Show Arabic Text",
                  Switch(
                    value: _showArabic,
                    activeColor: goldColor,
                    onChanged: (v) => setState(() => _showArabic = v),
                  ),
                  goldColor,
                  txtColor,
                  cardIconBg,
                ),

                _buildSettingItem(
                  Icons.person_outline,
                  "Show Narrator",
                  Switch(
                    value: _showNarrator,
                    activeColor: goldColor,
                    onChanged: (v) => setState(() => _showNarrator = v),
                  ),
                  goldColor,
                  txtColor,
                  cardIconBg,
                ),

                const SizedBox(height: 10),

                _buildSectionTitle("Support & About"),

                _buildSettingItem(
                  Icons.info_outline,
                  "About App",
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                  goldColor,
                  txtColor,
                  cardIconBg,
                  onTap: () {
                    // About App লজিক এখানে
                  },
                ),

                _buildSettingItem(
                  Icons.share_outlined,
                  "Share App",
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                  goldColor,
                  txtColor,
                  cardIconBg,
                  onTap: () {
                    // শেয়ার লজিক
                  },
                ),
                _buildSettingItem(
                  Icons.star_outline,
                  "Rate the App",
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                  goldColor,
                  txtColor,
                  cardIconBg,
                  onTap: () {
                    // রেটিং লজিক
                  },
                ),

                _buildSettingItem(
                  Icons.report_problem_outlined,
                  "Send Feedback",
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                  goldColor,
                  txtColor,
                  cardIconBg,
                  onTap: () {
                    // Report Issue লজিক এখানে
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // সেকশন টাইটেল উইজেট
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // সেটিংস আইটেম উইজেট
  Widget _buildSettingItem(
    IconData icon,
    String title,
    Widget trailing,
    Color gold,
    Color txt,
    Color iconBg, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: gold, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(color: txt, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: trailing,
    );
  }
}
