import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarkService {
  static const String boxName = "hadith_bookmarks";

  // Database initialization
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  // check in hadith bookmark status
  static bool isBookmarked(int hadithId) {
    var box = Hive.box(boxName);
    return box.containsKey(hadithId);
  }

  // bookmark
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
      'chapterEnglish': hadith.chapterName,
      'explanation': hadith.explanation,
      'aboutWriter': hadith.narratorBio,
      'tags': hadith.tags,
      'reference': hadith.reference,
    });
  }

  // selected bookmark deleted and clear
  static Future<void> removeBookmark(int hadithId) async {
    var box = Hive.box(boxName);
    await box.delete(hadithId);
  }

  // all bookmark list
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
        chapterName: item['chapterEnglish'] ?? '',
        explanation: item['explanation'] ?? '',
        narratorBio: item['aboutWriter'] ?? '',
        tags: List<String>.from(item['tags'] ?? []),
        reference: item['reference'] ?? '',
      );
    }).toList();
  }

  // all bookmark (Clear All)
  static Future<void> clearAll() async {
    var box = Hive.box(boxName);
    await box.clear();
  }
}
