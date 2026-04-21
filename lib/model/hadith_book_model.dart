class HadithBookModel {
  final String bookName;
  final String bookSlug;
  final String hadithCount;
  final String? bookNameArabic;

  HadithBookModel({
    required this.bookName,
    required this.bookSlug,
    required this.hadithCount,
    this.bookNameArabic,
  });

  // Hive এ ডাটা সেভ করার জন্য toJson মেথড
  Map<String, dynamic> toJson() => {
    'bookName': bookName,
    'bookSlug': bookSlug,
    'hadithCount': hadithCount,
    'bookNameArabic': bookNameArabic,
  };

  factory HadithBookModel.fromJson(Map<String, dynamic> json) {
    return HadithBookModel(
      bookName: json['bookName'] ?? json['book_name'] ?? 'অজানা গ্রন্থ',
      bookSlug: json['bookSlug'] ?? json['book_slug'] ?? '',
      hadithCount: (json['hadithCount'] ?? json['hadith_count'] ?? json['hadiths_count'] ?? '0').toString(),
      bookNameArabic: json['bookNameArabic'] ?? json['book_name_arabic'],
    );
  }
}