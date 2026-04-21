import 'package:flutter/material.dart';
import 'package:hadith_ai/api_service/hadith_api_service.dart';
import 'package:hadith_ai/model/chapter_model.dart';
import 'package:hadith_ai/widgets/custom_bottom_Nav.dart';

import 'hadith_list_screen.dart';

class ChapterListScreen extends StatefulWidget {
  final String bookTitle;
  final String bookSlug;
  final bool isDarkStatus;

  const ChapterListScreen({
    super.key,
    required this.bookTitle,
    required this.bookSlug,
    required this.isDarkStatus,
  });

  @override
  State<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  int _currentIndex = 0;
  // কালার ভেরিয়েবলগুলো এখানে ডিফাইন করা হয়েছে যাতে পুরো ক্লাসে ব্যবহার করা যায়
  final Color goldColor = const Color(0xFFE4C381);
  final Color primaryTeal = const Color(0xFF14532D);
  final Color darkBg = const Color(0xFF0D1F1D);
  final Color darkCardBg = const Color(0xFF111817);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // ছোট ওয়েব উইন্ডোতেও ওয়েব লেআউট কাজ করার জন্য ১১০০ পিক্সেল কন্ডিশন
    final bool isLargeScreen = screenWidth > 1100;

    return Scaffold(
      backgroundColor: widget.isDarkStatus ? darkBg : const Color(0xFFF3F4F6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          // পুরো স্ক্রিন জুড়ে ব্যাকগ্রাউন্ড কালার থাকবে
          color: widget.isDarkStatus ? const Color(0xFF112A27) : primaryTeal,
          child: Center(
            child: Container(
              // কন্টেন্টগুলো (Back Button, Title) ১১০০ পিক্সেলের মধ্যে থাকবে
              constraints: const BoxConstraints(maxWidth: 1100),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  widget.bookTitle,
                  // টাইটেল ওয়েব এবং মোবাইলে স্পষ্ট দেখানোর জন্য স্টাইল আপডেট
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width > 1100
                        ? 22
                        : 18,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          // web screen view constraints
          constraints: BoxConstraints(
            maxWidth: isLargeScreen ? 900 : double.infinity,
          ),
          child: Column(
            children: [
              _buildTopActions(widget.isDarkStatus, primaryTeal),
              Expanded(
                child: FutureBuilder<List<ChapterModel>>(
                  future: HadithApiService().fetchChapters(widget.bookSlug),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: goldColor),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "Hadith Data is loaded!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "Data isn't loaded please try again..",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    final chapters = snapshot.data!;
                    return isLargeScreen
                        ? GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // ওয়েবে পাশাপাশি ২টা কার্ড
                                  childAspectRatio: 5.0,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount: chapters.length,
                            itemBuilder: (context, index) => _buildChapterCard(
                              context,
                              chapters[index],
                              widget.isDarkStatus,
                              goldColor,
                              primaryTeal,
                              darkCardBg,
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            itemCount: chapters.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 2),
                            itemBuilder: (context, index) => _buildChapterCard(
                              context,
                              chapters[index],
                              widget.isDarkStatus,
                              goldColor,
                              primaryTeal,
                              darkCardBg,
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        // এটি পুরো স্ক্রিন জুড়ে ব্যাকগ্রাউন্ড কালার সেট করবে
        color: widget.isDarkStatus ? const Color(0xFF0D1F1D) : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // কন্টেন্ট এরিয়া ১১০০ পিক্সেলের মধ্যে সীমাবদ্ধ থাকবে
              constraints: const BoxConstraints(maxWidth: 1100),
              // নিচের উইডথটি নিশ্চিত করে যে কন্টেইনারটি যতটুকু সম্ভব জায়গা নেবে (১১০০ পর্যন্ত)
              width: MediaQuery.of(context).size.width,
              child: CustomBottomNav(
                isDark: widget.isDarkStatus,
                gold: goldColor,
                isWeb: isLargeScreen,
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  // বুকমার্ক স্ক্রিন থেকে অন্য স্ক্রিনে যাওয়ার জন্য পপ লজিক (যদি প্রয়োজন হয়)
                  if (index != 2) Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopActions(bool isDark, Color teal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Chapters",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(
    BuildContext context,
    ChapterModel chapter,
    bool isDark,
    Color gold,
    Color teal,
    Color darkCard,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      color: isDark ? darkCard : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HadithListScreen(
                bookTitle: widget.bookTitle,
                bookSlug: widget.bookSlug,
                chapterId: chapter.chapterNumber,

                chapterTitle: chapter.chapterTitle,
                isDarkStatus: isDark,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A2E2B)
                      : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    chapter.chapterNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? gold : teal,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  chapter.chapterTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.withOpacity(0.5),
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
