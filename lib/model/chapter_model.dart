class ChapterModel {
  final int id;
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
    required this.id, // এটি রিকোয়ার্ড কিন্তু নিচে দেওয়া ছিল না
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json, String slug) {
    // এপিআই থেকে আসা আইডিটি আগে বের করে নেই
    int apiId = json['id'] is int
        ? json['id']
        : int.tryParse(json['id'].toString()) ?? 0;

    return ChapterModel(
      id: apiId, // এটি যোগ করা হলো, এখন আর লাল দাগ থাকবে না
      chapterId: apiId,
      chapterNumber: json['chapterNumber']?.toString() ?? '0',
      chapterTitle:
          json['chapterBangla'] ?? json['chapterEnglish'] ?? 'শিরোনামহীন',
      bookSlug: slug,
      hadithCount: (json['hadiths_count'] ?? json['hadith_count'] ?? '0')
          .toString(),
    );
  }
}
