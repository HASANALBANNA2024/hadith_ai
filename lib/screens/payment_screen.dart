import 'package:flutter/material.dart';
import 'package:hadith_ai/authentication/login_popup.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // --- ম্যানুয়াল টেস্টের জন্য ---
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF004D40);
    final bgColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF4F7F6);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Text(
                  "Support Our Mission",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 40), // ব্যালেন্স রাখার জন্য
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(primaryColor, isDarkMode),
                const SizedBox(height: 30),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth < 650
                        ? 2
                        : (constraints.maxWidth < 1000 ? 3 : 6);
                    double childAspectRatio = constraints.maxWidth < 650
                        ? 0.62
                        : (constraints.maxWidth < 1000 ? 0.70 : 0.55);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: _plans.length,
                      itemBuilder: (context, index) =>
                          _buildPlanCard(_plans[index], isDarkMode),
                    );
                  },
                ),
                const SizedBox(height: 40),
                _buildFinanceInfo(isDarkMode, primaryColor),
                const SizedBox(height: 50),
              ],
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
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.15),
            primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome,
            color: primaryColor,
            size: 40,
          ), // একটু মডার্ন আইকন
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
            style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(PlanData plan, bool isDark) {
    final Color dynamicColor = plan.color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dynamicColor.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: dynamicColor.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // কার্ডকে কন্টেন্ট অনুযায়ী ছোট রাখবে
        children: [
          // ১. হেডার সেকশন
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    dynamicColor,
                    dynamicColor.withOpacity(0.6),
                    dynamicColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: const Icon(
                  Icons.verified,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: dynamicColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  plan.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: dynamicColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                plan.price,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                plan.duration,
                style: const TextStyle(color: Colors.grey, fontSize: 9),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, thickness: 0.5),
              ),
            ],
          ),

          // ২. ফিচার সেকশন (Flexible + SingleChildScrollView ব্যবহার করা হয়েছে Overflow ঠেকাতে)
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: plan.features
                    .map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: dynamicColor,
                              size: 12,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                f,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ৩. বাটন
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: () {
                if (isLoggedIn) {
                  _redirectToPayment(plan.paymentUrl);
                } else {
                  LoginPopup.show(
                    context,
                    onLoginSuccess: () {
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
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                isLoggedIn ? "Pay Now" : "Select Plan",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _redirectToPayment(String? url) {
    debugPrint("Redirecting: ${url ?? 'dummy_url'}");
  }

  Widget _buildFinanceInfo(bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: primaryColor, size: 22),
              const SizedBox(width: 12),
              const Text(
                "স্বচ্ছতা ও দ্বীনি লক্ষ্য",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _financeRow(Icons.dns, "সার্ভার ও এপিআই মেইনটেইনেন্স"),
          _financeRow(Icons.bolt, "হাই-স্পিড ডেটা প্রসেসিং"),
          _financeRow(Icons.auto_fix_high, "এআই মডেল কন্টিনিউয়াস আপডেট"),
          const Divider(height: 40),
          const Text(
            "Hadith AI একটি বিজ্ঞাপনহীন অলাভজনক প্ল্যাটফর্ম। আপনার এই সহযোগিতা সরাসরি প্রজেক্টের মান উন্নয়নে ব্যয় করা হবে ইনশাআল্লাহ।",
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
              height: 1.6,
            ),
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
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

//PlanData and _plans list (No changes here)
class PlanData {
  final String title, price, duration;
  final List<String> features;
  final Color color;
  final String? paymentUrl;
  PlanData({
    required this.title,
    required this.price,
    required this.duration,
    required this.features,
    required this.color,
    this.paymentUrl,
  });
}

final List<PlanData> _plans = [
  PlanData(
    title: "Monthly Basic",
    price: "৳১০০",
    duration: "১ মাস",
    color: Colors.teal,
    paymentUrl: "url",
    features: ["সব হাদিস এক্সেস", "অ্যাড-ফ্রি সার্ভিস", "বুকমার্ক সুবিধা"],
  ),
  PlanData(
    title: "Monthly Plus",
    price: "৳২০০",
    duration: "১ মাস",
    color: Colors.blue,
    paymentUrl: "url",
    features: ["সব হাদিস এক্সেস", "বুকমার্ক সিঙ্ক", "ডার্ক মোড প্রিমিয়াম"],
  ),
  PlanData(
    title: "Standard",
    price: "৳৫০০",
    duration: "৬ মাস",
    color: const Color(0xFF004D40),
    paymentUrl: "url",
    features: ["প্রিমিয়াম ইউআই", "প্রায়োরিটি সাপোর্ট", "অফলাইন রিডিং"],
  ),
  PlanData(
    title: "Yearly Basic",
    price: "৳৮০০",
    duration: "১ বছর",
    color: Colors.indigo,
    paymentUrl: "url",
    features: ["সাশ্রয়ী রেট", "সব ফিচার এক্সেস", "সার্ভার সাপোর্ট"],
  ),
  PlanData(
    title: "Premium Patron",
    price: "৳১০০০",
    duration: "১ বছর",
    color: Colors.amber[800]!,
    paymentUrl: "url",
    features: ["এক্সক্লুসিভ ব্যাজ", "ডিরেক্ট সাপোর্ট", "নতুন ফিচার বেটা"],
  ),
  PlanData(
    title: "Lifetime",
    price: "৳৫০০০",
    duration: "আজীবন",
    color: Colors.redAccent,
    paymentUrl: "url",
    features: ["আজীবন এক্সেস", "বিশেষ দাতা ব্যাজ", "সদকায়ে জারিয়া"],
  ),
];
