import 'package:flutter/material.dart';

class LoginPopup {
  static void show(
    BuildContext context, {
    required VoidCallback onLoginSuccess,
  }) {
    bool isOtpSent = false;
    bool isForgotPassword = false; // নতুন স্টেট: ইমেইল পরিবর্তনের জন্য

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            const primaryColor = Color(0xFF004D40);
            final screenWidth = MediaQuery.of(context).size.width;

            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1100),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  backgroundColor: isDarkMode
                      ? const Color(0xFF1E1E1E)
                      : Colors.white,
                  contentPadding: EdgeInsets.zero,
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  content: SingleChildScrollView(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      width: screenWidth > 500 ? 400 : screenWidth * 0.9,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isOtpSent
                                ? Icons.mark_email_read_outlined
                                : (isForgotPassword
                                      ? Icons.contact_mail_outlined
                                      : Icons.verified_user),
                            color: primaryColor,
                            size: 50,
                          ),
                          const SizedBox(height: 15),

                          Text(
                            isOtpSent
                                ? "OTP ভেরিফিকেশন"
                                : (isForgotPassword
                                      ? "ইমেইল পরিবর্তন করুন"
                                      : "স্বচ্ছতা ও স্বীকৃতির জন্য লগইন করুন"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Text(
                            isOtpSent
                                ? "আপনার ইমেইলে পাঠানো ৬ ডিজিটের কোডটি দিন"
                                : (isForgotPassword
                                      ? "আপনার আগের ইমেইলটি দিন যা পরিবর্তন করতে চান"
                                      : "নাম ও ইমেইল দিলে আপনার ব্যাজ ও সাবস্ক্রিপশন সব ডিভাইসে থাকবে"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // --- ইনপুট ফিল্ড লজিক ---
                          if (isOtpSent)
                            _buildTextField(
                              hint: "Enter 6-digit OTP",
                              icon: Icons.lock_clock_outlined,
                              isDarkMode: isDarkMode,
                              isOtp: true,
                            )
                          else if (isForgotPassword)
                            _buildTextField(
                              hint: "Enter registered email",
                              icon: Icons.email_outlined,
                              isDarkMode: isDarkMode,
                            )
                          else ...[
                            _buildTextField(
                              hint: "Enter your full name",
                              icon: Icons.person_outline,
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              hint: "Enter your email",
                              icon: Icons.email_outlined,
                              isDarkMode: isDarkMode,
                            ),
                          ],

                          const SizedBox(height: 20),

                          // --- মেইন বাটন ---
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!isOtpSent) {
                                  // ইমেইল বা ফরগট ইমেইল দিয়ে ওটিপি পাঠানো
                                  setState(() => isOtpSent = true);
                                } else {
                                  // ওটিপি ভেরিফাই করে সাকসেস
                                  Navigator.pop(context);
                                  onLoginSuccess();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                isOtpSent ? "Verify & Submit" : "Get OTP",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // --- ফরগট এবং ব্যাক বাটন লজিক ---
                          if (!isOtpSent && !isForgotPassword)
                            TextButton(
                              onPressed: () =>
                                  setState(() => isForgotPassword = true),
                              child: const Text(
                                "ইমেইল পরিবর্তন করতে চান? (Forgot)",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          if (isForgotPassword || isOtpSent)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isOtpSent = false;
                                  isForgotPassword = false;
                                });
                              },
                              child: const Text(
                                "ফিরে যান",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),

                          if (!isOtpSent && !isForgotPassword) ...[
                            const SizedBox(height: 15),
                            const Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 15),
                            _buildGoogleButton(
                              isDarkMode,
                              onLoginSuccess,
                              context,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildGoogleButton(
    bool isDark,
    VoidCallback onSuccess,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pop(context);
          onSuccess();
        },
        icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
        label: Text(
          "Continue with Google",
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static Widget _buildTextField({
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    bool isOtp = false,
  }) {
    return TextField(
      keyboardType: isOtp
          ? TextInputType.number
          : (hint.contains("email")
                ? TextInputType.emailAddress
                : TextInputType.name),
      textAlign: isOtp ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: 14,
        letterSpacing: isOtp ? 5 : 0,
        fontWeight: isOtp ? FontWeight.bold : FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
          letterSpacing: 0,
        ),
        prefixIcon: isOtp
            ? null
            : Icon(icon, size: 18, color: const Color(0xFF004D40)),
        filled: true,
        fillColor: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }
}
