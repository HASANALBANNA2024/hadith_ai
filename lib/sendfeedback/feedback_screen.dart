import 'package:flutter/material.dart';
import 'package:hadith_ai/widgets/privacy_policy_screen.dart';

class FeedbackScreen extends StatefulWidget {
  final bool isDark;
  const FeedbackScreen({super.key, required this.isDark});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'Hadith Verification';
  bool _isLoading = false;

  final List<String> _categories = [
    'Hadith Verification',
    'App Bug',
    'UI/UX Suggestion',
    'New Feature',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    const Color goldColor = Color(0xFFE4C381);
    const Color darkGreen = Color(0xFF03221F);

    // থিম অনুযায়ী কালার সেটআপ
    final Color bgColor = widget.isDark ? darkGreen : Colors.grey[100]!;
    final Color appBarColor = widget.isDark ? goldColor : Colors.white;
    final Color appBarElementColor = widget.isDark
        ? Colors.black
        : Colors.black87;
    final Color formBg = widget.isDark
        ? Colors.white.withOpacity(0.01)
        : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      // --- ১১০০ পিক্সেল রেসপন্সিভ অ্যাপবার ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: appBarColor, // পুরো টপ বার কালার
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1100,
              ), // অ্যাপবার কন্টেন্ট লিমিট
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "Send Feedback",
                  style: TextStyle(
                    color: appBarElementColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: appBarElementColor),
                  onPressed: () => Navigator.pop(context),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
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
          ), // বডি কন্টেন্ট লিমিট
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: formBg,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: goldColor.withOpacity(widget.isDark ? 0.3 : 0.1),
                    width: 1.5,
                  ),
                  boxShadow: !widget.isDark
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "We value your input",
                        style: TextStyle(
                          color: goldColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildLabel("Your Name"),
                    _buildInput(
                      _nameController,
                      "Optional",
                      widget.isDark,
                      goldColor,
                    ),

                    _buildLabel("Your Email"),
                    _buildInput(
                      _emailController,
                      "Optional, for replies",
                      widget.isDark,
                      goldColor,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    _buildLabel("Feedback Category"),
                    _buildDropdown(widget.isDark, goldColor),

                    _buildLabel("Your Message"),
                    _buildInput(
                      _messageController,
                      "Type your thoughts here...",
                      widget.isDark,
                      goldColor,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 20),
                    _buildAttachmentBox(goldColor),
                    const SizedBox(height: 30),

                    // সাবমিট বাটন
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {}, // লজিক আপনার আগের মতই থাকবে
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Submit Feedback",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PrivacyPolicyScreen(isDark: widget.isDark),
                            ),
                          );
                        },
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: goldColor.withOpacity(0.8),
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- হেল্পার উইজেট (ডিজাইন অপরিবর্তিত) ---

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 15),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFE4C381),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController ctrl,
    String hint,
    bool isDark,
    Color gold, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.grey,
          fontSize: 13,
        ),
        filled: true,
        fillColor: isDark ? Colors.black38 : Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: gold.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: gold, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown(bool isDark, Color gold) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black38 : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: gold.withOpacity(0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: gold),
          dropdownColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
          items: _categories
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => _selectedCategory = val!),
        ),
      ),
    );
  }

  Widget _buildAttachmentBox(Color gold) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: gold.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.camera_alt, color: gold, size: 28),
          const SizedBox(height: 8),
          Text(
            "Tap to add images/logs",
            style: TextStyle(
              color: gold,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
