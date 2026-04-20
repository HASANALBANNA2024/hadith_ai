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
    final url = Uri.parse(
      '$baseUrl/hadiths?apiKey=$apiKey&book=$bookSlug&chapter=$chapterId',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(
          utf8.decode(response.bodyBytes),
        );
        if (data['status'] == 200 && data['hadiths'] != null) {
          List dynamicList = data['hadiths']['data'] ?? [];
          return dynamicList.map((json) {
            String status = json['status'] ?? 'Unknown';
            String color = (status == 'Sahih' || status == 'Hasan')
                ? '0xFF2E7D32'
                : '0xFFC62828';
            return HadithModel.fromJson({
              'id': json['id'],
              'hadith_number': json['hadithNumber'],
              'narrator_name': json['englishNarrator'] ?? '',
              'text_arabic': json['hadithArabic'] ?? '',
              'text_translation':
                  json['hadithUrdu'] ?? json['hadithEnglish'] ?? '',
              'grade_status': status,
              'grade_color': color,
              'book_name': json['book']?['bookName'] ?? '',
              'chapter_name': json['chapter']?['chapterName'] ?? '',
              'explanation_text':
                  json['explanation'] ?? 'ব্যাখ্যা শীঘ্রই আসছে...',
              'tags': (json['tags'] is String)
                  ? (json['tags'] as String).split(',')
                  : [],
              'reference_no': json['hadithNumber'] ?? '',
            });
          }).toList();
        }
      }
    } catch (e) {
      print("Hadith API Error: $e");
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

        // কনসোলে চেক করার জন্য প্রিন্ট (ঐচ্ছিক)
        // print("DEBUG: API Data for UI -> ${json.encode(dynamicList)}");

        return dynamicList.map((item) {
          String slug = item['bookSlug'] ?? '';

          // আরবি নামের ম্যাপ - যা এপিআই-তে নেই কিন্তু আমরা যোগ করছি
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
            // আরবি নাম থাকলে দিবে, না থাকলে ইংরেজি নামটাই ব্যাকআপ হিসেবে নিবে
            bookNameArabic: arabicNames[slug] ?? item['bookName'],
          );
        }).toList();
      }
    } catch (e) {
      print("Books API Error: $e");
    }
    return [];
  }
}
