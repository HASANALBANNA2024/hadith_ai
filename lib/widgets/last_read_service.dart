import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LastReadService {
  static const String _key = 'last_read_data';

  /// শেষ পড়া হাদিসের তথ্য সেভ করার জন্য
  static Future<void> saveLastRead({
    required String bookName,
    required String bookSlug, // নেভিগেশনের জন্য প্রয়োজন
    required String chapterId, // নেভিগেশনের জন্য প্রয়োজন
    required String hadithNumber,
    required String translation,
    required int hadithId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> data = {
      'bookName': bookName,
      'bookSlug': bookSlug,
      'chapterId': chapterId,
      'hadithNumber': hadithNumber,
      'translation': translation,
      'hadithId': hadithId,
      'time': DateTime.now().toIso8601String(), // স্ট্যান্ডার্ড টাইম ফরম্যাট
    };

    await prefs.setString(_key, jsonEncode(data));
  }

  /// ড্যাশবোর্ডে ডেটা দেখানোর জন্য এবং নেভিগেট করার জন্য
  static Future<Map<String, dynamic>?> getLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? rawData = prefs.getString(_key);

      if (rawData == null) return null;

      return jsonDecode(rawData) as Map<String, dynamic>;
    } catch (e) {
      // কোনো কারণে ডেটা করাপ্টেড হলে নাল রিটার্ন করবে
      return null;
    }
  }

  /// যদি কখনো হিস্ট্রি ক্লিয়ার করার প্রয়োজন হয়
  static Future<void> clearLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
