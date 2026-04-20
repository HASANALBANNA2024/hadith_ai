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

  Widget _buildCompactHadithCard(dynamic item, Color cardColor, Color textColor, Color goldColor, bool isDark) {
    // স্ট্যাটাস চেক করা (সহীহ নাকি অন্য কিছু)
    String status = (item['status'] ?? "Unknown").toString();
    bool isSahih = status.toLowerCase().contains("sahih");
    bool isHasan = status.toLowerCase().contains("hasan");

    // স্ট্যাটাস অনুযায়ী কালার নির্ধারণ
    Color statusColor = isSahih ? Colors.green : (isHasan ? Colors.orange : Colors.red);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: goldColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          // Overlay sheet logic later
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- প্রিমিয়াম বড় ব্যাজ ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), // ব্যাজ বড় করা হয়েছে
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30), // মেডেল শেপ
                      border: Border.all(color: statusColor.withOpacity(0.6), width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isSahih ? Icons.verified : Icons.info_outline, size: 14, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          status.toUpperCase(), // বড় হাতের অক্ষরে স্ট্যাটাস
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11, // ফন্ট সাইজ বাড়ানো হয়েছে
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // হাদিস নাম্বার
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: goldColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Hadith# ${item['hadithNumber']}",
                      style: TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // আরবি টেক্সট (১-২ লাইনে সীমাবদ্ধ)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  item['hadithArabic'] ?? "",
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? goldColor : const Color(0xFF004D40),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ইংরেজি টেক্সট (২ লাইনে সীমাবদ্ধ)
              Text(
                item['hadithEnglish'] ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor.withOpacity(0.85),
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Divider(height: 25, thickness: 0.5),

              // বটম অ্যাকশন এরিয়া
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Narrator: ${item['englishNarrator']?.split(' ').take(3).join(' ')}...",
                    style: const TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                  Row(
                    children: [
                      Text("বিস্তারিত", style: TextStyle(color: goldColor, fontSize: 12, fontWeight: FontWeight.bold)),
                      Icon(Icons.keyboard_arrow_right, color: goldColor, size: 18),
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