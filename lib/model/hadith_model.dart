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
    // যদি ডাটা হাইভ (ক্যাশ) থেকে আসে
    if (json.containsKey('translation')) {
      return HadithModel(
        hadithId: json['id'] ?? 0,
        hadithNumber: json['hadithNumber'] ?? "",
        narrator: json['narrator'] ?? "",
        arabicText: json['hadithArabic'] ?? "",
        translation: json['translation'] ?? "", // এখানে ইংলিশ থাকবে
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

    // এপিআই থেকে আসার সময় ইংলিশ ফিল্ডগুলো প্রায়োরিটি দেওয়া হয়েছে
    final bookData = json['book'] ?? {};
    final chapterData = json['chapter'] ?? {};

    // সরাসরি ইংরেজি ফিল্ড 'hadithEnglish' থেকে ডাটা নেওয়া হচ্ছে
    String finalTranslation = (json['hadithEnglish'] ?? "").toString().trim();
    if (finalTranslation.isEmpty) {
      finalTranslation = (json['hadithUrdu'] ?? "No English Translation available").toString().trim();
    }

    String finalNarrator = (json['englishNarrator'] ?? "Narrator info missing").toString().trim();
    String finalExplanation = (json['headingEnglish'] ?? "").toString().trim();

    return HadithModel(
      hadithId: json['id'] ?? 0,
      hadithNumber: (json['hadithNumber'] ?? "").toString(),
      narrator: finalNarrator,
      arabicText: json['hadithArabic'] ?? "",
      translation: finalTranslation,
      grade: json['status'] ?? "Unknown",
      gradeColor: (json['status'] == "Sahih") ? "#4CAF50" : "#E4C381",
      bookName: bookData['bookName'] ?? "Unknown Book",
      chapterName: chapterData['chapterEnglish'] ?? "Unknown Chapter",
      explanation: finalExplanation,
      narratorBio: bookData['aboutWriter'] ?? "",
      tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
      reference: "Book: ${bookData['bookName']}, Hadith: ${json['hadithNumber']}",
    );
  }
}