import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020404), // Midnight Black (সবচেয়ে ফ্রেশ ডার্ক)
      floatingActionButton: _buildSoulfulBot(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 950), // Web View 950px
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSimpleAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildMinimalGreeting(),
                      const SizedBox(height: 50),

                      // Siha Sitta - Pure Clean Cards
                      _buildSectionLabel("THE SIHA SITTA"),
                      const SizedBox(height: 25),
                      _buildSihaSittaGrid(context),

                      const SizedBox(height: 50),

                      // Explore Section
                      _buildSectionLabel("BEYOND SIX BOOKS"),
                      const SizedBox(height: 20),
                      _buildExploreHorizontal(),

                      const SizedBox(height: 60),
                      _buildAppTrustInfo(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFF020404),
      elevation: 0,
      pinned: true,
      centerTitle: false,
      title: const Text("Hadith AI",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 24, letterSpacing: 1)),
      actions: [
        IconButton(icon: const Icon(Icons.blur_on, color: Color(0xFF00C853)), onPressed: () {}),
      ],
    );
  }

  Widget _buildMinimalGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Peace be with you,", style: TextStyle(color: Colors.white38, fontSize: 18)),
        SizedBox(height: 8),
        Text("Find your guidance.", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w200)),
      ],
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(title, style: const TextStyle(color: Color(0xFFFFD700), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3));
  }

  // Siha Sitta Grid - No Box, Pure Clean UI
  Widget _buildSihaSittaGrid(BuildContext context) {
    final List<String> books = ["Bukhari", "Muslim", "Nasa'i", "Abu Dawood", "Tirmidhi", "Ibn Majah"];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        mainAxisSpacing: 30, crossAxisSpacing: 30, childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0C0C),
            borderRadius: BorderRadius.circular(40), // একদম গোলগাল ফ্রেশ লুক
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${index + 1}", style: TextStyle(color: Colors.white.withOpacity(0.05), fontSize: 40, fontWeight: FontWeight.w900)),
              Text(books[index], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExploreHorizontal() {
    final others = ["Muwatta Malik", "Riyadus Salihin", "40 Hadith", "Bulugh Al-Maram"];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: others.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white10),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(child: Text(others[index], style: const TextStyle(color: Colors.white70))),
          );
        },
      ),
    );
  }

  Widget _buildAppTrustInfo() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.verified_user_outlined, color: Color(0xFF00C853), size: 30),
          const SizedBox(height: 15),
          Text("Authenticated Sources Only", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSoulfulBot() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text("HADITH AI", style: TextStyle(color: Color(0xFFFFD700), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFF00C853), Color(0xFF004D40)]),
              boxShadow: [BoxShadow(color: const Color(0xFF00C853).withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
            ),
            child: const Icon(Icons.bubble_chart_outlined, color: Colors.white, size: 35),
          ),
        ),
      ],
    );
  }
}