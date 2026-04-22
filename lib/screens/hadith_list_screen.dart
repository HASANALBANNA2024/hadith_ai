import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hadith_ai/widgets/custom_bottom_Nav.dart';
import 'package:hadith_ai/widgets/hadith_details_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:hadith_ai/download/download_logic.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    setState(() => isLoading = true);

    // লজিক: প্রথমে চেক করো এই চ্যাপ্টারটি কি ডাউনলোড করা আছে?
    bool isOffline = DownloadLogic.isDownloaded(widget.bookSlug, widget.chapterId);

    if (isOffline) {
      print("🌐 লোড হচ্ছে অফলাইন (Hive) থেকে...");
      try {
        var box = Hive.box(DownloadLogic.cacheBoxName);
        final String cacheKey = "hadiths_${widget.bookSlug}_${widget.chapterId}";

        if (box.containsKey(cacheKey)) {
          List cachedData = box.get(cacheKey);
          setState(() {
            hadiths = cachedData;
            isLoading = false;
          });
          return; // অফলাইন ডাটা পেয়ে গেলে ফাংশন এখানেই শেষ
        }
      } catch (e) {
        print("Offline Load Error: $e");
      }
    }

    // যদি অফলাইনে না থাকে, তবেই কেবল এপিআই কল হবে
    print("📡 লোড হচ্ছে অনলাইন (API) থেকে...");
    final String url = "https://hadithapi.com/api/hadiths?apiKey=$apiKey&book=${widget.bookSlug}&chapter=${widget.chapterId}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)); // utf8.decode যোগ করা ভালো বাংলা ফন্টের জন্য
        if (data['hadiths'] != null && data['hadiths']['data'] != null) {
          setState(() {
            hadiths = data['hadiths']['data'];
            isLoading = false;
          });
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
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
    // ১. প্রথমেই আইটেমটিকে মডেলে কনভার্ট করে ফেলুন
    // এটি করলে অফলাইন বা অনলাইন সব ডাটা একই ফরম্যাটে চলে আসবে
    final HadithModel hModel = HadithModel.fromJson(Map<String, dynamic>.from(item));

    bool isSahih = hModel.grade.toLowerCase().contains("sahih");
    bool isHasan = hModel.grade.toLowerCase().contains("hasan");

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
          // অলরেডি hModel আছে, তাই সরাসরি পাঠিয়ে দিন
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => HadithDetailSheet(hadith: hModel, isDarkMode: isDark),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 14.0 : 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // স্ট্যাটাস ব্যাজ
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      hModel.grade.toUpperCase(), // hModel ব্যবহার করুন
                      style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // হাদিস নাম্বার
                  Text(
                    "Hadith# ${hModel.hadithNumber}", // hModel ব্যবহার করুন
                    style: TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // আরবি টেক্সট
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  hModel.arabicText, // hModel ব্যবহার করুন
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? goldColor : const Color(0xFF1B5E20),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // ইংরেজি অনুবাদ (এখন আর "No English" আসবে না)
              Text(
                hModel.translation, // hModel ব্যবহার করুন
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor, fontSize: 14, height: 1.5),
              ),
              const Divider(height: 25, thickness: 0.6),
              // ন্যারেটর
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Narrator: ${hModel.narrator}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right, color: goldColor, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
