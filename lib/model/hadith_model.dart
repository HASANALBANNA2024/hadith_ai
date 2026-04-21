class HadithModel {
  final int hadithId;
  final String hadithNumber;
  final String narrator;
  final String arabicText;
  final String translation;
  final String grade;
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

  // --- এই মেথডটি যোগ করা হয়েছে (এটি আপনার রেড লাইন দূর করবে) ---
  Map<String, dynamic> toJson() => {
    'id': hadithId,
    'hadithNumber': hadithNumber,
    'narrator': narrator,
    'hadithArabic': arabicText,
    'translation': translation,
    'status': grade,
    'gradeColor': gradeColor,
    'bookName': bookName,
    'chapterName': chapterName,
    'explanation': explanation,
    'narratorBio': narratorBio,
    'tags': tags,
    'reference': reference,
  };

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    // যদি ডাটা হাইভ (ক্যাশ) থেকে আসে, তবে সরাসরি নিচের ম্যাপ কি-গুলো ব্যবহার করবে
    if (json.containsKey('translation')) {
      return HadithModel(
        hadithId: json['id'] ?? 0,
        hadithNumber: json['hadithNumber'] ?? "",
        narrator: json['narrator'] ?? "",
        arabicText: json['hadithArabic'] ?? "",
        translation: json['translation'] ?? "",
        grade: json['status'] ?? "",
        gradeColor: json['gradeColor'] ?? "",
        bookName: json['bookName'] ?? "",
        chapterName: json['chapterName'] ?? "",
        explanation: json['explanation'] ?? "",
        narratorBio: json['narratorBio'] ?? "",
        tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
        reference: json['reference'] ?? "",
      );
    }

    // --- আপনার আগের এপিআই লজিক (অপরিবর্তিত) ---
    final bookData = json['book'] ?? {};
    final chapterData = json['chapter'] ?? {};

    String rawEnglish = (json['hadithEnglish'] ?? "").toString().trim();
    String rawUrdu = (json['hadithUrdu'] ?? "").toString().trim();
    String finalTranslation = rawEnglish.isNotEmpty
        ? rawEnglish
        : (rawUrdu.isNotEmpty ? rawUrdu : "No translation available");

    String rawNarratorEn = (json['englishNarrator'] ?? "").toString().trim();
    String rawNarratorUr = (json['urduNarrator'] ?? "").toString().trim();
    String finalNarrator = rawNarratorEn.isNotEmpty
        ? rawNarratorEn
        : (rawNarratorUr.isNotEmpty ? rawNarratorUr : "Narrator info missing");

    String rawHeadingEn = (json['headingEnglish'] ?? "").toString().trim();
    String rawHeadingUr = (json['headingUrdu'] ?? "").toString().trim();
    String finalExplanation = rawHeadingEn.isNotEmpty
        ? rawHeadingEn
        : (rawHeadingUr.isNotEmpty ? rawHeadingUr : "");

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
      narratorBio: bookData['aboutWriter'] ?? "",
      tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
      reference:
      "Book: ${bookData['bookName'] ?? ""}, Hadith: ${json['hadithNumber'] ?? ""}",
    );
  }
}