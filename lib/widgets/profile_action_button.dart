import 'package:flutter/material.dart';

class ProfileActionButton extends StatelessWidget {
  final bool isLoggedIn;
  final String
  planType; // 'basic', 'plus', 'standard', 'yearly', 'patron', 'lifetime'
  final VoidCallback onTap;

  const ProfileActionButton({
    super.key,
    required this.isLoggedIn,
    required this.planType,
    required this.onTap,
  });

  // প্ল্যান অনুযায়ী কালার সেট করা
  Color _getBadgeColor() {
    switch (planType.toLowerCase()) {
      case 'basic':
        return Colors.teal;
      case 'plus':
        return Colors.blue;
      case 'standard':
        return const Color(0xFF004D40);
      case 'yearly':
        return Colors.indigo;
      case 'patron':
        return Colors.amber[800]!;
      case 'lifetime':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = _getBadgeColor();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: isLoggedIn
            ? const EdgeInsets.all(4) // লগইন থাকলে শুধু আইকনের জন্য কম প্যাডিং
            : const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ), // লগইন না থাকলে লেখার জন্য প্যাডিং
        decoration: BoxDecoration(
          color: isLoggedIn
              ? Colors
                    .transparent // লগইন থাকলে ব্যাকগ্রাউন্ড নেই
              : (isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(30),
          border: isLoggedIn
              ? null // লগইন থাকলে কোনো বর্ডার নেই
              : Border.all(color: isDarkMode ? Colors.white12 : Colors.black12),
        ),
        child: isLoggedIn
            ? ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [badgeColor, badgeColor.withOpacity(0.8), badgeColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Icon(
                  Icons.verified,
                  size: 35, // শুধু আইকন তাই সাইজ আরও বড় করা হয়েছে
                  color: Colors.white,
                ),
              )
            : Text(
                "Login",
                style: TextStyle(
                  // color: isDarkMode ? Colors.white : Colors.black,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

/* ---------------------------------------------------------
  FUTURE CALLING GUIDE (ভবিষ্যতে যেখানে যা করবেন):
  ---------------------------------------------------------
  1. Firestore Data Call:
     স্ক্রিন লেভেলে StreamBuilder বা FutureBuilder ব্যবহার করে ইউজারের 'subscription'
     ফিল্ড থেকে 'planType' ডাইনামিকালি এখানে পাস করবেন।

  2. Local Storage Sync:
     অ্যাপ ওপেন হওয়ার সময় SharedPreferences থেকে 'isLoggedIn' চেক করে
     এই উইজেটটি আপডেট করবেন।

  3. Action Logic (onTap):
     onTap-এর ভেতর Navigator.push দিয়ে প্রোফাইল স্ক্রিন বা
     সাবস্ক্রিপশন ডিটেইলস স্ক্রিনে যাওয়ার কোড লিখবেন।

  4. Badge Customization:
     যদি ভবিষ্যতে 'verified' আইকনের বদলে কাস্টম ইমেজ (SVG/PNG) দিতে চান,
     তবে Icon() এর বদলে Image.asset() বা SvgPicture.asset() বসাবেন।
  ---------------------------------------------------------
*/
