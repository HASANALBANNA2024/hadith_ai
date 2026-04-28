import 'package:flutter/material.dart';

class ProfileActionButton extends StatelessWidget {
  final bool isLoggedIn;
  final String planType;
  final String? userEmail;
  final VoidCallback onLoginTap;
  final VoidCallback onProfileTap;
  final VoidCallback onLogoutTap;

  const ProfileActionButton({
    super.key,
    required this.isLoggedIn,
    required this.planType,
    this.userEmail,
    required this.onLoginTap,
    required this.onProfileTap,
    required this.onLogoutTap,
  });

  // এই ফাংশনটি অটোমেটিক আপনার ডেটাবেসের প্ল্যান অনুযায়ী কালার ঠিক করে নিবে
  Color _getBadgeColor() {
    switch (planType.toLowerCase()) {
      case 'basic':
        return Colors.tealAccent;
      case 'plus':
        return Colors.lightBlueAccent;
      case 'standard':
        return Colors.limeAccent;
      case 'yearly':
        return Colors.purpleAccent;
      case 'lifetime':
        return Colors.redAccent;
      default:
        return Colors.white60;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = _getBadgeColor();

    // ইউজার লগইন না থাকলে সিম্পল টেক্সট বাটন
    if (!isLoggedIn) {
      return TextButton(
        onPressed: onLoginTap,
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }

    // লগইন থাকলে প্রিমিয়াম বাটন
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isDarkMode ? const Color(0xFF212121) : Colors.white,
      onSelected: (value) {
        if (value == 'profile') onProfileTap();
        if (value == 'logout') onLogoutTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Icon(Icons.verified, size: 35, color: badgeColor),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ইমেইল অংশ
              Text(
                userEmail ?? "No Email Found",
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              // ইনফরমেটিভ প্ল্যান কার্ড (সলিড এবং ক্লিন)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  planType.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black, // সবসময় কালো, যাতে স্পষ্ট পড়া যায়
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
        _buildItem('profile', Icons.person_outline, "My Account", isDarkMode),
        _buildItem(
          'logout',
          Icons.logout,
          "Log Out",
          isDarkMode,
          isDanger: true,
        ),
      ],
    );
  }

  // মেনু আইটেম তৈরির সহজ ফাংশন
  PopupMenuItem<String> _buildItem(
    String value,
    IconData icon,
    String title,
    bool isDark, {
    bool isDanger = false,
  }) {
    final color = isDanger
        ? Colors.redAccent
        : (isDark ? Colors.white70 : Colors.black87);
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}
