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
    final scheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onHover: (hovering) {
        setState(() {
          _isHovered = hovering;
        });
      },
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        // Tinted circle that reads in light and dark mode; stronger on
        // hover (desktop) and the ripple shows the press on a phone.
        backgroundColor: _isHovered ? scheme.primary : scheme.primaryContainer,
        foregroundColor: _isHovered
            ? scheme.onPrimary
            : scheme.onPrimaryContainer,
        elevation: _isHovered ? 4 : 0,
        padding: const EdgeInsets.all(12),
        shape: const CircleBorder(),
        minimumSize: const Size(48, 48),
        maximumSize: const Size(48, 48),
      ),
      child: Icon(widget.icon, size: 22),
    );
  }
}
