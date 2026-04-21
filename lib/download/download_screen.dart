import 'package:flutter/material.dart';
import '../download/download_logic.dart';
import '../model/hadith_book_model.dart';
import '../model/chapter_model.dart';

class DownloadScreen extends StatefulWidget {
  final bool isDark;
  const DownloadScreen({super.key, required this.isDark});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final Color gold = const Color(0xFFFFD700);

  List<HadithBookModel> allBooks = [];
  List<ChapterModel> currentChapters = [];
  String? selectedBookSlug;
  bool isLoadingBooks = true;
  bool isLoadingChapters = false;

  // কন্ট্রোল ভ্যারিয়েবল (শো/হাইড করার জন্য)
  bool showFullKitabList = false;
  bool showChapterSelection = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final books = await DownloadLogic.getAllBooks();
    setState(() {
      allBooks = books.cast<HadithBookModel>();
      isLoadingBooks = false;
    });
  }

  Future<void> _loadChapters(String slug) async {
    setState(() {
      selectedBookSlug = slug;
      isLoadingChapters = true;
      currentChapters = [];
    });
    final chapters = await DownloadLogic.getChapters(slug);
    setState(() {
      currentChapters = chapters.cast<ChapterModel>();
      isLoadingChapters = false;
    });
  }

  // ডাউনলোড সাকসেস মেসেজ
  void _showSuccessDialog(String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Icon(Icons.check_circle, color: Colors.green, size: 50),
        content: Text("$name ডাউনলোড সম্পন্ন হয়েছে!", textAlign: TextAlign.center, style: TextStyle(color: widget.isDark ? Colors.white : Colors.black)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("ঠিক আছে", style: TextStyle(color: gold)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBg = widget.isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color txtC = widget.isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: widget.isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: widget.isDark ? const Color(0xFF0D1F1D) : const Color(0xFF008080),
        title: Text("Download Center", style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ১. মেইন কার্ড: Full Kitab
              _buildMainOptionCard(
                "Full Kitab Download",
                "একসাথে সম্পূর্ণ কিতাব অফলাইন সেভ করুন",
                Icons.library_books,
                cardBg, txtC,
                    () => setState(() {
                  showFullKitabList = !showFullKitabList;
                  showChapterSelection = false; // চ্যাপ্টার হাইড হবে
                }),
              ),

              const SizedBox(height: 15),

              // ২. মেইন কার্ড: Chapter Wise
              _buildMainOptionCard(
                "Chapter Wise Download",
                "পছন্দমতো আলাদা আলাদা অধ্যায় ডাউনলোড করুন",
                Icons.menu_book,
                cardBg, txtC,
                    () {
                  setState(() {
                    showChapterSelection = !showChapterSelection;
                    showFullKitabList = false; // কিতাব লিস্ট হাইড হবে
                  });
                  // ডিফল্টভাবে প্রথম বই (বুখারী) লোড করা
                  if (allBooks.isNotEmpty && selectedBookSlug == null) {
                    _loadChapters(allBooks[0].bookSlug);
                  }
                },
              ),

              const Divider(height: 40, color: Colors.grey),

              // --- ডাইনামিক কন্টেন্ট এরিয়া ---
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ফুল কিতাব লিস্ট (যদি ক্লিক করা হয়)
                      if (showFullKitabList) ...[
                        _sectionTitle("Available Full Books"),
                        ...allBooks.take(6).map((book) => _buildDownloadTile(
                          book.bookName,
                          book.bookSlug,
                          "${book.hadithCount} Hadiths",
                          "5.2 MB", // ডামি সাইজ
                          cardBg, txtC,
                        )),
                      ],

                      // চ্যাপ্টার সেকশন (যদি ক্লিক করা হয়)
                      if (showChapterSelection) ...[
                        _buildBookSelector(txtC),
                        const SizedBox(height: 15),
                        if (isLoadingChapters)
                          const Center(child: CircularProgressIndicator())
                        else
                          ...currentChapters.map((ch) => _buildDownloadTile(
                            ch.chapterTitle,
                            "${ch.bookSlug}_${ch.id}",
                            "Hadith: ${ch.hadithCount}",
                            "0.8 MB",
                            cardBg, txtC,
                          )),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // মেইন অপশন কার্ড ডিজাইন
  Widget _buildMainOptionCard(String title, String sub, IconData icon, Color bg, Color txt, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: gold.withOpacity(0.3), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: gold.withOpacity(0.1), radius: 25, child: Icon(icon, color: gold, size: 28)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: txt, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(sub, style: TextStyle(color: txt.withOpacity(0.6), fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: gold),
          ],
        ),
      ),
    );
  }

  // কিতাব সিলেক্টর চিপস
  Widget _buildBookSelector(Color txtC) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: allBooks.take(6).map((book) {
          bool isSel = selectedBookSlug == book.bookSlug;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(book.bookName),
              selected: isSel,
              onSelected: (v) => _loadChapters(book.bookSlug),

              // সিলেক্ট থাকা অবস্থায় কালার
              selectedColor: gold,

              // সিলেক্ট না থাকা অবস্থায় ব্যাকগ্রাউন্ড কালার
              backgroundColor: widget.isDark ? Colors.grey[900] : Colors.grey[200],

              // বর্ডারের কালার
              side: BorderSide(
                color: isSel ? gold : (widget.isDark ? Colors.white10 : Colors.grey[300]!),
                width: 1,
              ),

              // টেক্সট স্টাইল ডাইনামিক করা
              labelStyle: TextStyle(
                color: isSel ? Colors.black : txtC,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),

              // চিপসের শেপ গোল করা
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

              // ডিফল্ট নীল রং বা ছায়া সরাতে
              showCheckmark: false,
              elevation: 2,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyle(color: gold, fontSize: 16, fontWeight: FontWeight.bold))),
    );
  }

  // ইনফরমেটিভ ডাউনলোড টাইল
  Widget _buildDownloadTile(String name, String id, String info, String size, Color bg, Color txt) {
    bool isDown = DownloadLogic.isDownloaded(id);

    return Card(
      color: bg,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // বর্ডার দেওয়ার জন্য side ব্যবহার করুন
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1, // বর্ডারের পুরুত্ব (ঐচ্ছিক)
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        title: Text(name, style: TextStyle(color: txt, fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text("$info • $size", style: TextStyle(color: txt.withOpacity(0.5), fontSize: 12)),
        trailing: IconButton(
          icon: Icon(
            isDown ? Icons.check_circle_rounded : Icons.cloud_download_outlined,
            color: isDown ? Colors.green : Colors.blueAccent,
            size: 28,
          ),
          onPressed: () async {
            if (!isDown) {
              await DownloadLogic.toggleDownload(id, name);
              setState(() {});
              _showSuccessDialog(name); // পপ-আপ মেসেজ
            }
          },
        ),
      ),
    );
  }
}