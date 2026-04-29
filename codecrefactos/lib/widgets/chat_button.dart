import 'package:flutter/material.dart';
import 'package:codecrefactos/widgets/chat_boot.dart';

class ChatFloatingButton extends StatefulWidget {
  const ChatFloatingButton({super.key});

  @override
  State<ChatFloatingButton> createState() => _ChatFloatingButtonState();
}

class _ChatFloatingButtonState extends State<ChatFloatingButton>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  Offset _position = const Offset(300, 600);

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) => _insertOverlay());
  }

  void _insertOverlay() {
    _overlayEntry = OverlayEntry(builder: (_) => _buildOverlayContent());
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updatePosition(Offset newOffset) {
    _position = newOffset;
    _overlayEntry?.markNeedsBuild();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _controller.dispose();
    super.dispose();
  }

  Widget _buildOverlayContent() {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Draggable(
        feedback: _buildButton(),
        childWhenDragging: const SizedBox(),
        onDragEnd: (details) => _updatePosition(details.offset),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => const CustomerServiceChatView(),
              ),
            );
          },
          child: _buildAnimatedButton(),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: const Icon(Icons.support_agent, color: Colors.white, size: 30),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
