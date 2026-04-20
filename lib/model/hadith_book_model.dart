class HadithBookModel {
  final String bookName;
  final String bookSlug;
  final String hadithCount;
  final String? bookNameArabic; // এই নতুন লাইনটি যোগ করা হয়েছে

  HadithBookModel({
    required this.bookName,
    required this.bookSlug,
    required this.hadithCount,
    this.bookNameArabic, // কনস্ট্রাক্টরে যুক্ত করা হলো
  });

  factory HadithBookModel.fromJson(Map<String, dynamic> json) {
    return HadithBookModel(
      bookName: json['book_name'] ?? json['bookName'] ?? 'অজানা গ্রন্থ',
      bookSlug: json['book_slug'] ?? json['bookSlug'] ?? '',
      hadithCount:
      json['hadith_count']?.toString() ??
          json['hadiths_count']?.toString() ??
          '0',
      // এপিআই বা সার্ভিস থেকে পাঠানো আরবি নাম রিসিভ করা
      bookNameArabic: json['book_name_arabic'] ?? json['bookNameArabic'],
    );
  }
}