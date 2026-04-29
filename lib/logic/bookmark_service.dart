import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarkService {
  static const String boxName = "hadith_bookmarks";

  // Database initialization
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  // Check in hadith bookmark status
  static bool isBookmarked(int hadithId) {
    var box = Hive.box(boxName);
    return box.containsKey(hadithId);
  }

  // Add Bookmark (Updated to include new fields)
  static Future<void> addBookmark(HadithModel hadith) async {
    var box = Hive.box(boxName);
    await box.put(hadith.hadithId, {
      'id': hadith.hadithId,
      'hadithNumber': hadith.hadithNumber,
      'narrator': hadith.narrator,
      'hadithArabic': hadith.arabicText,
      'translation': hadith.translation,
      'status': hadith.grade,
      'gradeColor': hadith.gradeColor,
      'bookName': hadith.bookName,
      'bookSlug': hadith.bookSlug, // নতুন যোগ করা হয়েছে
      'chapterId': hadith.chapterId, // নতুন যোগ করা হয়েছে
      'chapterEnglish': hadith.chapterName,
      'explanation': hadith.explanation,
      'aboutWriter': hadith.narratorBio,
      'tags': hadith.tags,
      'reference': hadith.reference,
    });
  }

  // Remove Bookmark
  static Future<void> removeBookmark(int hadithId) async {
    var box = Hive.box(boxName);
    await box.delete(hadithId);
  }

  // Get All Bookmarks (Updated constructor to remove red lines)
  static List<HadithModel> getAllBookmarks() {
    var box = Hive.box(boxName);
    return box.values.map((item) {
      return HadithModel(
        hadithId: item['id'] ?? 0,
        hadithNumber: item['hadithNumber'] ?? '',
        narrator: item['narrator'] ?? '',
        arabicText: item['hadithArabic'] ?? '',
        translation: item['translation'] ?? '',
        grade: item['status'] ?? '',
        gradeColor: item['gradeColor'] ?? '#E4C381',
        bookName: item['bookName'] ?? '',
        bookSlug: item['bookSlug'] ?? '', // নতুন যোগ করা হয়েছে
        chapterId: item['chapterId'] ?? '', // নতুন যোগ করা হয়েছে
        chapterName: item['chapterEnglish'] ?? '',
        explanation: item['explanation'] ?? '',
        narratorBio: item['aboutWriter'] ?? '',
        tags: List<String>.from(item['tags'] ?? []),
        reference: item['reference'] ?? '',
      );
    }).toList();
  }

  // Clear All Bookmarks
  static Future<void> clearAll() async {
    var box = Hive.box(boxName);
    await box.clear();
  }
}
