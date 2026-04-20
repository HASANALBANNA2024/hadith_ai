import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/chapter_model.dart'; // আপনার মডেল ফাইলের পাথ অনুযায়ী

class HadithChapterApiService {
  static const String apiKey = "YOUR_API_KEY"; // আপনার আসল কি এখানে দিন
  static const String baseUrl = "https://hadithapi.com/api";

  Future<List<ChapterModel>> fetchChapters(String bookSlug) async {
    final url = Uri.parse('$baseUrl/$bookSlug/chapters?apiKey=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // hadithapi.com এর রেসপন্স অনুযায়ী কী (key) চেক করুন
        List chaptersData = data['chapters'];
        return chaptersData
            .map((c) => ChapterModel.fromJson(c, bookSlug))
            .toList();
      }
      return [];
    } catch (e) {
      print("Error fetching chapters: $e");
      return [];
    }
  }
}
