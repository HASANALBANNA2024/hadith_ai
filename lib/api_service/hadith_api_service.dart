import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/chapter_model.dart';
import '../model/hadith_book_model.dart';
import '../model/hadith_model.dart';

class HadithApiService {
  static const String apiKey =
      "\$2y\$10\$K92YhAwUhG4o6upA4YPrGO4pfUM8DdBznR6Zueejhg9zPevBI6e";
  static const String baseUrl = "https://hadithapi.com/api";

  // --- ১. চ্যাপ্টার লোড করার মেথড ---
  Future<List<ChapterModel>> fetchChapters(String bookSlug) async {
    final String urlString = "$baseUrl/$bookSlug/chapters?apiKey=$apiKey";
    final url = Uri.parse(urlString);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(
          utf8.decode(response.bodyBytes),
        );
        List dynamicList = data['chapters'] ?? [];

        return dynamicList.map<ChapterModel>((item) {
          // সরাসরি আইটেমটি পাঠিয়ে দেওয়া হচ্ছে যাতে ম্যাপিং নির্ভুল হয়
          return ChapterModel.fromJson(item, bookSlug);
        }).toList();
      }
    } catch (e) {
      print("Chapter Fetch Error: $e");
    }
    return [];
  }

  // --- ২. হাদিস লিস্ট লোড করার মেথড ---
  Future<List<HadithModel>> fetchHadiths(
    String bookSlug,
    String chapterId,
  ) async {
    // এই প্রিন্টটি যোগ করুন
    final String urlString =
        '$baseUrl/hadiths?apiKey=$apiKey&book=$bookSlug&chapter=$chapterId';
    print("--- CHECK THIS URL ---");
    print(urlString);
    print("----------------------");

    final url = Uri.parse(urlString);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // আপনার আগের কোড...
        final Map<String, dynamic> data = json.decode(
          utf8.decode(response.bodyBytes),
        );
        List dynamicList = data['hadiths']['data'] ?? [];
        return dynamicList.map((item) => HadithModel.fromJson(item)).toList();
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
    return [];
  }

  // --- ৩. সকল বইয়ের তালিকা লোড করার মেথড ---
  // --- সকল বইয়ের তালিকা লোড করার মেথড ---
  Future<List<HadithBookModel>> fetchAllBooks() async {
    final url = Uri.parse('$baseUrl/books?apiKey=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(
          utf8.decode(response.bodyBytes),
        );
        List dynamicList = data['books'] ?? [];

        return dynamicList.map((item) {
          String slug = item['bookSlug'] ?? '';

          // এপিআই স্লাগের সাথে মিলিয়ে আরবি নাম
          Map<String, String> arabicNames = {
            'sahih-bukhari': 'صحيح البخاري',
            'sahih-muslim': 'صحيح مسلم',
            'al-tirmidhi': 'جامع الترمذي',
            'abu-dawood': 'سن أبي داود',
            'ibn-e-majah': 'سن ابن ماجه',
            'sunan-nasai': 'سن النسائي',
            'mishkat': 'مشكاة المصابيح',
            'musnad-ahmad': 'مسند أحمد',
            'al-silsila-sahiha': 'السلسلة الصحيحة',
          };

          return HadithBookModel(
            bookName: item['bookName'] ?? 'Unknown Book',
            bookSlug: slug,
            hadithCount: (item['hadiths_count'] ?? '0').toString(),
            bookNameArabic: arabicNames[slug] ?? item['bookName'],
          );
        }).toList();
      }
    } catch (e) {
      print("Books API Error: $e");
    }
    return [];
  }

  // check
  Future<void> checkBookData(String bookSlug) async {
    // মুসনাদ বা সিলসিলার যেকোনো একটি চ্যাপ্টার আইডি (যেমন ১ বা ৫০০০)
    // মুসনাদ আহমাদের জন্য সাধারণত বড় আইডি লাগে, তাই আমরা কয়েকভাবে চেষ্টা করব
    List<String> trialIds = ["1", "4520", "5000"];

    for (String id in trialIds) {
      final url = '$baseUrl/hadiths?apiKey=$apiKey&book=$bookSlug&chapter=$id';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          if (data['hadiths'] != null && data['hadiths']['data'].isNotEmpty) {
            print("✅ SUCCESS for $bookSlug with Chapter ID: $id");
            print(
              "English Data Status: ${data['hadiths']['data'][0]['hadithEnglish'] != null ? "AVAILABLE" : "EMPTY"}",
            );
            return; // ডাটা পেয়ে গেলে লুপ বন্ধ
          }
        } else {
          print(
            "❌ FAILED for $bookSlug with ID: $id (Status: ${response.statusCode})",
          );
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }
}
