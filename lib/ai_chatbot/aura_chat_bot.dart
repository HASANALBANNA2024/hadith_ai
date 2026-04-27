import 'package:flutter/material.dart';
import 'package:hadith_ai/screens/payment_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hadith_ai/widgets/aura_initial_messages.dart';
import 'package:hadith_ai/main.dart';

class AuraChatBot extends StatefulWidget {
  final Widget child;
  final bool isServiceReady;

  const AuraChatBot({
    super.key,
    required this.child,
    this.isServiceReady = true,
  });

  @override
  State<AuraChatBot> createState() => _AuraChatBotState();
}

class _AuraChatBotState extends State<AuraChatBot> {
  bool isExpanded = false;
  bool isFullScreen = false;
  bool showBubble = false;

  // মেসেজ হোল্ড করার লিস্ট
  final List<Map<String, dynamic>> _messages = [];

  // পজিশন রেশিও
  double xRatio = 0.92;
  double yRatio = 0.82;

  @override
  void initState() {
    super.initState();
    // ৫ সেকেন্ড পর বাবল এবং ইনিশিয়াল মেসেজ লোড হবে
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _initializeWelcomeMessages();
        setState(() {
          showBubble = true;
        });
      }
    });
  }

  void _initializeWelcomeMessages() {
    var box = Hive.box('app_cache');

    // আমরা 'hasOpenedBefore' কী (Key) ব্যবহার করছি
    bool hasOpenedBefore = box.get('hasOpenedBefore', defaultValue: false);

    setState(() {
      _messages.clear(); // আগের মেসেজ ক্লিয়ার করে নেওয়া নিরাপদ

      if (!hasOpenedBefore) {
        // প্রথমবার ওপেন করলে: হাদিস + পরিচয় + ডোনেশন
        _messages.addAll(AuraInitialMessages.getFirstTimeMessage());
        // প্রথমবার ওপেন হয়ে গেছে, তাই true সেভ করে রাখছি
        box.put('hasOpenedBefore', true);
      } else {
        // দ্বিতীয়বার বা তারপরের বার: শুধু ডোনেশন মেসেজ
        _messages.addAll(AuraInitialMessages.getReturningMessages());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isServiceReady) return widget.child;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: Stack(
          children: [
            widget.child,
            if (showBubble)
              Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (overlayContext) => LayoutBuilder(
                      builder: (context, constraints) {
                        final size = Size(constraints.maxWidth, constraints.maxHeight);
                        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
                        final bool isDesktop = size.width > 900;

                        return Stack(
                          children: [
                            if (!isExpanded) _buildMessengerBubble(size, isDarkMode),
                            if (isExpanded) _buildChatWindow(size, isDarkMode, isDesktop),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessengerBubble(Size size, bool isDark) {
    double left = xRatio * size.width;
    double top = yRatio * size.height;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      left: left.clamp(10, size.width - 70),
      top: top.clamp(50, size.height - 150),
      child: Draggable(
        feedback: _bubbleIconUI(isDark),
        childWhenDragging: const SizedBox.shrink(),
        onDragEnd: (details) {
          setState(() {
            double newX = details.offset.dx / size.width;
            xRatio = newX < 0.5 ? 0.05 : 0.92;
            yRatio = (details.offset.dy / size.height).clamp(0.1, 0.85);
          });
        },
        child: GestureDetector(
          onTap: () => setState(() => isExpanded = true),
          child: _bubbleIconUI(isDark),
        ),
      ),
    );
  }

  Widget _bubbleIconUI(bool isActuallyDark) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Aura AI",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Colors.redAccent,
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: isActuallyDark ? Colors.black : Colors.white.withOpacity(0.8),
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
              ),
            ),
            child: const Icon(Icons.psychology_outlined, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildChatWindow(Size size, bool isDark, bool isDesktop) {
    bool useFullScreen = (isDesktop && isFullScreen) || !isDesktop;
    double windowWidth = useFullScreen ? size.width : 400;
    double windowHeight = useFullScreen ? size.height : 550;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: useFullScreen ? 0 : 20,
      right: useFullScreen ? 0 : 20,
      child: Material(
        elevation: 20,
        borderRadius: BorderRadius.circular(useFullScreen ? 0 : 16),
        child: Container(
          width: windowWidth,
          height: windowHeight,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(useFullScreen ? 0 : 16),
            border: Border.all(color: isDark ? Colors.white10 : Colors.black12, width: 0.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(useFullScreen ? 0 : 16),
            child: Column(
              children: [
                _buildHeader(isDesktop, useFullScreen),
                Expanded(
                  child: Container(
                    color: isDark ? const Color(0xFF121212) : Colors.grey[50],
                    child: _messages.isEmpty
                        ? Center(
                      child: Icon(
                        Icons.auto_awesome,
                        size: 60,
                        color: isDark ? Colors.white10 : Colors.black12,
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        if (msg['type'] == 'hadith' || msg['type'] == 'text' || msg['type'] == 'donation') {
                          if (msg['type'] == 'donation') {
                            return Center(
                              child: DonationMessageCard(
                                text: msg['content'],
                                onDonatePressed: () {
                                  setState(() {
                                    isExpanded = false;
                                  });
                                  navigatorKey.currentState?.push(
                                    MaterialPageRoute(builder: (context) => const PaymentScreen()),
                                  );
                                },
                              ),
                            );
                          }


                          return Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                              ),
                              child: Text(
                                msg['content'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black87,
                                  fontSize: 14,
                                  fontStyle: msg['type'] == 'hadith' ? FontStyle.italic : FontStyle.normal,
                                ),
                              ),
                            ),
                          );
                        }
                        return _buildChatBubble(
                            msg['content'],
                            isDark,
                            isUser: msg['type'] == 'user'
                        );
                      },
                    )
                  ),
                ),

                // input area
                _buildInput(isDark, useFullScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isDark, {bool isUser = false}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blueAccent
              : (isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE3F2FD)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop, bool isFull) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF202124),
      child: Row(
        children: [
          // বাম পাশে শুধু লোগো এবং নাম
          const Icon(Icons.bolt, color: Colors.cyanAccent, size: 20),
          const SizedBox(width: 10),
          const Text(
              "Aura AI",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          ),

          const Spacer(),


          TextButton(
            onPressed: () {
              // first chatbot windows close
              setState(() {
                isExpanded = false;
              });

              // Payment screen navigate
              navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (context) => const PaymentScreen()),
              );
            },
            child: const Text(
              "Subscription",
              style: TextStyle(
                color: Colors.amberAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          if (isDesktop)
            IconButton(
              icon: Icon(
                  isFull ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white70,
                  size: 22
              ),
              onPressed: () => setState(() => isFullScreen = !isFullScreen),
            ),

          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70, size: 20),
            onPressed: () => setState(() {
              isExpanded = false;
              isFullScreen = false;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(bool isDark, bool isFull) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: isFull ? 25 : 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: "Aa",
                hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send, color: Colors.blueAccent), onPressed: () {

          }),
        ],
      ),
    );
  }
}