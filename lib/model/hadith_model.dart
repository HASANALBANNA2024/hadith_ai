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
    return HadithModel(
      hadithId: json['id'] ?? 0,
      hadithNumber: json['hadith_number'] ?? '0',
      narrator: json['narrator_name'] ?? '',
      arabicText: json['text_arabic'] ?? '',
      translation: json['text_translation'] ?? '',
      grade: json['grade_status'] ?? 'Unknown',
      gradeColor: json['grade_color'] ?? '0xFF808080',
      bookName: json['book_name'] ?? '',
      chapterName: json['chapter_name'] ?? '',
      explanation: json['explanation_text'] ?? 'ব্যাখ্যা পাওয়া যায়নি।',
      narratorBio: json['narrator_bio'] ?? 'জীবনী পাওয়া যায়নি।',
      tags: List<String>.from(json['tags'] ?? []),
      reference: json['reference_no'] ?? '',
    );
  }
}
