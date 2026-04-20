class HadithModel {
  final int hadithId;
  final String hadithNumber;
  final String narrator; // বর্ণনাকারী (যেমন: আবু হুরায়রা রা.)
  final String arabicText; // মূল আরবি টেক্সট
  final String translation; // আপনার পছন্দমতো ভাষা (বাংলা/ইংরেজি)
  final String grade; // সহীহ/হাসান/যঈফ
  final String gradeColor; // গ্রেড অনুযায়ী কালার কোড (সবুজ/লাল)
  final String bookName; // কিতাবের নাম (যেমন: সহীহ বুখারী)
  final String chapterName; // অধ্যায়ের নাম
  final String explanation; // হাদিসের বিস্তারিত ব্যাখ্যা (শরহ)
  final String narratorBio; // বর্ণনাকারীর সংক্ষিপ্ত জীবনী
  final List<String> tags; // বিষয়ভিত্তিক ট্যাগ (#নামাজ, #দোয়া)
  final String reference; // ইন্টারন্যাশনাল রেফারেন্স নম্বর

  HadithModel({
    required this.hadithId,
    required this.hadithNumber,
    required this.narrator,
    required this.arabicText,
    required this.translation,
    required this.grade,
    required this.gradeColor,
    required this.bookName,
    required this.chapterName,
    required this.explanation,
    required this.narratorBio,
    required this.tags,
    required this.reference,
  });

  // জেসন (JSON) থেকে ডাটা ম্যাপ করার জন্য ফ্যাক্টরি মেথড
  factory HadithModel.fromJson(Map<String, dynamic> json) {
    // nested ডাটা থেকে কিতাব এবং অধ্যায়ের নাম বের করা
    final bookData = json['book'] as Map<String, dynamic>? ?? {};
    final chapterData = json['chapter'] as Map<String, dynamic>? ?? {};

    return HadithModel(
      hadithId: json['id'] ?? 0,
      hadithNumber: (json['hadithNumber'] ?? '0').toString(),
      narrator: json['englishNarrator'] ?? '',
      arabicText: json['hadithArabic'] ?? '',
      translation: json['hadithEnglish'] ?? '', // ইংরেজি অনুবাদকে মেইন অনুবাদ হিসেবে ধরা হয়েছে
      grade: json['status'] ?? 'Unknown', // API-তে 'status' হিসেবে 'Sahih' আছে
      gradeColor: (json['status']?.toString().toLowerCase() == 'sahih')
          ? '0xFF4CAF50' // সহীহ হলে সবুজ
          : '0xFFFF5252', // অন্যথায় লাল (আপনি চাইলে ডাটাবেস থেকে কালার নিতে পারেন)
      bookName: bookData['bookName'] ?? 'Unknown Book',
      chapterName: chapterData['chapterEnglish'] ?? 'Unknown Chapter',
      explanation: json['hadithUrdu'] ?? 'ব্যাখ্যা পাওয়া যায়নি।', // আপনার ডাটাতে উর্দু ব্যাখ্যা আছে
      narratorBio: 'জীবনী পাওয়া যায়নি।',
      tags: [], // API-তে কোনো ট্যাগ লিস্ট দেখা যাচ্ছে না
      reference: "Vol: ${json['volume'] ?? ''}", // ভলিউমকে রেফারেন্স হিসেবে রাখা হয়েছে
    );
  }
}
