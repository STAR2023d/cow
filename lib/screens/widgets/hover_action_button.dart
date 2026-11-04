// lib/widgets/hover_action_button.dart
import 'package:flutter/material.dart';

class HoverActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const HoverActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<HoverActionButton> createState() => _HoverActionButtonState();
}

class _HoverActionButtonState extends State<HoverActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onHover: (hovering) {
        setState(() {
          _isHovered = hovering;
        });
      },
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isHovered
            ? const Color.fromARGB(255, 0, 145, 255) // Bright blue on hover
            : const Color.fromARGB(255, 252, 253, 254), // White by default
        // 1. Visible Tap Animation colors
        foregroundColor: _isHovered
            ? Colors
                  .white30 // Ripple effect color when background is blue
            : Colors.black, // Ripple effect color when background is white

        elevation: _isHovered ? 4 : 0,
        padding: const EdgeInsets.all(12),
        shape: const CircleBorder(),

        // 2. Ensuring explicit, un-clippable constraints for a perfect circle
        minimumSize: const Size(44, 44),
        maximumSize: const Size(44, 44),
      ),
      // 3. Dynamically inversion of icon color on hover for accessibility
      child: Icon(
        widget.icon,
        size: 20,
        color: _isHovered ? Colors.white : Colors.black,
      ),
    );
  }
}
