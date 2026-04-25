import 'package:flutter/material.dart';
import 'package:hadith_ai/n8n_services/hadith_service_n8n.dart';

class HadithDetailScreen extends StatefulWidget {
  final String categoryName;
  final bool isDark;

  const HadithDetailScreen({super.key, required this.categoryName, required this.isDark});

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  // data list and loading status
  List<Map<String, String>> _hadithList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // logic call
  Future<void> _loadData() async {
    final data = await HadithServiceN8n.fetchHadithExplanation(widget.categoryName);
    if (mounted) {
      setState(() {

        _hadithList = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color goldColor = const Color(0xFFFFD700);
    final Color scaffoldBg = widget.isDark ? const Color(0xFF021B19) : Colors.white;
    final Color cardBg = widget.isDark ? const Color(0xFF03221F) : const Color(0xFFF5F5F5);
    final Color textColor = widget.isDark ? Colors.white : Colors.black87;
    final Color borderCol = widget.isDark ? goldColor.withOpacity(0.4) : Colors.black87.withOpacity(0.2);

    double width = MediaQuery.of(context).size.width;
    bool isWeb = width > 800;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: widget.isDark ? goldColor : Colors.black87, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    widget.categoryName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.isDark ? goldColor : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator(color: goldColor)) // লোডিং ইন্ডিকেটর
                    : _hadithList.isEmpty
                    ? Center(child: Text("Didn't Found Data", style: TextStyle(color: textColor)))
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _hadithList.length,
                  itemBuilder: (context, index) {
                    return _buildHadithCard(
                      _hadithList[index]['text']!,
                      _hadithList[index]['reference']!,
                      cardBg,
                      textColor,
                      borderCol,
                      goldColor,
                      isWeb,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHadithCard(String text, String ref, Color bg, Color textC, Color bColor, Color gold, bool isWeb) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(isWeb ? 30 : 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: bColor, width: 1.5),
        boxShadow: [
          if (!widget.isDark) BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote_rounded, color: gold.withOpacity(0.5), size: 30),
          Text(
            text,
            style: TextStyle(
              color: textC,
              fontSize: isWeb ? 20 : 16,
              height: 1.6,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 0.5, color: Colors.grey),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ref,
                  style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Row(
                children: [
                  _actionButton(Icons.copy_rounded, widget.isDark),
                  const SizedBox(width: 10),
                  _actionButton(Icons.share_rounded, widget.isDark),
                  const SizedBox(width: 10),
                  _actionButton(Icons.bookmark_border_rounded, widget.isDark),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
      ),
      child: Icon(icon, size: 18, color: isDark ? Colors.white60 : Colors.black54),
    );
  }
}