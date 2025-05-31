import 'package:flutter/material.dart';

class CoreValueCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;

  const CoreValueCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });

  @override
  State<CoreValueCard> createState() => _CoreValueCardState();
}

class _CoreValueCardState extends State<CoreValueCard> with SingleTickerProviderStateMixin {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scale = isHovered ? 1.05 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isHovered ? 0.5 : 1.0),
            borderRadius: BorderRadius.circular(24),
            boxShadow: isHovered
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ]
                : [],
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 16),
              Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
