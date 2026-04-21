import 'package:hadith_ai/model/hadith_model.dart';
import 'package:share_plus/share_plus.dart';

void shareHadith(HadithModel hadith) {
  // শেয়ার করার জন্য টেক্সটটি সুন্দর করে সাজানো হচ্ছে
  final String shareText =
      '''
📜 *${hadith.bookName}*
Hadith# : ${hadith.hadithNumber}
Hadith Grade: ${hadith.grade}


${hadith.arabicText}


${hadith.translation}

📖 Chapter: ${hadith.chapterName}
---
Share via Hadith AI App
''';

  Share.share(shareText, subject: 'Hadith Share: ${hadith.bookName}');
}
