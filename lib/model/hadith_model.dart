class HadithModel {
  final int hadithId;
  final String hadithNumber;
  final String narrator;
  final String arabicText;
  final String translation;
  final String grade; // এপিআই-এর 'status'
  final String gradeColor;
  final String bookName;
  final String chapterName;
  final String explanation; // এপিআই-এর 'heading'
  final String narratorBio;
  final List<String> tags;
  final String reference;

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

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    // নেস্টেড ডাটা (book এবং chapter) হ্যান্ডেল করা
    final bookData = json['book'] ?? {};
    final chapterData = json['chapter'] ?? {};

    // ১. অনুবাদ লজিক: ইংরেজি না থাকলে উর্দু দেখাবে
    String rawEnglish = (json['hadithEnglish'] ?? "").toString().trim();
    String rawUrdu = (json['hadithUrdu'] ?? "").toString().trim();
    String finalTranslation = rawEnglish.isNotEmpty
        ? rawEnglish
        : (rawUrdu.isNotEmpty ? rawUrdu : "No translation available");

    // ২. বর্ণনাকারী লজিক: ইংরেজি না থাকলে উর্দু
    String rawNarratorEn = (json['englishNarrator'] ?? "").toString().trim();
    String rawNarratorUr = (json['urduNarrator'] ?? "").toString().trim();
    String finalNarrator = rawNarratorEn.isNotEmpty
        ? rawNarratorEn
        : (rawNarratorUr.isNotEmpty ? rawNarratorUr : "Narrator info missing");

    // ৩. ব্যাখ্যা (Heading) লজিক: ইংরেজি না থাকলে উর্দু
    String rawHeadingEn = (json['headingEnglish'] ?? "").toString().trim();
    String rawHeadingUr = (json['headingUrdu'] ?? "").toString().trim();
    String finalExplanation = rawHeadingEn.isNotEmpty
        ? rawHeadingEn
        : (rawHeadingUr.isNotEmpty ? rawHeadingUr : "কোনো ব্যাখ্যা নেই");

    // ৪. গ্রেড কালার লজিক (Sahih হলে সবুজ, অন্যথায় সোনালী)
    String status = json['status'] ?? "Unknown";
    String color = (status == "Sahih") ? "#4CAF50" : "#E4C381";

    return HadithModel(
      hadithId: json['id'] ?? 0,
      hadithNumber: (json['hadithNumber'] ?? "").toString(),
      narrator: finalNarrator,
      arabicText: json['hadithArabic'] ?? "",
      translation: finalTranslation,
      grade: status,
      gradeColor: color,
      bookName: bookData['bookName'] ?? "Unknown Book",
      chapterName: chapterData['chapterEnglish'] ?? "Unknown Chapter",
      explanation: finalExplanation,
      narratorBio: bookData['aboutWriter'] ?? "তথ্য নেই।",
      tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
      reference:
          "Book: ${bookData['bookName'] ?? ""}, Hadith: ${json['hadithNumber'] ?? ""}",
    );
  }
}
