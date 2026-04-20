class ChapterModel {
  final int chapterId;
  final String chapterNumber;
  final String chapterTitle; // অধ্যায়ের নাম
  final String bookSlug; // কোন কিতাবের অধ্যায় (যেমন: sahih-bukhari)
  final String hadithCount; // এই অধ্যায়ে মোট কতটি হাদিস আছে

  ChapterModel({
    required this.chapterId,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.bookSlug,
    required this.hadithCount,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json, String slug) {
    return ChapterModel(
      chapterId: json['id'] ?? 0,
      chapterNumber: json['chapterNumber'] ?? '0',
      chapterTitle:
          json['chapterBengali'] ??
          json['chapterEnglish'] ??
          '', // বাংলা না থাকলে ইংরেজি
      bookSlug: slug,
      hadithCount: json['hadiths_count']?.toString() ?? '0',
    );
  }
}
