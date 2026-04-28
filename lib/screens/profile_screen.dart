import 'package:flutter/material.dart';
import 'package:hadith_ai/screens/dashboard_screen.dart';
import 'package:hadith_ai/sendfeedback/feedback_screen.dart';
import 'package:hadith_ai/widgets/privacy_policy_screen.dart';

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
  // Report Section
  bool _isPublishedExpanded = false;
  bool _isUpcomingExpanded = false;

  final Map<String, bool> _adviceList = {
    'এতিমখানায় দান': false,
    'দ্বীনি বই বিতরণ': false,
    'নতুন ইসলামিক ফিচার': false,
  };

  bool _isOtherSelected = false;
  final TextEditingController _otherAdviceController = TextEditingController();

  // logic of button display
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDarkMode ? const Color(0xFF2B2B2B) : Colors.white;
    final Color appBarColor = isDarkMode ? const Color(0xFF1E1F22) : const Color(0xFF004D40);
    final Color scaffoldBg = isDarkMode ? const Color(0xFF121212) : const Color(0xFF2B2B2B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      // ১. AppBar (Height 45)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          centerTitle: true,
          // default back button
          automaticallyImplyLeading: false,
          title: Center(
        child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // back button of home screen
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                  },
                ),
              ),

              // Profile text
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),

      // body of content
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                const SizedBox(height: 25), // AppBar থেকে ডিস্ট্যান্স

                // User Identity card
                _buildIdentityCard(cardBg, isDarkMode),

                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      // ৩. Subscription Info (Aura AI)
                      _buildSubscriptionInfo(cardBg, isDarkMode),
                      const SizedBox(height: 25),

                      // ৪. Project Cost Management (ব্যানার ও পরামর্শ)
                      _buildCostManagementSection(cardBg, isDarkMode, appBarColor),
                      const SizedBox(height: 25),

                      // ৫. Transparency Reports
                      _buildTransparencyReports(cardBg, isDarkMode),
                      const SizedBox(height: 25),

                      // ৭. Platform Icons
                      _buildPlatformIcons(isDarkMode),

                      // ৮. App Version & Company
                      const SizedBox(height: 40),
                      Text("App Version 1.0.5", style: TextStyle(color: isDarkMode ? Colors.grey : Colors.black54, fontSize: 12)),
                      const Text("Developed by Your Company Name", style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 60),
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

  Widget _buildIdentityCard(Color cardBg, bool isDark) {
    final Color themeColor = const Color(0xFF004D40);
    final Color textColor = isDark ? Colors.white : Colors.black87;

    // স্ক্রিন সাইজ চেক করার জন্য
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1060),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMobile ? 80 : 150), // মোবাইলে ছোট রেডিয়াস
              topRight: Radius.circular(isMobile ? 80 : 150),
              bottomLeft: const Radius.circular(30),
              bottomRight: const Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
                blurRadius: 25,
                offset: const Offset(0, 12),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ১. গম্বুজ অংশ
              Container(
                height: isMobile ? 100 : 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.08),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isMobile ? 80 : 150),
                    topRight: Radius.circular(isMobile ? 80 : 150),
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.menu_book_rounded, size: isMobile ? 35 : 50, color: themeColor),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ২. ইউজার ইনফরমেশন
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    FittedBox( // টেক্সট বড় হলে যেন স্ক্রিন না ফাটে
                      child: Text(
                        widget.userName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 22 : 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.userEmail,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 15,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ৩. স্ট্যাটাস ও ব্যাজ সেকশন (রেসপন্সিভ লেআউট)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.02) : Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: isMobile
                    ? Column( // মোবাইলে একটার নিচে একটা
                  children: [
                    _buildStandardBadge("ACTIVE STATUS", Colors.green, Icons.check_circle_rounded),
                    const SizedBox(height: 10),
                    _buildStandardBadge("${widget.planType.toUpperCase()} MEMBER", themeColor, Icons.stars_rounded),
                  ],
                )
                    : Row( // বড় স্ক্রিনে পাশাপাশি
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStandardBadge("ACTIVE STATUS", Colors.green, Icons.check_circle_rounded),
                    const SizedBox(width: 40),
                    _buildStandardBadge("${widget.planType.toUpperCase()} MEMBER", themeColor, Icons.stars_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// ৪. স্ট্যান্ডার্ড ব্যাজ হেল্পার (বড় কন্টেন্টের জন্য আপডেট করা)
  Widget _buildStandardBadge(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
  // --- ৩. সাবস্ক্রিপশন ইনফো ---
  Widget _buildSubscriptionInfo(Color cardBg, bool isDark) {
    return _infoSectionCard(cardBg, isDark, "Subscription Info (Aura AI)", [
      _rowInfo("Start Date", "28 April, 2026", isDark),
      _rowInfo("Expire Date", "28 April, 2027", isDark),
    ]);
  }

  // --- ৪. প্রজেক্ট কস্ট ম্যানেজমেন্ট ---
  Widget _buildCostManagementSection(Color cardBg, bool isDark, Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Project Cost Management", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 10),
        // ব্যানার স্টাইল খরচ তালিকা
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [themeColor, const Color(0xFF00695C)]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("আমরা যেখানে খরচ করি:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("• সার্ভার এবং হোস্টিং মেইনটেইনেন্স\n• এপিআই এবং এআই মডেল সাবস্ক্রিপশন\n• নতুন ফিচার ডেভেলপমেন্ট", style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // পরামর্শ কার্ড
        Container(
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              ..._adviceList.keys.map((key) => CheckboxListTile(
                title: Text(key, style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black)),
                value: _adviceList[key],
                activeColor: themeColor,
                onChanged: (v) => setState(() => _adviceList[key] = v!),
              )),
              CheckboxListTile(
                title: const Text("অন্যান্য পরামর্শ", style: TextStyle(fontSize: 13)),
                value: _isOtherSelected,
                activeColor: themeColor,
                onChanged: (v) => setState(() => _isOtherSelected = v!),
              ),
              if (_isOtherSelected)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _otherAdviceController,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    onChanged: (v) => setState(() {}),
                    decoration: InputDecoration(hintText: "আপনার পরামর্শ...", filled: true, fillColor: Colors.black12, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                  ),
                ),
              if (_shouldShowSubmit)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: themeColor), onPressed: () {}, child: const Text("Submit", style: TextStyle(color: Colors.white)))),
                )
            ],
          ),
        ),
      ],
    );
  }

  // --- ৫. ট্রান্সপারেন্সি রিপোর্টস ---
  Widget _buildTransparencyReports(Color cardBg, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Transparency Reports", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 10),
        _reportExpansionTile("Published Reports", Icons.verified_user, _isPublishedExpanded, () => setState(() => _isPublishedExpanded = !_isPublishedExpanded), [
          _publishedReportItem("January - April 2026", isDark),
          _publishedReportItem("Annual Audit 2025", isDark),
        ]),
        const SizedBox(height: 10),
        _reportExpansionTile("Upcoming Reports", Icons.pending_actions, _isUpcomingExpanded, () => setState(() => _isUpcomingExpanded = !_isUpcomingExpanded), [
          const ListTile(title: Text("Q3 Transparency Report", style: TextStyle(color: Colors.white70, fontSize: 13)), trailing: Text("Expected: Oct", style: TextStyle(color: Colors.orange, fontSize: 11))),
        ]),
      ],
    );
  }



  // --- ৭. প্ল্যাটফর্ম আইকন ---
  Widget _buildPlatformIcons(bool isDark) {
    return Wrap(
      spacing: 25,
      children: [
        _platformIcon(Icons.android, "Android", isDark),
        _platformIcon(Icons.window, "Windows", isDark),
        _platformIcon(Icons.apple, "iOS", isDark),
        _platformIcon(Icons.laptop_mac, "Mac", isDark),
        _platformIcon(Icons.language, "Web", isDark),
      ],
    );
  }

  // --- হেল্পার উইজেটস ---

  Widget _infoSectionCard(Color bg, bool isDark, String title, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
      const SizedBox(height: 10),
      Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(15)), child: Column(children: children)),
    ]);
  }

  Widget _rowInfo(String label, String val, bool isDark) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)), Text(val, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 13))]));
  }

  Widget _reportExpansionTile(String title, IconData icon, bool expanded, VoidCallback onTap, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        ListTile(onTap: onTap, leading: Icon(icon, color: Colors.greenAccent, size: 20), title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)), trailing: Icon(expanded ? Icons.expand_less : Icons.expand_more, color: Colors.white38)),
        if (expanded) ...children,
      ]),
    );
  }

  Widget _publishedReportItem(String name, bool isDark) {
    return ListTile(
      title: Text(name, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.visibility, size: 18, color: Colors.blueAccent), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download, size: 18, color: Colors.white54), onPressed: () {}),
        ],
      ),
    );
  }


  Widget _platformIcon(IconData icon, String label, bool isDark) {
    return Column(children: [Icon(icon, color: isDark ? Colors.white38 : Colors.black38, size: 28), const SizedBox(height: 5), Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey))]);
  }
}
// --- Masjid shape ---
class MadinaDomeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;
    double domeHeight = 35; // গম্বুজের উচ্চতা

    // মদীনার গম্বুজের সরু শীর্ষবিন্দু থেকে শুরু
    path.moveTo(w * 0.5, 0);

    // বাম পাশের কার্ভ (সরু হয়ে নিচে নামবে)
    path.cubicTo(w * 0.45, 0, w * 0.2, domeHeight * 0.2, 0, domeHeight);

    // বাম পাশ থেকে নিচে
    path.lineTo(0, h - 20);
    path.quadraticBezierTo(0, h, 20, h);

    // নিচ থেকে ডান পাশ
    path.lineTo(w - 20, h);
    path.quadraticBezierTo(w, h, w, h - 20);

    // ডান পাশ থেকে উপরে
    path.lineTo(w, domeHeight);

    // ডান পাশের কার্ভ (সরু হয়ে উপরে শীর্ষবিন্দুতে মিলবে)
    path.cubicTo(w * 0.8, domeHeight * 0.2, w * 0.55, 0, w * 0.5, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
