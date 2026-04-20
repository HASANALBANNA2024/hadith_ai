class ChapterModel {
  final int chapterId;
  final String chapterNumber;
  final String chapterTitle;
  final String bookSlug;
  final String hadithCount;

  ChapterModel({
    required this.chapterId,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.bookSlug,
    required this.hadithCount,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json, String slug) {
    return ChapterModel(
      chapterId: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      chapterNumber: json['chapterNumber']?.toString() ?? '0',
      chapterTitle:
          json['chapterBangla'] ?? json['chapterEnglish'] ?? 'শিরোনামহীন',
      bookSlug: slug,
      // এপিআই-এর hadiths_count কী (key) থেকে সরাসরি ডেটা নেওয়া হচ্ছে
      hadithCount: (json['hadiths_count'] ?? json['hadith_count'] ?? '0')
          .toString(),
    );
  }
}
