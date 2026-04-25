import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  final bool isDark;
  const AboutAppScreen({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    const Color goldColor = Color(0xFFE4C381);
    const Color darkGreenBg = Color(
      0xFF03221F,
    );
    const Color cardInsideColor = Color(
      0xFF042B27,
    );

    final Color outerBg = isDark ? darkGreenBg : Colors.grey[200]!;
    final Color innerContentBg = isDark ? cardInsideColor : Colors.white;
    final Color textColor = isDark ? goldColor : Colors.black87;

    return Scaffold(
      backgroundColor: outerBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          90,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    goldColor,
                    Color(0xFFC5A059),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF2D1B07),
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    "About Us",
                    style: TextStyle(
                      color: Color(0xFF2D1B07),
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: innerContentBg,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: goldColor.withOpacity(
                        0.4,
                      ),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                     //app logo section
                      _buildLogoSection(goldColor),
                      const SizedBox(height: 15),
                      Text(
                        "HADITH AI",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 30),

                      //Vission
                      _buildSectionHeader("OUR VISION", goldColor),
                      _buildSectionText(
                        "To provide authentic and accessible Islamic knowledge, leveraging modern technology for guidance.",
                        isDark,
                      ),

                      const SizedBox(height: 20),

                      // Mission
                      _buildSectionHeader("MISSION", goldColor),
                      _buildSectionText(
                        "Building a reliable, comprehensive Hadith database with intelligent insights for global seekers of truth.",
                        isDark,
                      ),

                      const SizedBox(height: 25),

                      // Feature LIst
                      _buildSectionHeader("KEY FEATURES", goldColor),
                      const SizedBox(height: 15),
                      Center(
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: [
                              _buildFeatureItem(
                                "Verified Hadith Source",
                                goldColor,
                                isDark,
                              ),
                              _buildFeatureItem(
                                "AI-Powered Guidance",
                                goldColor,
                                isDark,
                              ),
                              _buildFeatureItem(
                                "Subject-Wise Categorization",
                                goldColor,
                                isDark,
                              ),
                              _buildFeatureItem(
                                "Interactive Learning",
                                goldColor,
                                isDark,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [goldColor, Color(0xFFB8860B)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: goldColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Version 1.0.1",
                          style: TextStyle(
                            color: Color(0xFF2D1B07),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                Text(
                  "Developed with guidance from Islamic scholars.\nContact us: support@hadithai.app",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: goldColor.withOpacity(0.6),
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper widgets---

  Widget _buildLogoSection(Color gold) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: gold, width: 2),
        gradient: RadialGradient(
          colors: [gold.withOpacity(0.2), Colors.transparent],
        ),
      ),
      child: Icon(Icons.auto_awesome, color: gold, size: 50),
    );
  }

  Widget _buildSectionHeader(String title, Color gold) {
    return Row(
      children: [
        Expanded(child: Divider(color: gold.withOpacity(0.3), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(
              color: gold,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: gold.withOpacity(0.3), thickness: 1)),
      ],
    );
  }

  Widget _buildSectionText(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, Color gold, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: gold,
            size: 18,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
