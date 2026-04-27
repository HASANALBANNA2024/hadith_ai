import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF004D40);
    final bgColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F7F6);

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
                  icon: Icon(
                      Icons.arrow_back_ios,
                      color: isDarkMode ? Colors.white : Colors.white,
                      size: 18
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
                      fontSize: 16
                  ),
                ),


                const SizedBox(width: 40),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(

            constraints: const BoxConstraints(maxWidth: 1100),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



                _buildHeroSection(primaryColor, isDarkMode),
                const SizedBox(height: 25),


                LayoutBuilder(builder: (context, constraints) {
                  int crossAxisCount;
                  double childAspectRatio;

                  if (constraints.maxWidth < 650) {
                    crossAxisCount = 2;
                    childAspectRatio = 0.65;
                  } else if (constraints.maxWidth < 1000) {
                    crossAxisCount = 3;
                    childAspectRatio = 0.75;
                  } else {
                    crossAxisCount = 6;
                    childAspectRatio = 0.52;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 10,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: _plans.length,
                    itemBuilder: (context, index) {
                      return _buildPlanCard(_plans[index], isDarkMode);
                    },
                  );
                }),

                const SizedBox(height: 35),
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
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(Icons.mosque, color: primaryColor, size: 45),
          const SizedBox(height: 12),
          Text(
            "হাদিস এআই-এর খিদমতে শরিক হোন",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : primaryColor
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "আপনার ক্ষুদ্র দান এই দ্বীনি প্রজেক্টকে সচল রাখতে বড় ভূমিকা রাখবে ইনশাআল্লাহ।",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(PlanData plan, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: plan.color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [

          Text(plan.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(plan.price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: plan.color)),
          Text(plan.duration, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          const Divider(height: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plan.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, color: plan.color, size: 11),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                          f,
                          style: const TextStyle(fontSize: 9),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: plan.color,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text("Select", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceInfo(bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_outlined, color: primaryColor, size: 20),
              const SizedBox(width: 10),
              const Text("স্বচ্ছতা ও দ্বীনি লক্ষ্য", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          _financeRow(Icons.dns_outlined, "সার্ভার ও হাই-স্পিড এপিআই খরচ"),
          _financeRow(Icons.security_outlined, "নিরাপদ ডাটাবেজ ও ক্লাউড স্টোরেজ"),
          _financeRow(Icons.psychology_outlined, "এআই মডেল ট্রেনিং ও আপডেট"),
          const Divider(height: 30),
          const Text(
            "Hadith AI কোনো ব্যবসায়িক প্রজেক্ট নয়। এটি একটি অলাভজনক ও বিজ্ঞাপনহীন প্ল্যাটফর্ম। আপনার এই দান ইনশাআল্লাহ সদকায়ে জারিয়া হিসেবে কবুল হবে।",
            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _financeRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 12.5)),
        ],
      ),
    );
  }
}


class PlanData {
  final String title, price, duration;
  final List<String> features;
  final Color color;
  PlanData({required this.title, required this.price, required this.duration, required this.features, required this.color});
}

final List<PlanData> _plans = [
  PlanData(title: "Monthly Basic", price: "৳১০০", duration: "১ মাস", color: Colors.teal, features: ["সব হাদিস এক্সেস", "অ্যাড-ফ্রি সার্ভিস", "বুকমার্ক সুবিধা"]),
  PlanData(title: "Monthly Plus", price: "৳২০০", duration: "১ মাস", color: Colors.blue, features: ["সব হাদিস এক্সেস", "বুকমার্ক সিঙ্ক", "ডার্ক মোড প্রিমিয়াম"]),
  PlanData(title: "Standard", price: "৳৫০০", duration: "৬ মাস", color: const Color(0xFF004D40), features: ["প্রিমিয়াম ইউআই", "প্রায়োরিটি সাপোর্ট", "অফলাইন রিডিং"]),
  PlanData(title: "Yearly Basic", price: "৳৮০০", duration: "১ বছর", color: Colors.indigo, features: ["সাশ্রয়ী রেট", "সব ফিচার এক্সেস", "সার্ভার সাপোর্ট"]),
  PlanData(title: "Premium Patron", price: "৳১০০০", duration: "১ বছর", color: Colors.amber[800]!, features: ["এক্সক্লুসিভ ব্যাজ", "ডিরেক্ট সাপোর্ট", "নতুন ফিচার বেটা"]),
  PlanData(title: "Lifetime", price: "৳৫০০০", duration: "আজীবন", color: Colors.redAccent, features: ["আজীবন এক্সেস", "বিশেষ দাতা ব্যাজ", "সদকায়ে জারিয়া"]),
];