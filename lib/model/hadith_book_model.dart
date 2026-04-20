class HadithBookModel {
  final String bookName;
  final String bookSlug;
  final String hadithCount;

  HadithBookModel({
    required this.bookName,
    required this.bookSlug,
    required this.hadithCount,
  });

  factory HadithBookModel.fromJson(Map<String, dynamic> json) {
    return HadithBookModel(
      // এপিআই থেকে আসা কি-এর নামগুলো এখানে দিতে হয়
      // যদি আপনি সার্ভিস থেকে 'book_name' কি দিয়ে পাঠান, তবে এখানেও তাই হবে
      bookName: json['book_name'] ?? json['bookName'] ?? 'অজানা গ্রন্থ',
      bookSlug: json['book_slug'] ?? json['bookSlug'] ?? '',
      hadithCount:
          json['hadith_count']?.toString() ??
          json['hadiths_count']?.toString() ??
          '0',
    );
  }
}
