import 'package:http/http.dart' as http;
import 'dart:convert';

class HadithServiceN8n {
  // n8n webhook url
  static const String _baseUrl = "http://localhost:5678/webhook/get_hadith";

  static Future<List<Map<String, String>>> fetchHadithExplanation(String subject) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"subject": subject},
      ).timeout(const Duration(seconds: 10)); // timeout

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        final data = jsonDecode(response.body);

        // n8n sending (Key) 'hadith_data'
        String content = data['hadith_data'] ?? "sorry to not found in data";

        return [
          {
            "text": content,
            "reference": "AI Generated"
          }
        ];
      } else {
       print("Server Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Connection Error: $e");
      return [];
    }
  }
}