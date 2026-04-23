import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final bool isDark;

  const PrivacyPolicyScreen({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    const Color goldColor = Color(0xFFE4C381);
    final Color bgColor = isDark ? const Color(0xFF0D1F1D) : Colors.white;
    final Color txtColor = isDark ? Colors.white : Colors.black87;
    final Color cardBg = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.grey.withOpacity(0.05);

    // রেসপনসিভ উইথ ক্যালকুলেশন
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 1100;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Privacy & Support",
          style: TextStyle(
            color: goldColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: goldColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          // ওয়েব ভিউতে ১১০০ পিক্সেলের বেশি হবে না
          width: isWeb ? 1100 : screenWidth,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ১. ডোনেশন সেকশন
                _buildDonationCard(goldColor, txtColor),

                const SizedBox(height: 25),

                // ২. ডাটা সোভারেন্টি (আগের কন্টেন্ট)
                _buildInfoSection(
                  Icons.security_outlined,
                  "Data Sovereignty",
                  "We believe in the sanctity of your privacy. Hadith AI does not transmit, sell, or store your personal identity on any external servers. All bookmarks and progress are stored locally.",
                  goldColor,
                  txtColor,
                  cardBg,
                ),

                // ৩. এআই ইন্টারপ্রিটেশন (আগের কন্টেন্ট)
                _buildInfoSection(
                  Icons.auto_awesome_outlined,
                  "AI & Ethical Interpretation",
                  "Our integration with Gemini AI provides contextual understanding. We do not use your private interactions to train global models. AI here is purely academic and supportive.",
                  goldColor,
                  txtColor,
                  cardBg,
                ),

                // ৪. অথেন্টিসিটি (আগের কন্টেন্ট)
                _buildInfoSection(
                  Icons.gavel_outlined,
                  "Commitment to Authenticity",
                  "This platform is dedicated to authentic Islamic knowledge. While AI provides insights, please consult with qualified scholars for final Fiqh rulings.",
                  goldColor,
                  txtColor,
                  cardBg,
                ),

                // ৫. অ্যানালিটিক্স (আগের কন্টেন্ট)
                _buildInfoSection(
                  Icons.analytics_outlined,
                  "Usage Analytics",
                  "We collect anonymous technical data (e.g., crash reports) to improve stability. This data cannot be traced back to an individual user.",
                  goldColor,
                  txtColor,
                  cardBg,
                ),

                // ৬. কন্টাক্ট (আগের কন্টেন্ট)
                _buildInfoSection(
                  Icons.contact_support_outlined,
                  "Rights & Contact",
                  "You have the absolute right to delete all data anytime. For inquiries, reach out via the official feedback channel in settings.",
                  goldColor,
                  txtColor,
                  cardBg,
                ),

                const SizedBox(height: 30),
                const Divider(color: Colors.grey, thickness: 0.3),
                const SizedBox(height: 20),

                // --- ৭. প্ল্যাটফর্ম সেকশন (নতুন আপডেট) ---
                Center(
                  child: Column(
                    children: [
                      Text(
                        "AVAILABLE ON ALL PLATFORMS",
                        style: TextStyle(
                          color: goldColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 30,
                        runSpacing: 20,
                        children: [
                          _buildPlatformIcon(Icons.language, "Website", () {}),
                          _buildPlatformIcon(Icons.android, "Android", () {}),
                          _buildPlatformIcon(Icons.apple, "iOS", () {}),
                          _buildPlatformIcon(
                            Icons.laptop_windows,
                            "Windows",
                            () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                Center(
                  child: Text(
                    "Version 1.0.0 • Verified Islamic Resource • 2026",
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.7),
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // প্ল্যাটফর্ম আইকন তৈরির মেথড
  Widget _buildPlatformIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.grey, size: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildDonationCard(Color gold, Color txt) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gold.withOpacity(0.15), gold.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_graph_rounded, color: gold, size: 35),
          const SizedBox(height: 12),
          Text(
            "Sadaqah Jariyah Project",
            style: TextStyle(
              color: gold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Hadith AI is a mission-driven project. Your contributions help us maintain high-speed servers and develop advanced Islamic tools.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: txt.withOpacity(0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite, size: 18),
            label: const Text("Support the Project"),
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    IconData icon,
    String title,
    String body,
    Color gold,
    Color txt,
    Color cardBg,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: gold, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: gold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    color: txt.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
