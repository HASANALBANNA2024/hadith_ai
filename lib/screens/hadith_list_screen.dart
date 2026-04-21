import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hadith_ai/widgets/custom_bottom_Nav.dart';
import 'package:hadith_ai/widgets/hadith_details_sheet.dart';
import 'package:http/http.dart' as http;

class HadithListScreen extends StatefulWidget {
  final String bookTitle;
  final String bookSlug;
  final String chapterId;
  final String chapterTitle;
  final bool isDarkStatus;

  const HadithListScreen({
    Key? key,
    required this.bookTitle,
    required this.bookSlug,
    required this.chapterId,
    required this.chapterTitle,
    required this.isDarkStatus,
  }) : super(key: key);

  @override
  _HadithListScreenState createState() => _HadithListScreenState();
}

class _HadithListScreenState extends State<HadithListScreen> {
  List<dynamic> hadiths = [];
  bool isLoading = true;
  int _selectedIndex = 1; // 'গ্রন্থসমূহ' সিলেক্টেড থাকবে

  // API Key - ডলারে আগে অবশ্যই ব্যাকস্ল্যাশ (\$) থাকবে
  final String apiKey =
      "\$2y\$10\$K92YhAwUhG4o6upA4YPrGO4pfUM8DdBznR6Zueejhg9zPevBI6e";

  @override
  void initState() {
    super.initState();
    fetchHadiths();
  }

  // fethch hadith
  Future<void> fetchHadiths() async {
    final String url =
        "https://hadithapi.com/api/hadiths?apiKey=$apiKey&book=${widget.bookSlug}&chapter=${widget.chapterId}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['hadiths'] != null && data['hadiths']['data'] != null) {
          // --- এই লাইনটি যোগ করুন ---
          print("TOTAL HADITHS: ${data['hadiths']['total']}");
          if (data['hadiths']['data'].isNotEmpty) {
            print("SAMPLE HADITH DATA: ${data['hadiths']['data'][0]}");
          }
          // -------------------------

          setState(() {
            hadiths = data['hadiths']['data'];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Fetch Catch Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkStatus;
    const Color goldColor = Color(0xFFE4C381);
    const Color darkGreen = Color(0xFF004D40);

    final Color bgColor = isDarkMode
        ? const Color(0xFF0F0F0F)
        : const Color(0xFFF5F7F9);
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;

    // Web check
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 1100;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          kToolbarHeight + 10,
        ), // দুই লাইনের টাইটেলের জন্য উচ্চতা সামান্য বাড়ানো হয়েছে
        child: Container(
          color: darkGreen, // পুরো স্ক্রিন জুড়ে AppBar-এর ব্যাকগ্রাউন্ড কালার
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 1100,
              ), // কন্টেন্ট ১১০০ পিক্সেলের মধ্যে থাকবে
              child: AppBar(
                backgroundColor: Colors
                    .transparent, // বাইরের কন্টেইনারের রঙ দেখানোর জন্য স্বচ্ছ করা হয়েছে
                elevation: 0,
                centerTitle: true,
                iconTheme: const IconThemeData(color: goldColor),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.chapterTitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        // ওয়েব ভিউতে ফন্ট ১৬ আর মোবাইলে ১৪
                        fontSize: MediaQuery.of(context).size.width > 1100
                            ? 16
                            : 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.bookTitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        // ওয়েব ভিউতে ফন্ট ১২ আর মোবাইলে ১০
                        fontSize: MediaQuery.of(context).size.width > 1100
                            ? 12
                            : 10,
                        color: goldColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
          ), // Web View 1100px limit
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: goldColor))
              : hadiths.isEmpty
              ? const Center(child: Text("কোনো হাদিস পাওয়া যায়নি।"))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: hadiths.length,
                  itemBuilder: (context, index) {
                    final item = hadiths[index];
                    return _buildCompactHadithCard(
                      item,
                      cardColor,
                      textColor,
                      goldColor,
                      isDarkMode,
                    );
                  },
                ),
        ),
      ),
      bottomNavigationBar: Container(
        // পুরো বারের ব্যাকগ্রাউন্ড কালার সেট করা
        color: widget.isDarkStatus ? const Color(0xFF0D1F1D) : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // আমাদের নতুন কাস্টম নেভিগেশন বার
            CustomBottomNav(
              isDark: widget.isDarkStatus,
              gold: goldColor,
              isWeb: isWeb,
              currentIndex:
                  _selectedIndex, // আপনার স্ক্রিনে ভেরিয়েবল নাম '_selectedIndex'
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactHadithCard(
    dynamic item,
    Color cardColor,
    Color textColor,
    Color goldColor,
    bool isDark,
  ) {
    String status = (item['status'] ?? "Unknown").toString();
    bool isSahih = status.toLowerCase().contains("sahih");
    bool isHasan = status.toLowerCase().contains("hasan");

    // মোবাইলের জন্য সাইজ চেক (৭০০ পিক্সেলের কম হলে মোবাইল ধরা হবে)
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 700;

    Color statusColor = isSahih
        ? const Color(0xFF4CAF50)
        : (isHasan ? Colors.orange : Colors.redAccent);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: goldColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          print(
            "API Data: $item",
          ); // এটি দিয়ে চেক করুন API থেকে কী কী নাম (Keys) আসছে

          final currentHadith = HadithModel.fromJson(item);

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                HadithDetailSheet(hadith: currentHadith, isDarkMode: isDark),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 14.0 : 20.0), // মোবাইলে প্যাডিং কম
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- রেসপন্সিভ ব্যাজ ---
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 16,
                      vertical: isMobile ? 4 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(isMobile ? 6 : 10),
                      border: Border.all(
                        color: statusColor,
                        width: isMobile ? 1 : 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSahih ? Icons.verified : Icons.info,
                          size: isMobile ? 12 : 16,
                          color: statusColor,
                        ),
                        SizedBox(width: isMobile ? 4 : 8),
                        Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: isMobile ? 9 : 12, // মোবাইলে ছোট ফন্ট
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- রেসপন্সিভ হাদিস নাম্বার ---
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 12,
                      vertical: isMobile ? 3 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: goldColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: goldColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      "Hadith# ${item['hadithNumber']}",
                      style: TextStyle(
                        color: goldColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 10 : 14, // মোবাইলে ছোট ফন্ট
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // আরবি টেক্সট
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  item['hadithArabic'] ?? "",
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? goldColor : const Color(0xFF1B5E20),
                    fontSize: isMobile ? 18 : 22, // মোবাইলে ফন্ট ছোট
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ইংরেজি টেক্সট
              Text(
                item['hadithEnglish'] ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withOpacity(0.9)
                      : Colors.black87,
                  fontSize: isMobile ? 13 : 15,
                  height: 1.5,
                ),
              ),

              const Divider(height: 25, thickness: 0.6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Narrator: ${item['englishNarrator'] ?? ""}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        // লাইট মোডে একটু গাঢ় ধূসর এবং ডার্ক মোডে হালকা সাদাটে রঙ
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: isMobile
                            ? 11
                            : 12, // সাইজ সামান্য বাড়ানো হয়েছে
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight
                            .w500, // একটু বোল্ড করলে টেক্সট ক্লিয়ার হয়
                        letterSpacing: 0.2, // অক্ষরগুলোর মাঝে সামান্য ফাঁকা
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "বিস্তারিত",
                        style: TextStyle(
                          color: goldColor,
                          fontSize: isMobile ? 11 : 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: goldColor,
                        size: isMobile ? 16 : 20,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
