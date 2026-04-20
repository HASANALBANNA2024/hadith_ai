import 'dart:convert';

import 'package:hadith_ai/model/hadith_model.dart';
import 'package:http/http.dart' as http;

class HadithApiService {
  // আপনার API Key এবং URL এখানে বসবে
  static const String apiKey = "\$2y\$10\$YOUR_API_KEY";
  static const String baseUrl = "https://hadithapi.com/api";

  Future<List<HadithModel>> fetchHadiths(String bookSlug, int chapterId) async {
    final url = Uri.parse(
      '$baseUrl/hadiths?apiKey=$apiKey&book=$bookSlug&chapter=$chapterId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // হাদিস এপিআই এর রেসপন্স স্ট্রাকচার অনুযায়ী ডাটা ম্যাপ করা
        List dynamicList = data['hadiths']['data'];

        return dynamicList
            .map(
              (json) => HadithModel.fromJson({
                'id': json['id'],
                'hadith_number': json['hadithNumber'],
                'narrator_name': json['englishNarrator'], // বা বাংলা থাকলে সেটি
                'text_arabic': json['hadithArabic'],
                'text_translation':
                    json['hadithEnglish'], // পরে 'text_bangla' দিয়ে রিপ্লেস করা যাবে
                'grade_status': json['status'],
                'grade_color': json['status'] == 'Sahih'
                    ? '0xFF2E7D32'
                    : '0xFFC62828',
                'book_name': json['book']['bookName'],
                'chapter_name': json['chapter']['chapterName'],
                'explanation_text':
                    json['explanation'] ?? 'ব্যাখ্যা শীঘ্রই আসছে...',
                'narrator_bio': 'বর্ণনাকারীর জীবনী ডাটাবেজে সংরক্ষিত হচ্ছে...',
                'tags': (json['tags'] as String? ?? '').split(','),
                'reference_no': json['hadithNumber'],
              }),
            )
            .toList();
      } else {
        throw Exception('সার্ভার থেকে ডাটা পাওয়া যায়নি!');
      }
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }
}
