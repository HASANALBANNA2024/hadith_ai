import 'package:flutter/material.dart';
import '../download/download_logic.dart';
import '../model/hadith_book_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  bool showFullKitabList = false;
  bool showChapterSelection = false;

  @override
  void initState() {
    super.initState();
    // স্ক্রিন লোড হওয়ার সাথে সাথে ডাটা ফেচ করা
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() => isLoadingBooks = true);

    try {
      // ১. বক্স ওপেন করা (যদি না থাকে)
      if (!Hive.isBoxOpen('app_cache')) {
        await Hive.openBox('app_cache');
      }

      // ২. ডাটা আনা (অবশ্যই await দিন)
      final List<HadithBookModel> books = await DownloadLogic.getCachedBooks();

      if (mounted) {
        if (books.isEmpty) {
          // ৩. ক্যাশ খালি থাকলে এপিআই কল
          final apiBooks = await DownloadLogic.getAllBooks();
          setState(() {
            allBooks = apiBooks;
            isLoadingBooks = false;
          });
        } else {
          setState(() {
            allBooks = books;
            isLoadingBooks = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error in Screen: $e");
      if (mounted) setState(() => isLoadingBooks = false);
    }
  }
  String _calculateSize(String hadithCountStr) {
    int count = int.tryParse(hadithCountStr) ?? 0;
    if (count == 0) return "0.1 MB";
    double sizeInMb = (count * 2.8) / 1024;
    return "${sizeInMb.toStringAsFixed(1)} MB";
  }

  Future<void> _loadChapters(String slug) async {
    if (!mounted) return;
    setState(() {
      selectedBookSlug = slug;
      isLoadingChapters = true;
      currentChapters = [];
    });

    try {
      // ১. প্রথমে ক্যাশ থেকে ডাটা ট্রাই করুন
      List<ChapterModel> chapters = DownloadLogic.getCachedChapters(slug);

      // ২. যদি ক্যাশ খালি থাকে তবে এপিআই থেকে আনুন
      if (chapters.isEmpty) {
        chapters = await DownloadLogic.getChapters(slug);
      }

      if (mounted) {
        setState(() {
          currentChapters = chapters;
          isLoadingChapters = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingChapters = false);
      debugPrint("Error loading chapters: $e");
    }
  }

  void _showSuccessDialog(String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 50),
        content: Text("$name ডাউনলোড সম্পন্ন হয়েছে!",
            textAlign: TextAlign.center,
            style: TextStyle(color: widget.isDark ? Colors.white : Colors.black)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("ঠিক আছে", style: TextStyle(color: gold)))
        ],
      ),
    );
  }
  // ডাউনলোড টগল লজিক


  @override
  Widget build(BuildContext context) {
    final Color cardBg = widget.isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color txtC = widget.isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: widget.isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: widget.isDark ? const Color(0xFF0D1F1D) : const Color(0xFF008080),
        elevation: 0,
        title: Text("Download Center", style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMainOptionCard(
                "Full Kitab Download",
                "একসাথে সম্পূর্ণ কিতাব অফলাইন সেভ করুন",
                Icons.library_books,
                cardBg, txtC,
                    () => setState(() {
                  showFullKitabList = !showFullKitabList;
                  showChapterSelection = false;
                }),
              ),
              const SizedBox(height: 15),
              _buildMainOptionCard(
                "Chapter Wise Download",
                "পছন্দমতো আলাদা আলাদা অধ্যায় ডাউনলোড করুন",
                Icons.menu_book,
                cardBg, txtC,
                    () {
                  setState(() {
                    showChapterSelection = !showChapterSelection;
                    showFullKitabList = false;
                  });
                  if (showChapterSelection && allBooks.isNotEmpty && selectedBookSlug == null) {
                    _loadChapters(allBooks[0].bookSlug);
                  }
                },
              ),
              const Divider(height: 40, color: Colors.grey),

              Expanded(
                child: isLoadingBooks
                    ? const Center(child: CircularProgressIndicator())
                    : (allBooks.isEmpty && (showFullKitabList || showChapterSelection))
                    ? const Center(child: Text("কোন ডাটা পাওয়া যায়নি। ইন্টারনেট কানেকশন চেক করুন।"))
                    : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (showFullKitabList) ...[
                        _sectionTitle("Available Full Books"),
                        ...allBooks.map((book) => _buildDownloadTile(
                          book.bookName,
                          book.bookSlug,
                          book.hadithCount,
                          cardBg, txtC,
                          isBook: true,
                        )),
                      ],

                      if (showChapterSelection) ...[
                        _buildBookSelector(txtC), // ওপরের বই সিলেক্ট করার চিপস
                        const SizedBox(height: 15),
                        if (isLoadingChapters)
                          const Center(child: CircularProgressIndicator())
                        else if (currentChapters.isEmpty)
                          const Center(child: Text("কোন চ্যাপ্টার পাওয়া যায়নি"))
                        else
                        // এখানে ম্যাপ করার সময় চ্যাপ্টার টাইল তৈরি হচ্ছে
                          ...currentChapters.map((ch) => _buildDownloadTile(
                            ch.chapterTitle,
                            "${ch.bookSlug}_${ch.id}", // ইউনিক আইডি
                            ch.hadithCount,
                            cardBg, txtC,
                            isBook: false, // চ্যাপ্টারের ক্ষেত্রে হাদিস সংখ্যা হাইড থাকবে
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

  // --- UI Helpers (Widgets) ---

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

  Widget _buildBookSelector(Color txtC) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: allBooks.map((book) {
          bool isSel = selectedBookSlug == book.bookSlug;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(book.bookName),
              selected: isSel,
              onSelected: (v) { if (v) _loadChapters(book.bookSlug); },
              selectedColor: gold,
              backgroundColor: widget.isDark ? Colors.grey[900] : Colors.grey[200],
              labelStyle: TextStyle(
                  color: isSel ? Colors.black : txtC,
                  fontSize: 13,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              showCheckmark: false,
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

  Widget _buildDownloadTile(String name, String id, String hadithCount, Color bg, Color txt, {bool isBook = false}) {
    // ১. বই বা চ্যাপ্টারের জন্য সঠিক স্লাগ এবং আইডি নির্ধারণ
    String bSlug = isBook ? id : (selectedBookSlug ?? "");

    // চ্যাপ্টার হলে আইডি থেকে শেষ অংশ (নাম্বার) নেওয়া, বই হলে "full" ফ্ল্যাগ ব্যবহার
    String cId = isBook ? "full" : id.split('_').last;

    // ২. হাইভ থেকে চেক করা (এটি অ্যাপ রিস্টার্ট দিলেও ডাটা রিড করবে)
    bool isDown = DownloadLogic.isDownloaded(bSlug, cId);

    String dynamicSize = _calculateSize(hadithCount);

    return Card(
      color: bg,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
            name,
            style: TextStyle(color: txt, fontWeight: FontWeight.w600, fontSize: 15)
        ),
        subtitle: Text(
          isBook ? "$hadithCount হাদিস • $dynamicSize" : "সাইজ: $dynamicSize",
          style: TextStyle(color: txt.withOpacity(0.5), fontSize: 12),
        ),
        trailing: IconButton(
          // আইকন সরাসরি হাইভের ডাটার ওপর নির্ভর করবে
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isDown ? Icons.check_circle_rounded : Icons.cloud_download_outlined,
              key: ValueKey<bool>(isDown),
              color: isDown ? Colors.green : Colors.blueAccent,
              size: 28,
            ),
          ),
          onPressed: () async {
            // ডাউনলোড শুরু করার আগে ইউজারকে ছোট একটি ফিডব্যাক দেওয়া (অপশনাল)
            if (!isDown) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$name ডাউনলোড শুরু হচ্ছে..."), duration: const Duration(seconds: 1)),
              );
            }

            if (isBook) {
              // পুরো কিতাব ডাউনলোড লজিক
              await DownloadLogic.downloadFullBook(bSlug);
            } else {
              // চ্যাপ্টার টগল (ডাউনলোড/ডিলিট) লজিক
              await DownloadLogic.toggleDownload(bSlug, cId, name);
            }

            // ৩. কাজ শেষ হওয়ার পর UI রিফ্রেশ
            if (mounted) {
              setState(() {
                // স্টেট আপডেট হওয়ার ফলে isDown আবার হাইভ থেকে নতুন ভ্যালু চেক করবে
              });
            }

            // সাকসেস মেসেজ দেখানো (যদি নতুন ডাউনলোড হয়)
            if (!isDown && DownloadLogic.isDownloaded(bSlug, cId)) {
              _showSuccessDialog(name);
            }
          },
        ),
      ),
    );
  }
}