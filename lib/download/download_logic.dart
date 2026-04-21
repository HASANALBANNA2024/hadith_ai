import 'package:hive_flutter/hive_flutter.dart';
import '../api_service/hadith_api_service.dart';
import '../model/hadith_book_model.dart';
import '../model/chapter_model.dart';

class DownloadLogic {
  static const String metaBoxName = 'download_metadata'; // ডাউনলোড স্ট্যাটাস সেভ করার জন্য
  static const String cacheBoxName = 'app_cache';       // কিতাব ও চ্যাপ্টার লিস্ট ক্যাশ করার জন্য
  static final HadithApiService _apiService = HadithApiService();

  // ১. অ্যাপ ওপেন হওয়ার সময় বক্স চেক এবং ওপেন করার মেথড
  static Future<void> checkAndOpenBox() async {
    if (!Hive.isBoxOpen(cacheBoxName)) {
      await Hive.openBox(cacheBoxName);
    }
    if (!Hive.isBoxOpen(metaBoxName)) {
      await Hive.openBox(metaBoxName);
    }
  }

  // ২. অ্যাপ ওপেন হওয়ার সময় ডাটা ক্যাশ করা
  static Future<void> cacheAllDataOnStart() async {
    await checkAndOpenBox(); // বক্স ওপেন নিশ্চিত করা
    var cBox = Hive.box(cacheBoxName);

    try {
      if (cBox.get('all_books') == null) {
        final List<HadithBookModel> books = await _apiService.fetchAllBooks();
        await cBox.put('all_books', books.map((e) => e.toJson()).toList());
      }

      List cachedBooksRaw = cBox.get('all_books', defaultValue: []);
      for (var bookMap in cachedBooksRaw.take(6)) {
        String slug = bookMap['bookSlug'];
        if (cBox.get('chapters_$slug') == null) {
          final List<ChapterModel> chapters = await _apiService.fetchChapters(slug);
          await cBox.put('chapters_$slug', chapters.map((e) => e.toJson()).toList());
        }
      }
    } catch (e) {
      print("Pre-caching Error: $e");
    }
  }

  // ৩. ক্যাশ থেকে কিতাব লিস্ট নেওয়া (Async ফিক্স করা হয়েছে)
  static Future<List<HadithBookModel>> getCachedBooks() async {
    await checkAndOpenBox(); // বক্স ওপেন নিশ্চিত করা
    var cBox = Hive.box(cacheBoxName);
    List rawData = cBox.get('all_books', defaultValue: []);
    return rawData.map((e) => HadithBookModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  // ৪. ক্যাশ থেকে চ্যাপ্টার লিস্ট নেওয়া
  static List<ChapterModel> getCachedChapters(String slug) {
    // এটি synchronous কারণ সচরাচর বক্স ওপেন থাকেই, তাও সেফটি চেক
    if (!Hive.isBoxOpen(cacheBoxName)) return [];
    var cBox = Hive.box(cacheBoxName);
    List rawData = cBox.get('chapters_$slug', defaultValue: []);
    return rawData.map((e) => ChapterModel.fromJson(Map<String, dynamic>.from(e), slug)).toList();
  }

  // ৫. ডাউনলোড চেক করা
  static bool isDownloaded(String id) {
    if (!Hive.isBoxOpen(metaBoxName)) return false;
    return Hive.box(metaBoxName).containsKey(id);
  }

  // ৬. ডাউনলোড টগল
  static Future<void> toggleDownload(String id, String name) async {
    await checkAndOpenBox(); // ডাউনলোড করার আগে বক্স চেক
    final box = Hive.box(metaBoxName);
    if (box.containsKey(id)) {
      await box.delete(id);
    } else {
      await box.put(id, {
        'id': id,
        'name': name,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  // সরাসরি এপিআই কল
  static Future<List<HadithBookModel>> getAllBooks() async => await _apiService.fetchAllBooks();
  static Future<List<ChapterModel>> getChapters(String bookSlug) async => await _apiService.fetchChapters(bookSlug);
}