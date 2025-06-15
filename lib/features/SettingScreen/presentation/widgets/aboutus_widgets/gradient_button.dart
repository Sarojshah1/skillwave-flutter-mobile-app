import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;

  const GradientButton(this.label, {super.key, this.background = Colors.white, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
      ),
      onPressed: () {},
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}