import 'package:flutter/material.dart';
import 'package:hadith_ai/authentication/login_popup.dart';
import 'package:hadith_ai/screens/dashboard_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF004D40);

    // অ্যান্ড্রয়েড স্টুডিও ডার্ক মোড স্টাইল ব্যাকগ্রাউন্ড
    final bgColor = isDarkMode ? const Color(0xFF1E1F22) : const Color(0xFFF4F7F6);
    final cardBg = isDarkMode ? const Color(0xFF2B2B2B) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1E1F22) : primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    "Support Our Mission",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 48), // ব্যালেন্সের জন্য
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  // ১. হিরো সেকশন
                  _buildHeroSection(primaryColor, isDarkMode),

                  const SizedBox(height: 30),

                  // ২. প্ল্যান কার্ড সেকশন (GridView এর বদলে Wrap ব্যবহার করা হয়েছে overflow ঠেকাতে)
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: _plans.map((plan) => ConstrainedBox(
                      // মোবাইলে কার্ডগুলো যেন সুন্দর দেখায় তাই উইডথ কন্ট্রোল
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width > 700 ? 340 : double.infinity,
                      ),
                      child: _buildPlanCard(plan, isDarkMode, cardBg),
                    )).toList(),
                  ),

                  const SizedBox(height: 40),

                  // ৩. ফিন্যান্স ইনফো সেকশন
                  _buildFinanceInfo(isDarkMode, primaryColor, cardBg),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(Color primaryColor, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2B2B2B) : primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, color: isDark ? Colors.amber : primaryColor, size: 40),
          const SizedBox(height: 15),
          Text(
            "হাদিস এআই-এর খিদমতে শরিক হোন",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "আপনার ক্ষুদ্র সহযোগিতা এই দ্বীনি প্রজেক্টকে সচল রাখতে এবং আরও উন্নত করতে সাহায্য করবে ইনশাআল্লাহ।",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(PlanData plan, bool isDark, Color cardBg) {
    final Color dynamicColor = plan.color;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dynamicColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ১. হেডার সেকশন
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [dynamicColor, dynamicColor.withOpacity(0.6)],
            ).createShader(bounds),
            child: const Icon(Icons.verified, size: 45, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            plan.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: dynamicColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            plan.price,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            plan.duration,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const Divider(height: 30, thickness: 0.5),

          // ২. ফিচার লিস্ট (অটো হাইট অ্যাডজাস্টমেন্ট)
          Column(
            children: plan.features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: dynamicColor, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),

          const SizedBox(height: 20),

          // ৩. বাটন (লগইন পপআপ লজিক সহ)
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                if (isLoggedIn) {
                  // অলরেডি লগইন থাকলে পেমেন্ট প্রসেস শুরু হবে
                  _redirectToPayment(plan.paymentUrl);
                } else {
                  // লগইন না থাকলে আপনার সেই পপআপটি দেখাবে
                  LoginPopup.show(
                    context,
                    onLoginSuccess: () {
                      // লগইন সাকসেস হলে স্টেট আপডেট করে পেমেন্টে পাঠাবে
                      setState(() => isLoggedIn = true);
                      _redirectToPayment(plan.paymentUrl);
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: dynamicColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                isLoggedIn ? "Pay Now" : "Select Plan",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceInfo(bool isDark, Color primaryColor, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: primaryColor, size: 24),
              const SizedBox(width: 12),
              const Text("স্বচ্ছতা ও দ্বীনি লক্ষ্য",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          _financeRow(Icons.dns, "সার্ভার ও এপিআই মেইনটেইনেন্স"),
          _financeRow(Icons.bolt, "হাই-স্পিড ডেটা প্রসেসিং"),
          _financeRow(Icons.auto_fix_high, "এআই মডেল কন্টিনিউয়াস আপডেট"),
          const Divider(height: 40),
          const Text(
            "Hadith AI একটি বিজ্ঞাপনহীন অলাভজনক প্ল্যাটফর্ম। আপনার এই সহযোগিতা সরাসরি প্রজেক্টের মান উন্নয়নে ব্যয় করা হবে ইনশাআল্লাহ।",
            style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _financeRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _redirectToPayment(String? url) => debugPrint("Redirecting: $url");
}

// PlanData class remains same
class PlanData {
  final String title, price, duration;
  final List<String> features;
  final Color color;
  final String? paymentUrl;
  PlanData({required this.title, required this.price, required this.duration, required this.features, required this.color, this.paymentUrl});
}

final List<PlanData> _plans = [
  PlanData(title: "Monthly Basic", price: "৳১০০", duration: "১ মাস", color: Colors.teal, features: ["সব হাদিস এক্সেস", "অ্যাড-ফ্রি সার্ভিস", "বুকমার্ক সুবিধা"]),
  PlanData(title: "Monthly Plus", price: "৳২০০", duration: "১ মাস", color: Colors.blue, features: ["সব হাদিস এক্সেস", "বুকমার্ক সিঙ্ক", "ডার্ক মোড প্রিমিয়াম"]),
  PlanData(title: "Standard", price: "৳৫০০", duration: "৬ মাস", color: const Color(0xFF004D40), features: ["প্রিমিয়াম ইউআই", "প্রায়োরিটি সাপোর্ট", "অফলাইন রিডিং"]),
  PlanData(title: "Yearly Basic", price: "৳৮০০", duration: "১ বছর", color: Colors.indigo, features: ["সাশ্রয়ী রেট", "সব ফিচার এক্সেস", "সার্ভার সাপোর্ট"]),
  PlanData(title: "Premium Patron", price: "৳১০০০", duration: "১ বছর", color: Colors.amber[800]!, features: ["এক্সক্লুসিভ ব্যাজ", "ডিরেক্ট সাপোর্ট", "নতুন ফিচার বেটা"]),
  PlanData(title: "Lifetime", price: "৳৫০০০", duration: "আজীবন", color: Colors.redAccent, features: ["আজীবন এক্সেস", "বিশেষ দাতা ব্যাজ", "সদকায়ে জারিয়া"]),
];
