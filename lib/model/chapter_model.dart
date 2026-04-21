class ChapterModel {
  final int id;
  final int chapterId;
  final String chapterNumber;
  final String chapterTitle;
  final String bookSlug;
  final String hadithCount;

  ChapterModel({
    required this.id,
    required this.chapterId,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.bookSlug,
    required this.hadithCount,
  });

  // Hive এ ডাটা সেভ করার জন্য toJson মেথড
  Map<String, dynamic> toJson() => {
    'id': id,
    'chapterId': chapterId,
    'chapterNumber': chapterNumber,
    'chapterTitle': chapterTitle,
    'bookSlug': bookSlug,
    'hadithCount': hadithCount,
  };

  factory ChapterModel.fromJson(Map<String, dynamic> json, String slug) {
    int apiId = json['id'] is int
        ? json['id']
        : int.tryParse(json['id'].toString()) ?? 0;

    return ChapterModel(
      id: apiId,
      chapterId: apiId,
      chapterNumber: json['chapterNumber']?.toString() ?? '0',
      chapterTitle: json['chapterBangla'] ?? json['chapterEnglish'] ?? 'শিরোনামহীন',
      bookSlug: json['bookSlug'] ?? slug, // ক্যাশ থেকে নিলে json এই থাকে
      hadithCount: (json['hadiths_count'] ?? json['hadith_count'] ?? '0').toString(),
    );
  }
}