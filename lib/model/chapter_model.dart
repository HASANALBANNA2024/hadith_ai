class ChapterModel {
  final int id;
  final String chapterNumber;
  final String chapterTitle; // এটি এখন ইংলিশ টাইটেল ধারণ করবে
  final String bookSlug;
  final String hadithCount;

  ChapterModel({
    required this.id,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.bookSlug,
    required this.hadithCount,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'chapterNumber': chapterNumber,
    'chapterEnglish': chapterTitle, // ইংলিশ কী-তে সেভ হবে
    'bookSlug': bookSlug,
    'hadiths_count': hadithCount,
  };

  factory ChapterModel.fromJson(Map<String, dynamic> json, String slug) {
    return ChapterModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      chapterNumber: json['chapterNumber']?.toString() ?? '0',
      // আপনার প্রিন্ট অনুযায়ী সঠিক কী: chapterEnglish
      chapterTitle: json['chapterEnglish'] ??
          json['chapterTitle'] ??
          json['chapter_english'] ?? 'No Title Found',
      bookSlug: json['bookSlug'] ?? slug,
      hadithCount: (json['hadithCount'] ?? json['hadiths_count'] ?? '0').toString(),
    );
  }
}