import 'package:share_plus/share_plus.dart';

class AppShare {
  // Static method ব্যবহারের ফলে সরাসরি AppShare.share() কল করা যাবে
  static void share() {
    const String appName = "Hadith AI 🌙";
    const String appLink =
        "https://play.google.com/store/apps/details?id=your.package.name";

    const String shareContent =
        "✨ Assalamu Alaikum ✨\n\n"
        "I'm using the '$appName' app and it's truly amazing! It helps in gaining authentic Hadith and Islamic knowledge using AI technology.\n\n"
        "📍 Key Features:\n"
        "✅ Authentic Hadith Verification\n"
        "✅ AI-Powered Islamic Guidance\n"
        "✅ Subject-Wise Categorization\n\n"
        "Download now and increase your Deen knowledge: 👇\n"
        "🔗 $appLink\n\n"
        "Jazakallahu Khairan. 🤲";

    Share.share(shareContent, subject: "Explore $appName App");
  }
}
