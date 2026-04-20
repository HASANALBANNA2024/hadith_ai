import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final String apiKey = "\$2y\$10\$K92YhAwUhG4o6upA4YPrGO4pfUM8DdBznR6Zueejhg9zPevBI6e";

  @override
  void initState() {
    super.initState();
    fetchHadiths();
  }

  Future<void> fetchHadiths() async {
    final String url = "https://hadithapi.com/api/hadiths?apiKey=$apiKey&book=${widget.bookSlug}&chapter=${widget.chapterId}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['hadiths'] != null && data['hadiths']['data'] != null) {
          setState(() {
            hadiths = data['hadiths']['data'];
            isLoading = false;
          });
        }
      } else {
        setState(() { isLoading = false; });
      }
    } catch (e) {
      setState(() { isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkStatus;
    const Color goldColor = Color(0xFFE4C381);
    const Color darkGreen = Color(0xFF004D40);

    final Color bgColor = isDarkMode ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7F9);
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;

    // Web check
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 700;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.chapterTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(widget.bookTitle, style: const TextStyle(fontSize: 10, color: goldColor)),
          ],
        ),
        backgroundColor: darkGreen,
        centerTitle: true,
        iconTheme: const IconThemeData(color: goldColor),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100), // Web View 1100px limit
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: goldColor))
              : hadiths.isEmpty
              ? const Center(child: Text("কোনো হাদিস পাওয়া যায়নি।"))
              : ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: hadiths.length,
            itemBuilder: (context, index) {
              final item = hadiths[index];
              return _buildCompactHadithCard(item, cardColor, textColor, goldColor, isDarkMode);
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDarkMode, bgColor, goldColor, isWeb),
    );
  }

  // Widget _buildCompactHadithCard(dynamic item, Color cardColor, Color textColor, Color goldColor, bool isDark) {
  //   String status = (item['status'] ?? "Unknown").toString();
  //   bool isSahih = status.toLowerCase().contains("sahih");
  //   bool isHasan = status.toLowerCase().contains("hasan");
  //
  //   // কালার স্কিম
  //   Color statusColor = isSahih ? const Color(0xFF4CAF50) : (isHasan ? Colors.orange : Colors.redAccent);
  //
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 14),
  //     decoration: BoxDecoration(
  //       color: cardColor,
  //       borderRadius: BorderRadius.circular(15),
  //       border: Border.all(color: goldColor.withOpacity(0.15)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(isDark ? 0.35 : 0.05),
  //           blurRadius: 12,
  //           offset: const Offset(0, 4),
  //         )
  //       ],
  //     ),
  //     child: InkWell(
  //       onTap: () {
  //         // Overlay logic
  //       },
  //       borderRadius: BorderRadius.circular(15),
  //       child: Padding(
  //         padding: const EdgeInsets.all(18.0), // টেক্সট ক্লিয়ারেন্সের জন্য প্যাডিং সামান্য বাড়ানো
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 // --- ওয়েবে বড় করা প্রিমিয়াম ব্যাজ (বামে) ---
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // সাইজ বাড়ানো হয়েছে
  //                   decoration: BoxDecoration(
  //                     color: statusColor.withOpacity(0.15),
  //                     borderRadius: BorderRadius.circular(10), // আধুনিক স্কয়ার-রাউন্ড শেপ
  //                     border: Border.all(color: statusColor, width: 1.5),
  //                   ),
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Icon(isSahih ? Icons.verified : Icons.info, size: 16, color: statusColor),
  //                       const SizedBox(width: 8),
  //                       Text(
  //                         status.toUpperCase(),
  //                         style: TextStyle(
  //                           color: statusColor,
  //                           fontSize: 12, // ফন্ট বড় করা হয়েছে
  //                           fontWeight: FontWeight.bold, // এক্সট্রা বোল্ড
  //                           letterSpacing: 0.8,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 // --- বড় হাদিস নাম্বার (ডানে) ---
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                   decoration: BoxDecoration(
  //                     color: goldColor.withOpacity(0.1),
  //                     borderRadius: BorderRadius.circular(8),
  //                     border: Border.all(color: goldColor.withOpacity(0.3)),
  //                   ),
  //                   child: Text(
  //                     "Hadith# ${item['hadithNumber']}",
  //                     style: TextStyle(
  //                       color: goldColor,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 14, // নাম্বার বড় করা হয়েছে
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //
  //             const SizedBox(height: 20),
  //
  //             // আরবি টেক্সট (Line Height বাড়িয়ে আরও ক্লিয়ার করা হয়েছে)
  //             Align(
  //               alignment: Alignment.centerRight,
  //               child: Text(
  //                 item['hadithArabic'] ?? "",
  //                 textAlign: TextAlign.right,
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: TextStyle(
  //                   color: isDark ? goldColor : const Color(0xFF1B5E20),
  //                   fontSize: 21,
  //                   fontWeight: FontWeight.bold,
  //                   height: 1.5, // টেক্সট ক্লিয়ারেন্স
  //                 ),
  //               ),
  //             ),
  //
  //             const SizedBox(height: 14),
  //
  //             // ইংরেজি টেক্সট (High Contrast)
  //             Text(
  //               item['hadithEnglish'] ?? "",
  //               maxLines: 2,
  //               overflow: TextOverflow.ellipsis,
  //               style: TextStyle(
  //                 color: isDark ? Colors.white.withOpacity(0.95) : Colors.black87,
  //                 fontSize: 14.5,
  //                 height: 1.6,
  //                 fontWeight: FontWeight.w400,
  //               ),
  //             ),
  //
  //             const Divider(height: 30, thickness: 0.8),
  //
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 // বর্ণনাকারী সংক্ষেপে (UX এর জন্য)
  //                 Expanded(
  //                   child: Text(
  //                     "Narrator: ${item['englishNarrator'] ?? ""}",
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: TextStyle(color: Colors.grey[500], fontSize: 11, fontStyle: FontStyle.italic),
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text("বিস্তারিত", style: TextStyle(color: goldColor, fontSize: 13, fontWeight: FontWeight.bold)),
  //                     Icon(Icons.keyboard_arrow_right, color: goldColor, size: 20),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //

  Widget _buildCompactHadithCard(dynamic item, Color cardColor, Color textColor, Color goldColor, bool isDark) {
    String status = (item['status'] ?? "Unknown").toString();
    bool isSahih = status.toLowerCase().contains("sahih");
    bool isHasan = status.toLowerCase().contains("hasan");

    // মোবাইলের জন্য সাইজ চেক (৭০০ পিক্সেলের কম হলে মোবাইল ধরা হবে)
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 700;

    Color statusColor = isSahih ? const Color(0xFF4CAF50) : (isHasan ? Colors.orange : Colors.redAccent);

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
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          // বিস্তারিত প্যানেল
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
                        vertical: isMobile ? 4 : 8
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(isMobile ? 6 : 10),
                      border: Border.all(color: statusColor, width: isMobile ? 1 : 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isSahih ? Icons.verified : Icons.info, size: isMobile ? 12 : 16, color: statusColor),
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
                        vertical: isMobile ? 3 : 6
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
                  color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
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
                      style: TextStyle(color: Colors.grey[500], fontSize: 10, fontStyle: FontStyle.italic),
                    ),
                  ),
                  Row(
                    children: [
                      Text("বিস্তারিত", style: TextStyle(color: goldColor, fontSize: isMobile ? 11 : 13, fontWeight: FontWeight.bold)),
                      Icon(Icons.keyboard_arrow_right, color: goldColor, size: isMobile ? 16 : 20),
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

  Widget _buildBottomNav(bool isDark, Color bg, Color gold, bool isWeb) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? (MediaQuery.of(context).size.width - 1100) / 2 : 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1F1D) : Colors.white,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: gold,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        iconSize: isWeb ? 30 : 24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'হোম'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'গ্রন্থসমূহ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'অনুসন্ধান'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'সংরক্ষিত'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'সেটিংস'),
        ],
      ),
    );
  }
}