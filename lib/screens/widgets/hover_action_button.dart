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
            ? const Color.fromARGB(255, 0, 145, 255)
            : const Color.fromARGB(255, 252, 253, 254),
        elevation: _isHovered ? 4 : 0,
        padding: const EdgeInsets.all(12),
        shape: const CircleBorder(),
        minimumSize: const Size(48, 48),
      ),
      child: Icon(widget.icon, size: 20, color: Colors.black),
    );
  }
}
