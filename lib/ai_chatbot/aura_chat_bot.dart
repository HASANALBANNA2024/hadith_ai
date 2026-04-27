import 'package:flutter/material.dart';

class AuraChatBot extends StatefulWidget {
  final Widget child;
  // External flag to control visibility during API/n8n service calls
  final bool isServiceReady;

  const AuraChatBot({
    super.key,
    required this.child,
    this.isServiceReady = true, // Default to true to maintain current behavior
  });

  @override
  State<AuraChatBot> createState() => _AuraChatBotState();
}

class _AuraChatBotState extends State<AuraChatBot> {
  bool isExpanded = false;
  bool isFullScreen = false;
  bool showBubble = false;

  // Position ratios
  double xRatio = 0.92;
  double yRatio = 0.82;

  @override
  void initState() {
    super.initState();
    // Delay of 5 seconds to avoid showing during initial splash
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          showBubble = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If the external service (n8n/API) is not ready, return only the child
    if (!widget.isServiceReady) {
      return widget.child;
    }

    // brightness check
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isActuallyDark = brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: Stack(
          children: [
            // 1. Main App Content
            widget.child,

            // 2. Control Layer (Overlay handles Draggable errors)
            if (showBubble)
              Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (overlayContext) => LayoutBuilder(
                      builder: (context, constraints) {
                        final size = Size(
                          constraints.maxWidth,
                          constraints.maxHeight,
                        );
                        final bool isDarkMode =
                            Theme.of(context).brightness == Brightness.dark;
                        final bool isDesktop = size.width > 900;

                        return Stack(
                          children: [
                            // Messenger Bubble
                            if (!isExpanded)
                              _buildMessengerBubble(size, isDarkMode),

                            // Chat Window
                            if (isExpanded)
                              _buildChatWindow(size, isDarkMode, isDesktop),
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

  // --- Messenger Style Bubble ---
  Widget _buildMessengerBubble(Size size, bool isDark) {
    double left = xRatio * size.width;
    double top = yRatio * size.height;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      left: left.clamp(10, size.width - 70),
      top: top.clamp(50, size.height - 150),
      child: Draggable(
        feedback: _bubbleUI(isDark, true),
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
          child: _bubbleUI(isDark, true),
        ),
      ),
    );
  }

  Widget _bubbleUI(bool isActuallyDark, bool dragging) {
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
                  color: isActuallyDark
                      ? Colors.black
                      : Colors.white.withOpacity(0.8),
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
              ),
              boxShadow: [
                BoxShadow(
                  color: isActuallyDark ? Colors.black54 : Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  // --- Responsive Chat Window ---
  Widget _buildChatWindow(Size size, bool isDark, bool isDesktop) {
    bool useFullScreen = (isDesktop && isFullScreen) || !isDesktop;

    double width = useFullScreen ? size.width : 420;
    double height = useFullScreen ? size.height : 650;

    return Positioned(
      bottom: useFullScreen ? 0 : 90,
      right: useFullScreen ? 0 : 25,
      child: Material(
        elevation: 20,
        borderRadius: BorderRadius.circular(useFullScreen ? 0 : 25),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(useFullScreen ? 0 : 25),
            border: Border.all(color: Colors.white10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(useFullScreen ? 0 : 25),
            child: Column(
              children: [
                _buildHeader(isDesktop, useFullScreen),
                Expanded(
                  child: Container(
                    color: isDark ? const Color(0xFF121212) : Colors.grey[50],
                    child: Center(
                      child: Icon(
                        Icons.auto_awesome,
                        size: 80,
                        color: isDark ? Colors.white10 : Colors.black12,
                      ),
                    ),
                  ),
                ),
                _buildInput(isDark, useFullScreen),
              ],
            ),
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
          const Icon(Icons.bolt, color: Colors.cyanAccent, size: 20),
          const SizedBox(width: 10),
          const Text(
            "Aura AI",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (isDesktop)
            IconButton(
              icon: Icon(
                isFull ? Icons.fullscreen_exit : Icons.fullscreen,
                color: Colors.white70,
                size: 22,
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
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: isFull ? 25 : 10,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              onSubmitted: (value) {
                // Here you will trigger your n8n service call
                debugPrint("Triggering n8n service with: $value");
              },
              decoration: InputDecoration(
                hintText: "Aa",
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blueAccent),
            onPressed: () {
              // Trigger n8n service call here as well
            },
          ),
        ],
      ),
    );
  }
}
