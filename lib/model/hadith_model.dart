class HadithModel {
  final int hadithId;
  final String hadithNumber;
  final String narrator;
  final String arabicText;
  final String translation;
  final String grade; // এপিআই থেকে আসা 'status'
  final String gradeColor;
  final String bookName;
  final String chapterName;
  final String explanation;
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
    final bookData = json['book'] ?? {};
    final chapterData = json['chapter'] ?? {};

    // ১. চেক করা হচ্ছে ইংরেজি ডাটা আছে কি না (খালি স্ট্রিং বা নাল কি না)
    String rawEnglish = (json['hadithEnglish'] ?? "").toString().trim();
    String rawUrdu = (json['hadithUrdu'] ?? "").toString().trim();

    // ২. যদি ইংরেজি থাকে তবে ইংরেজি দেখাবে, নাহলে উর্দু দেখাবে
    String finalTranslation = rawEnglish.isNotEmpty
        ? rawEnglish
        : (rawUrdu.isNotEmpty ? rawUrdu : "No translation available");

    // ৩. বর্ণনাকারীর (Narrator) ক্ষেত্রেও একই লজিক
    String rawNarratorEn = (json['englishNarrator'] ?? "").toString().trim();
    String rawNarratorUr = (json['urduNarrator'] ?? "").toString().trim();
    String finalNarrator = rawNarratorEn.isNotEmpty
        ? rawNarratorEn
        : (rawNarratorUr.isNotEmpty ? rawNarratorUr : "Narrator info missing");

    return HadithModel(
      hadithId: json['id'] ?? 0,
      hadithNumber: (json['hadithNumber'] ?? "").toString(),
      narrator: finalNarrator,
      arabicText: json['hadithArabic'] ?? "",
      translation: finalTranslation, // এখানে আমাদের সেই ডায়নামিক অনুবাদ
      grade: json['status'] ?? "Unknown",
      gradeColor: json['grade_color'] ?? "#E4C381",
      bookName: bookData['bookName'] ?? "Unknown Book",
      chapterName: chapterData['chapterEnglish'] ?? "Unknown Chapter",
      explanation: (json['headingEnglish'] ?? "").toString().isNotEmpty
          ? json['headingEnglish']
          : (json['headingUrdu'] ?? "ব্যাখ্যা নেই"),
      narratorBio: bookData['aboutWriter'] ?? "তথ্য নেই।",
      tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
      reference:
          "Book: ${bookData['bookName']}, Hadith: ${json['hadithNumber']}",
    );
  }
}
