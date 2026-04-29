class HadithModel {
  final int hadithId;
  final String hadithNumber;
  final String narrator;
  final String arabicText;
  final String translation;
  final String grade;
  final String gradeColor;
  final String bookName;
  final String bookSlug;
  final String chapterId;
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
    required this.bookSlug,
    required this.chapterId,
    required this.chapterName,
    required this.explanation,
    required this.narratorBio,
    required this.tags,
    required this.reference,
  });

  Map<String, dynamic> toJson() => {
    'id': hadithId,
    'hadithNumber': hadithNumber,
    'narrator': narrator,
    'hadithArabic': arabicText,
    'translation': translation,
    'status': grade,
    'gradeColor': gradeColor,
    'bookName': bookName,
    'bookSlug': bookSlug, // যোগ করা হলো
    'chapterId': chapterId, // যোগ করা হলো
    'chapterName': chapterName,
    'explanation': explanation,
    'narratorBio': narratorBio,
    'tags': tags,
    'reference': reference,
  };

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    // ১. ডাটা যদি Hive বা Local থেকে আসে
    if (json.containsKey('narrator') && !json.containsKey('book')) {
      return HadithModel(
        hadithId: json['id'] ?? 0,
        hadithNumber: json['hadithNumber'] ?? "",
        narrator: json['narrator'] ?? "",
        arabicText: json['hadithArabic'] ?? "",
        translation: json['translation'] ?? "",
        grade: json['status'] ?? "",
        gradeColor: json['gradeColor'] ?? "",
        bookName: json['bookName'] ?? "",
        bookSlug: json['bookSlug'] ?? "",
        chapterId: json['chapterId'] ?? "",
        chapterName: json['chapterName'] ?? "",
        explanation: json['explanation'] ?? "",
        narratorBio: json['narratorBio'] ?? "",
        tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
        reference: json['reference'] ?? "",
      );
    }

    // ২. ডাটা যদি সরাসরি API থেকে আসে
    final bookData = json['book'] ?? {};
    final chapterData = json['chapter'] ?? {};

    // --- Narrator Logic (English -> Urdu) ---
    // আপনার API-তে 'arabicNarrator' নেই, তাই ইংলিশ না থাকলে আমরা উর্দূ চেক করবো।
    String narratorText = (json['englishNarrator'] ?? "").toString().trim();

    if (narratorText.isEmpty) {
      narratorText = (json['urduNarrator'] ?? "").toString().trim();
    }

    if (narratorText.isEmpty) {
      narratorText = "Narrator in text";
    }

    // --- Translation Logic (English -> Urdu) ---
    String finalTranslation = (json['hadithEnglish'] ?? "").toString().trim();
    if (finalTranslation.isEmpty) {
      finalTranslation = (json['hadithUrdu'] ?? "No Translation")
          .toString()
          .trim();
    }

    return HadithModel(
      hadithId: json['id'] ?? 0,
      hadithNumber: (json['hadithNumber'] ?? "").toString(),
      narrator: narratorText, // আমাদের নতুন লজিক অনুযায়ী ভ্যালু
      arabicText: json['hadithArabic'] ?? "",
      translation: finalTranslation,
      grade: json['status'] ?? "Unknown",
      gradeColor: (json['status'] == "Sahih") ? "#4CAF50" : "#E4C381",
      bookName: bookData['bookName'] ?? "Unknown Book",
      bookSlug: json['bookSlug'] ?? "",
      chapterId: json['chapterId']?.toString() ?? "",
      chapterName: chapterData['chapterEnglish'] ?? "Unknown Chapter",
      explanation: (json['headingEnglish'] ?? "").toString().trim(),
      narratorBio: bookData['aboutWriter'] ?? "",
      tags: json['tags'] is List ? List<String>.from(json['tags']) : [],
      reference:
          "Book: ${bookData['bookName']}, Hadith: ${json['hadithNumber']}",
    );
  }
}
