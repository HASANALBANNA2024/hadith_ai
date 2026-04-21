import 'package:hive_flutter/hive_flutter.dart';
import '../api_service/hadith_api_service.dart';
import '../model/hadith_model.dart';
import '../model/chapter_model.dart';
import '../model/hadith_book_model.dart';

class DownloadLogic {
  static const String cacheBoxName = 'app_cache';
  static const String metaBoxName = 'download_metadata';

  // এপিআই থেকে সব বই আনা
  static Future<List<HadithBookModel>> getAllBooks() async {
    return await HadithApiService().fetchAllBooks();
  }

  // ক্যাশ থেকে বইয়ের তালিকা আনা
  static List<HadithBookModel> getCachedBooks() {
    var box = Hive.box(cacheBoxName);
    List? data = box.get("all_books");
    if (data == null) return [];
    return data.map((e) => HadithBookModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  // এপিআই থেকে চ্যাপ্টার আনা
  static Future<List<ChapterModel>> getChapters(String slug) async {
    return await HadithApiService().fetchChapters(slug);
  }

  // ক্যাশ থেকে চ্যাপ্টার আনা
  static List<ChapterModel> getCachedChapters(String slug) {
    var box = Hive.box(cacheBoxName);
    List? data = box.get("chapters_$slug");
    if (data == null) return [];
    return data.map((e) => ChapterModel.fromJson(Map<String, dynamic>.from(e), slug)).toList();
  }

  static Future<void> downloadFullChapter(String bookSlug, String chapterId) async {
    final String cacheKey = "hadiths_${bookSlug}_$chapterId";
    final api = HadithApiService();
    try {
      List<HadithModel> hadiths = await api.fetchHadiths(bookSlug, chapterId);
      if (hadiths.isNotEmpty) {
        await Hive.box(cacheBoxName).put(cacheKey, hadiths.map((e) => e.toJson()).toList());
        await Hive.box(metaBoxName).put("${bookSlug}_$chapterId", true);
      }
    } catch (e) { print("Error: $e"); }
  }

  static Future<void> downloadFullBook(String bookSlug) async {
    final api = HadithApiService();
    try {
      List<ChapterModel> chapters = await api.fetchChapters(bookSlug);
      for (var ch in chapters) {
        await downloadFullChapter(bookSlug, ch.id.toString());
      }
      await Hive.box(metaBoxName).put("full_book_$bookSlug", true);
    } catch (e) { print("Full Book Error: $e"); }
  }

  static Future<void> toggleDownload(String bookSlug, String chapterId, String name) async {
    final String metaKey = "${bookSlug}_$chapterId";
    if (isDownloaded(bookSlug, chapterId)) {
      await Hive.box(cacheBoxName).delete("hadiths_$metaKey");
      await Hive.box(metaBoxName).delete(metaKey);
    } else {
      await downloadFullChapter(bookSlug, chapterId);
    }
  }

  static bool isDownloaded(String bookSlug, String chapterId) {
    return Hive.box(metaBoxName).containsKey("${bookSlug}_$chapterId");
  }

  static Future<void> cacheAllDataOnStart() async {
    print("Startup background tasks completed.");
  }
}