import 'package:flutter/material.dart';
import 'package:hadith_ai/sendfeedback/about_app_screen.dart';
import 'package:hadith_ai/sendfeedback/feedback_screen.dart';
import 'package:hadith_ai/widgets/privacy_policy_screen.dart';
import 'package:hadith_ai/widgets/share_app.dart';

class SettingsSheet extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SettingsSheet({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged
  });

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  bool _isNotifOn = true;

  late bool _isDarkLocal;

  @override
  void initState()
  {
    super.initState();
    _isDarkLocal = widget.isDarkMode;
  }


  @override
  Widget build(BuildContext context) {
    const Color goldColor = Color(0xFFE4C381);

    final Color bgColor = widget.isDarkMode
        ? const Color(0xFF121212)
        : Colors.white;
    final Color txtColor = widget.isDarkMode ? Colors.white : Colors.black87;
    final Color cardIconBg = goldColor.withOpacity(0.1);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.60,
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
                _buildSectionTitle("Preferences"),

                // --- Notification control ---
                _buildSettingItem(
                  Icons.notifications_none_outlined,
                  "Notifications",
                  Switch(
                    value: _isNotifOn,
                    activeColor: goldColor,
                    onChanged: (v) {
                      setState(() => _isNotifOn = v);

                    },
                  ),
                  goldColor,
                  txtColor,
                  cardIconBg,
                ),

                // switch
                // --- Theme / Dark Mode Control ---
                _buildSettingItem(
                  _isDarkLocal ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  "Dark Mode",
                  Switch(
                    value: _isDarkLocal, // এটি আপনার সেটিংস শিটের লোকাল ডার্ক মোড স্টেট
                    activeColor: goldColor,
                    onChanged: (v) {
                      setState(() => _isDarkLocal = v);

                      widget.onThemeChanged(v);
                    },
                  ),
                  goldColor,
                  txtColor,
                  cardIconBg,
                ),



                const SizedBox(height: 20),
                _buildSectionTitle("Support & Legal"),

                // --- Privacy Policy ---
                _buildSettingItem(
                  Icons.privacy_tip_outlined,
                  "Privacy Policy",
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                  goldColor,
                  txtColor,
                  cardIconBg,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PrivacyPolicyScreen(isDark: widget.isDarkMode),
                      ),
                    );
                  },
                ),

                // --- Feedback ---
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
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackScreen(
                          isDark: widget.isDarkMode,
                        ), // isDarkMode
                      ),
                    );
                  },
                ),

                // ---About App ---
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
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AboutAppScreen(isDark: widget.isDarkMode),
                      ),
                    );
                  },
                ),

                // --- Share App---
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
                    Navigator.pop(context);
                    AppShare.share();
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 5),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

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
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
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
