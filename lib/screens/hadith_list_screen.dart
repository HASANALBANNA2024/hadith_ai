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
              return _buildHadithCard(item, cardColor, textColor, goldColor, isDarkMode);
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDarkMode, bgColor, goldColor, isWeb),
    );
  }

  Widget _buildHadithCard(dynamic item, Color cardColor, Color textColor, Color goldColor, bool isDark) {
    bool isSahih = (item['status'] ?? "").toString().toLowerCase().contains("sahih");

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: goldColor.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: InkWell(
        onTap: () {
          // Details screen navigation here
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSahih ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSahih ? Colors.green : Colors.red, width: 0.5),
                    ),
                    child: Text(
                      item['status'] ?? "Unknown",
                      style: TextStyle(color: isSahih ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: goldColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: goldColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      "H${item['hadithNumber']}",
                      style:  TextStyle(color: goldColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  item['hadithArabic'] ?? "",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: isDark ? goldColor : const Color(0xFF004D40),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item['hadithEnglish'] ?? "",
                style: TextStyle(color: textColor, fontSize: 13, height: 1.5),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
               Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_forward, size: 16, color: goldColor),
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