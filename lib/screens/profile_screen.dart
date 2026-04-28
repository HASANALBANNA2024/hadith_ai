import 'package:flutter/material.dart';

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
  // রিপোর্ট সেকশন কন্ট্রোল
  bool _isPublishedExpanded = false;
  bool _isUpcomingExpanded = false;

  final Map<String, bool> _adviceList = {
    'এতিমখানায় দান': false,
    'দ্বীনি বই বিতরণ': false,
    'নতুন ইসলামিক ফিচার': true,
  };

  bool _isOtherSelected = false;
  final TextEditingController _otherAdviceController = TextEditingController();

  // বাটন দেখানোর লজিক
  bool get _shouldShowSubmit =>
      _adviceList.values.contains(true) ||
      (_isOtherSelected && _otherAdviceController.text.trim().isNotEmpty);

  @override
  void dispose() {
    _otherAdviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF004D40);
    const Color cardBg = Color(0xFF1E1E1E);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "প্রোফাইল",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ), // সিঙ্গেল কলামের জন্য উইডথ কিছুটা কমিয়েছি যাতে দেখতে সুন্দর লাগে
            child: Column(
              children: [
                // ১. হেডার সেকশন (বড় ব্যাজ ও নাম)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // কাস্টম বড় প্রোফাইল ব্যাজ
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white10,
                          child: Icon(
                            Icons.person,
                            size: 65,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // ইউজার স্ট্যাটাস ব্যাজ
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.planType.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ২. মেইন কন্টেন্ট - সব একটার নিচে একটা (Single Column)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // সাবস্ক্রিপশন ডিটেইলস
                      _sectionTitle("Subscription Info"),
                      _infoCard(cardBg, [
                        _infoRow("Join Date", "28 April, 2026", null),
                        _infoRow(
                          "Expiry Date",
                          "28 April, 2027",
                          Colors.orangeAccent,
                        ),
                        _infoRow("Status", "Active", Colors.greenAccent),
                      ]),

                      const SizedBox(height: 25),

                      // রিপোর্ট সেকশন
                      _sectionTitle("Transparency Reports"),
                      _buildReportCard(
                        "Published Reports",
                        Icons.library_books_outlined,
                        _isPublishedExpanded,
                        () => setState(
                          () => _isPublishedExpanded = !_isPublishedExpanded,
                        ),
                        [
                          _reportSubTile("January - April 2026", "Download"),
                          _reportSubTile("May - July 2026", "Download"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildReportCard(
                        "Upcoming Reports",
                        Icons.event_note_outlined,
                        _isUpcomingExpanded,
                        () => setState(
                          () => _isUpcomingExpanded = !_isUpcomingExpanded,
                        ),
                        [_reportSubTile("Audit Report 2026", "Expected: Oct")],
                      ),

                      const SizedBox(height: 25),

                      // পরামর্শ সেকশন
                      _sectionTitle("বাকি টাকা ব্যয়ের পরামর্শ"),
                      _adviceCard(cardBg, primaryGreen),

                      const SizedBox(height: 25),

                      // অন্যান্য অপশন
                      _sectionTitle("Others"),
                      _menuCard(cardBg),

                      const SizedBox(height: 50),
                      const Center(
                        child: Text(
                          "App Version 1.0.5",
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- কাস্টম উইজেট ফাংশনসমূহ ---

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
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

  Widget _infoCard(Color bg, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String value, Color? valColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: valColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    IconData icon,
    bool isExpanded,
    VoidCallback onTap,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            leading: Icon(icon, color: Colors.greenAccent, size: 22),
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white54,
            ),
          ),
          if (isExpanded) Column(children: children),
        ],
      ),
    );
  }

  Widget _reportSubTile(String name, String actionText) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
      trailing: actionText == "Download"
          ? const Icon(Icons.download_rounded, color: Colors.white38, size: 18)
          : Text(
              actionText,
              style: const TextStyle(color: Colors.orangeAccent, fontSize: 11),
            ),
    );
  }

  Widget _adviceCard(Color bg, Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ..._adviceList.keys.map(
            (key) => CheckboxListTile(
              title: Text(
                key,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              value: _adviceList[key],
              activeColor: themeColor,
              onChanged: (val) => setState(() => _adviceList[key] = val!),
            ),
          ),
          CheckboxListTile(
            title: const Text(
              "অন্যান্য",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            value: _isOtherSelected,
            activeColor: themeColor,
            onChanged: (val) => setState(() => _isOtherSelected = val!),
          ),
          if (_isOtherSelected)
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _otherAdviceController,
                style: const TextStyle(color: Colors.white),
                onChanged: (v) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "আপনার পরামর্শ...",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          if (_shouldShowSubmit)
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "সাবমিট করুন",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _menuCard(Color bg) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _menuTile(Icons.privacy_tip_outlined, "Privacy Policy"),
          _menuTile(Icons.feedback_outlined, "Send Feedback"),
          _menuTile(Icons.share_outlined, "Share App"),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white54, size: 20),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.white12,
      ),
    );
  }
}
