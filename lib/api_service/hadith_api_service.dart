import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import '../model/chapter_model.dart';
import '../model/hadith_book_model.dart';
import '../model/hadith_model.dart';

class HadithApiService {
  static const String apiKey = "\$2y\$10\$K92YhAwUhG4o6upA4YPrGO4pfUM8DdBznR6Zueejhg9zPevBI6e";
  static const String baseUrl = "https://hadithapi.com/api";
  static const String cacheBoxName = 'app_cache';

  // --- ১. চ্যাপ্টার লোড (Offline-First) ---
  Future<List<ChapterModel>> fetchChapters(String bookSlug) async {
    final String cacheKey = "chapters_$bookSlug";
    var box = Hive.box(cacheBoxName);

    if (box.containsKey(cacheKey)) {
      print("✅ Loading chapters from Cache: $cacheKey");
      List cachedData = box.get(cacheKey);
      return cachedData.map((item) => ChapterModel.fromJson(Map<String, dynamic>.from(item), bookSlug)).toList();
    }

    final String urlString = "$baseUrl/$bookSlug/chapters?apiKey=$apiKey";
    try {
      final response = await http.get(Uri.parse(urlString));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List dynamicList = data['chapters'] ?? [];

        final chapters = dynamicList.map((item) => ChapterModel.fromJson(item, bookSlug)).toList();
        await box.put(cacheKey, chapters.map((e) => e.toJson()).toList());
        return chapters;
      }
    } catch (e) {
      print("Chapter API Error: $e");
    }
    return [];
  }

  // --- ২. হাদিস লিস্ট লোড (Offline-First) ---
// আপনার সার্ভিস ক্লাসে fetchHadiths টিও একই লজিক ফলো করবে
  Future<List<HadithModel>> fetchHadiths(String bookSlug, String chapterId) async {
    final String cacheKey = "hadiths_${bookSlug}_$chapterId";
    var box = Hive.box(cacheBoxName);

    if (box.containsKey(cacheKey)) {
      List cachedData = box.get(cacheKey);
      return cachedData.map((item) => HadithModel.fromJson(Map<String, dynamic>.from(item))).toList();
    }

    final String urlString = '$baseUrl/hadiths?apiKey=$apiKey&book=$bookSlug&chapter=$chapterId';
    try {
      final response = await http.get(Uri.parse(urlString));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        List dynamicList = data['hadiths']['data'] ?? [];
        final hadiths = dynamicList.map((item) => HadithModel.fromJson(item)).toList();

        await box.put(cacheKey, hadiths.map((e) => e.toJson()).toList());
        return hadiths;
      }
    } catch (e) { print("Error: $e"); }
    return [];
  }

  // --- ৩. সকল বইয়ের তালিকা (English Titles Only) ---
  Future<List<HadithBookModel>> fetchAllBooks() async {
    const String cacheKey = "all_books";
    var box = Hive.box(cacheBoxName);

    if (box.containsKey(cacheKey)) {
      print("✅ Loading books from Cache");
      List cachedData = box.get(cacheKey);
      return cachedData.map((item) => HadithBookModel.fromJson(Map<String, dynamic>.from(item))).toList();
    }

    final url = Uri.parse('$baseUrl/books?apiKey=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List dynamicList = data['books'] ?? [];

        Map<String, String> sihahSittahNames = {
          'sahih-bukhari': 'صحيح البخاري',
          'sahih-muslim': 'صحيح مسلم',
          'al-tirmidhi': 'جامع الترمذي',
          'abu-dawood': 'سن أبي داود',
          'ibn-e-majah': 'سن ابن ماجه',
          'sunan-nasai': 'سن النسائي',
        };

        final books = dynamicList
            .where((item) => sihahSittahNames.containsKey(item['bookSlug']))
            .map((item) {
          String slug = item['bookSlug'];
          return HadithBookModel(
            // bookName এ ইংলিশ টাইটেল নেওয়া হচ্ছে
            bookName: item['bookName'] ?? 'Unknown Book',
            bookSlug: slug,
            hadithCount: (item['hadiths_count'] ?? '0').toString(),
            bookNameArabic: sihahSittahNames[slug],
          );
        }).toList();

        await box.put(cacheKey, books.map((e) => e.toJson()).toList());
        return books;
      }
    } catch (e) {
      print("Books API Error: $e");
    }
    return [];
  }


}