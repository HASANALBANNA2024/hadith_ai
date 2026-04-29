import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hadith_ai/widgets/custom_bottom_Nav.dart';
import 'package:hadith_ai/widgets/hadith_details_sheet.dart';
import 'package:hadith_ai/widgets/last_read_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class HadithListScreen extends StatefulWidget {
  final String bookTitle;
  final String bookSlug;
  final String chapterId;
  final String chapterTitle;
  final bool isDarkStatus;
  final int? targetHadithId;
  const HadithListScreen({
    Key? key,
    required this.bookTitle,
    required this.bookSlug,
    required this.chapterId,
    required this.chapterTitle,
    required this.isDarkStatus,
    required this.targetHadithId,
  }) : super(key: key);

  @override
  _HadithListScreenState createState() => _HadithListScreenState();
}

class _HadithListScreenState extends State<HadithListScreen> {
  List<dynamic> hadiths = [];
  bool isLoading = true;
  int _selectedIndex = 1;

  late bool _isDark;

  // API Key
  final String apiKey =
      "\$2y\$10\$K92YhAwUhG4o6upA4YPrGO4pfUM8DdBznR6Zueejhg9zPevBI6e";

  @override
  void initState() {
    super.initState();
    fetchHadiths();
    _isDark = widget.isDarkStatus;
  }

  // fethch hadith
  Future<void> fetchHadiths() async {
    setState(() => isLoading = true);

    final String cacheKey = "hadiths_${widget.bookSlug}_${widget.chapterId}";

    var box = Hive.box('app_cache');

    if (box.containsKey(cacheKey)) {
      print("🚀 Loading from Hive Cache...");
      List cachedData = box.get(cacheKey);
      setState(() {
        hadiths = cachedData;
        isLoading = false;
      });
      return;
    }

    print("🌐 Loading from API...");
    final String url =
        "https://hadithapi.com/api/hadiths?apiKey=$apiKey&book=${widget.bookSlug}&chapter=${widget.chapterId}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['hadiths'] != null && data['hadiths']['data'] != null) {
          final List fetchedData = data['hadiths']['data'];

          setState(() {
            hadiths = fetchedData;
            isLoading = false;
          });

          await box.put(cacheKey, fetchedData);
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
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
        preferredSize: const Size.fromHeight(kToolbarHeight + 10),
        child: Container(
          color: darkGreen,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: AppBar(
                backgroundColor: Colors.transparent,
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
              ? const Center(child: Text("Didn't found in hadith"))
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
        // এখানেও _isDark ব্যবহার করুন
        color: _isDark ? const Color(0xFF0D1F1D) : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomBottomNav(
              isDark: _isDark, // আপডেট করা লোকাল ভেরিয়েবল
              gold: goldColor,
              isWeb: isWeb, // আপনার স্ক্রিন সাইজ লজিক
              currentIndex: _selectedIndex,

              // এটিই মেইন কাজ করবে থিম পরিবর্তনের জন্য
              onThemeChanged: (newThemeValue) {
                setState(() {
                  _isDark = newThemeValue;
                });
              },

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
    // ১. আইটেমটিকে মডেলে কনভার্ট করা
    final HadithModel hModel = HadithModel.fromJson(
      Map<String, dynamic>.from(item),
    );

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
          // LastRead সেভ করা
          LastReadService.saveLastRead(
            bookName: hModel.bookName,
            bookSlug: hModel.bookSlug.isEmpty
                ? widget.bookSlug
                : hModel.bookSlug,
            chapterId: hModel.chapterId.isEmpty
                ? widget.chapterId
                : hModel.chapterId,
            hadithNumber: hModel.hadithNumber,
            translation: hModel.translation,
            hadithId: hModel.hadithId,
          );

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                HadithDetailSheet(hadith: hModel, isDarkMode: isDark),
          ).then((_) {
            if (mounted) setState(() {});
          });
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      hModel.grade.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Hadith# ${hModel.hadithNumber}",
                    style: TextStyle(
                      color: goldColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  hModel.arabicText,
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
              Text(
                hModel.translation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor, fontSize: 14, height: 1.5),
              ),
              const Divider(height: 25, thickness: 0.6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Narrator: ${hModel.narrator}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
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
