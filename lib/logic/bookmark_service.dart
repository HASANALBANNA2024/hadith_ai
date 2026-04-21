import 'package:hadith_ai/model/hadith_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarkService {
  static const String boxName = "hadith_bookmarks";

  // ১. ডাটাবেজ ইনিশিয়ালাইজেশন
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  // ২. চেক করা: হাদিসটি কি অলরেডি বুকমার্ক করা?
  static bool isBookmarked(int hadithId) {
    var box = Hive.box(boxName);
    return box.containsKey(hadithId);
  }

  // ৩. একক বুকমার্ক যোগ করা
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

  // ৪. নির্দিষ্ট একটি বুকমার্ক ডিলিট বা রিমুভ করা
  static Future<void> removeBookmark(int hadithId) async {
    var box = Hive.box(boxName);
    await box.delete(hadithId);
  }

  // ৫. সব বুকমার্ক লিস্ট আকারে নিয়ে আসা
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

  // ৬. সব বুকমার্ক একসাথে মুছে ফেলা (Clear All)
  static Future<void> clearAll() async {
    var box = Hive.box(boxName);
    await box.clear();
  }
}
