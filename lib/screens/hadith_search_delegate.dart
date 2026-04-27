import 'package:flutter/material.dart';

class HadithSearchDelegate extends SearchDelegate {
  final bool isDark;

  HadithSearchDelegate({required this.isDark});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) => null;

  @override
  List<Widget>? buildActions(BuildContext context) => null;

  @override
  Widget buildResults(BuildContext context) => _buildBody(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildBody(context);

  //  UI logic
  Widget _buildBody(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF1F3F4);
    final barColor = isDark ? const Color(0xFF202124) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // This is ONLY search bar, aligned to 1100px
          Container(
            color: barColor,
            // Adjusting height for status bar + custom bar height
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Center(
              child: Container(
                height: 60,
                constraints: const BoxConstraints(maxWidth: 1100),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      onPressed: () => close(context, null),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: query)
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: query.length),
                          ),
                        onChanged: (value) => query = value,
                        autofocus: true,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Search Hadith...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    if (query.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        onPressed: () => query = '',
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Result/Content Area
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: query.isEmpty ? _buildEmptyState() : _buildSearchList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchList() {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) => _buildHadithCard(index + 1, cardColor),
    );
  }

  // dummy information
  Widget _buildHadithCard(int number, Color cardColor) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sahih Bukhari",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "#$number",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              "الْأَعْمَالُ بِالنِّيَّاتِ",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              "Actions are judged by intentions...",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.manage_search,
            size: 80,
            color: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 10),
          const Text(
            "Search for Hadith by keyword",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
