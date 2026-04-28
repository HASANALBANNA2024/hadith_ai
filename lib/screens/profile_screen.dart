import 'package:flutter/material.dart';
import 'package:hadith_ai/widgets/profile_action_button.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String planType;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.planType,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, bool> _adviceList = {
    'এতিমখানায় দান': false,
    'দ্বীনি বই বিতরণ': false,
    'নতুন ইসলামিক ফিচার': true,
  };

  bool _isOtherSelected = false;
  final TextEditingController _otherAdviceController = TextEditingController();

  @override
  void dispose() {
    _otherAdviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final Color badgeColor = ProfileActionButton.getBadgeColor(widget.planType);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "প্রোফাইল",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF004D40),
        elevation: 0,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                // এখানে আপনার রিকোয়েস্ট অনুযায়ী ১১০০ পিক্সেল সেট করা হয়েছে
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  children: [
                    // ১. হেডার সেকশন (Identity)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 20,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF004D40),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            // icon
                            icon: ProfileActionButton(
                              isLoggedIn: true,
                              planType: "basic",
                              onLoginTap: () {},
                              onProfileTap: () {},
                              onLogoutTap: () {},
                            ),
                            onPressed: () {
                              print("Profile Clicked");
                              //
                            },
                          ),
                          // ProfileActionButton.getBadgeIcon(widget.planType, size: 90),
                          const SizedBox(height: 16),
                          Text(
                            widget.userName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.userEmail,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ২. মূল কন্টেন্ট - ওয়েবের জন্য আমরা এটাকে প্যাডিং দিয়ে মাঝখানে আনব
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: Wrap(
                        // ওয়েবে পাশাপাশি দেখানোর জন্য Wrap ব্যবহার করেছি, মোবাইলে নিচে নিচে চলে আসবে
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          // কলাম ১: সাবস্ক্রিপশন এবং পরামর্শ
                          SizedBox(
                            width: constraints.maxWidth > 800
                                ? 520
                                : constraints.maxWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle("Subscription Details"),
                                _buildInfoCard(isDarkMode, [
                                  // _infoRow("Plan Type", widget.planType.toUpperCase(), badgeColor),
                                  _infoRow("Join Date", "28 April, 2026", null),
                                  _infoRow(
                                    "Active Device",
                                    "Current Device",
                                    null,
                                  ),
                                ]),
                                const SizedBox(height: 10),
                                _buildSectionTitle(
                                  "বাকি টাকা কোন খাতে ব্যয় করব? (পরামর্শ)",
                                ),
                                // _buildAdviceCard(isDarkMode, badgeColor),
                              ],
                            ),
                          ),

                          // কলাম ২: রিপোর্ট, লিগ্যাল এবং ডাউনলোড
                          SizedBox(
                            width: constraints.maxWidth > 800
                                ? 520
                                : constraints.maxWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle("Quick Actions & Reports"),
                                _buildActionTile(
                                  Icons.analytics_outlined,
                                  "Subscription Report",
                                  "প্রতি ৩ মাস অন্তর আপডেট করা হয়",
                                  Colors.blueAccent,
                                  isDarkMode,
                                  () {},
                                ),
                                _buildActionTile(
                                  Icons.auto_awesome_mosaic_rounded,
                                  "Our Mission & Vision",
                                  null,
                                  Colors.orange,
                                  isDarkMode,
                                  () {},
                                ),
                                _buildActionTile(
                                  Icons.privacy_tip_outlined,
                                  "Privacy Policy",
                                  null,
                                  Colors.teal,
                                  isDarkMode,
                                  () {},
                                ),

                                const SizedBox(height: 30),
                                const Center(
                                  child: Text(
                                    "Available Platforms",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildPlatformIcon(
                                      Icons.window_rounded,
                                      "Windows",
                                      isDarkMode,
                                    ),
                                    const SizedBox(width: 40),
                                    _buildPlatformIcon(
                                      Icons.android_rounded,
                                      "Android",
                                      isDarkMode,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    const Text(
                      "App Version 1.0.5",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- হেল্পার মেথডগুলো অপরিবর্তিত ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceCard(bool isDark, Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ..._adviceList.keys.map((String key) {
            return CheckboxListTile(
              title: Text(key, style: const TextStyle(fontSize: 14)),
              activeColor: themeColor,
              checkColor: Colors.black,
              value: _adviceList[key],
              onChanged: (bool? value) =>
                  setState(() => _adviceList[key] = value!),
            );
          }).toList(),
          CheckboxListTile(
            title: const Text(
              "অন্যান্য পরামর্শ",
              style: TextStyle(fontSize: 14),
            ),
            activeColor: themeColor,
            checkColor: Colors.black,
            value: _isOtherSelected,
            onChanged: (bool? value) =>
                setState(() => _isOtherSelected = value!),
          ),
          if (_isOtherSelected)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _otherAdviceController,
                decoration: InputDecoration(
                  hintText: "আপনার পরামর্শ লিখুন...",
                  filled: true,
                  fillColor: isDark ? Colors.black26 : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    String? subtitle,
    Color iconColor,
    bool isDark,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildPlatformIcon(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Icon(icon, color: isDark ? Colors.white54 : Colors.black45, size: 32),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
