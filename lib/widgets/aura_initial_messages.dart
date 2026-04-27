import 'package:flutter/material.dart';
import 'package:hadith_ai/screens/payment_screen.dart';

class AuraInitialMessages {
  // first time open of Aura AI
  static List<Map<String, dynamic>> getFirstTimeMessage()
  {
    return[
     {
       "type":"hadith",
       "content":"রাসূলুল্লাহ (সা.) বলেছেন: 'তোমাদের মধ্যে সেই ব্যক্তিই সর্বোত্তম, যে কুরআন শেখে এবং অন্যকে শেখায়।' (সহীহ বুখারী: ৫০২৭)\n\n(The best among you are those who learn the Qur'an and teach it.)",
     },
      {
        "type": "text",
        "content": "আসসালামু আলাইকুম! আমি Aura AI, আপনার ইসলামিক ডিজিটাল গাইড। আমি আপনাকে হাদিস খুঁজে পেতে, মাসআলা বুঝতে বা ইসলামের যেকোনো বিষয়ে তথ্য দিয়ে সাহায্য করতে পারি। আজ আমি আপনাকে কীভাবে সাহায্য করতে পারি?",
      },
      {
        "type": "donation",
        "content": "এই প্রজেক্টটি সদকায়ে জারিয়া হিসেবে পরিচালিত হচ্ছে। দ্বীনের এই খেদমতকে আরও উন্নত ও বিস্তৃত করতে আপনি আমাদের ডোনেশন দিয়ে সহযোগিতা করতে পারেন।",
      }
    ];
  }

  // after open second time
      static List<Map<String, dynamic>> getReturningMessages()
      {
          return[
                   {
                     "type":"donation",
                     "content":"এটি কেবল একটি সাবস্ক্রিপশন নয়, এটি আমাদের হাদিস প্রজেক্টকে এগিয়ে নেওয়ার একটি ক্ষুদ্র প্রয়াস। আপনার এই সহযোগিতা আমাদের সার্ভার খরচ মেটাতে এবং নতুন নতুন ফিচার নিয়ে আসতে সাহায্য করবে।",
                   }

                ];
      }

}

class DonationMessageCard extends StatelessWidget
{
  final String text;
  final VoidCallback onDonatePressed;

  const DonationMessageCard({super.key, required this.text, required this.onDonatePressed});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:  isDark ? Colors.green.withOpacity(0.1) : Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.volunteer_activism, color:  Colors.green, size: 30,),
          const SizedBox(height: 10,),
          
          Text(
            text, 
            textAlign:  TextAlign.center,
            style: TextStyle(fontSize: 14, color: isDark ? Colors.white70: Colors.black87,
            fontWeight:  FontWeight.bold),
          ),
          const SizedBox(height: 15,),
          ElevatedButton(
            onPressed: onDonatePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Subscription",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),


    );
  }
}