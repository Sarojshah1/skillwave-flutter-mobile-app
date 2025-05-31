import 'package:flutter/material.dart';

class SocialIconButton extends StatefulWidget {
  final IconData icon;

  const SocialIconButton({required this.icon});

  @override
  State<SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<SocialIconButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) => setState(() => _hovered = false),
      onTapCancel: () => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Icon(
          widget.icon,
          size: 24,
          color: Colors.purple[700],
        ),
      ),
    );
  }
}