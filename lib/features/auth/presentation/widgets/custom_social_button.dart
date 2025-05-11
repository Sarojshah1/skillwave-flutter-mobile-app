import 'package:flutter/material.dart';

class CustomSocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;

  const CustomSocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = Colors.blue,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: size),
      onPressed: onPressed,
    );
  }
}