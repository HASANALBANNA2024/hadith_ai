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
    // বুক এবং চ্যাপ্টার অবজেক্ট আলাদা করে নেওয়া (যদি নাল থাকে তবে সেভ থাকবে)
    final bookData = json['book'] ?? {};
    final chapterData = json['chapter'] ?? {};

    return HadithModel(
      hadithId:
          json['id'] ?? 0, // ক্লাসের ভেরিয়েবল hadithId এর সাথে মিল রাখা হয়েছে
      hadithNumber: (json['hadithNumber'] ?? "").toString(),
      narrator: json['englishNarrator'] ?? "Narrator not found",
      arabicText: json['hadithArabic'] ?? "",

      // আপনার ডাটা অনুযায়ী বাংলা অনুবাদ এপিআইতে না থাকলে ইংরেজি দেখাবে
      translation:
          json['hadithEnglish'] ??
          json['hadithUrdu'] ??
          "Translation not available",

      grade:
          json['status'] ?? "Unknown", // ক্লাসের grade এ এপিআই এর status বসবে
      gradeColor: json['grade_color'] ?? "#E4C381",

      bookName: bookData['bookName'] ?? "Unknown Book",
      chapterName: chapterData['chapterEnglish'] ?? "Unknown Chapter",

      // 'headingEnglish' কেই আমরা ব্যাখ্যা (explanation) হিসেবে ব্যবহার করছি
      explanation: json['headingEnglish'] ?? "ব্যাখ্যা পাওয়া যায়নি।",

      // এপিআই-তে সরাসরি বায়ো না থাকলে রাইটারের নাম ব্যবহার করা যেতে পারে
      narratorBio: bookData['aboutWriter'] ?? "তথ্য নেই।",

      tags: json['tags'] is List ? List<String>.from(json['tags']) : [],

      // রেফারেন্স হিসেবে ভলিউম এবং হাদিস নম্বর সেট করা হয়েছে
      reference:
          "Book: ${bookData['bookName']}, Hadith: ${json['hadithNumber']}",
    );
  }
}
