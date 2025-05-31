import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MissionVisionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Gradient iconGradient;
  final Gradient backgroundGradient;
  final String description;
  final List<String> tags;
  final Color tagBackgroundColor;
  final Color tagTextColor;
  final Gradient underlineGradient;

  const MissionVisionCard({
    required this.title,
    required this.icon,
    required this.iconGradient,
    required this.backgroundGradient,
    required this.description,
    required this.tags,
    required this.tagBackgroundColor,
    required this.tagTextColor,
    required this.underlineGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: backgroundGradient,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],

          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: iconGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 6),
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: underlineGradient,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(description, style: const TextStyle(fontSize: 18, color: Colors.black87, height: 1.4)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: tags
                    .map(
                      (tag) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: BoxDecoration(
                      color: tagBackgroundColor,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Text(tag, style: TextStyle(color: tagTextColor, fontWeight: FontWeight.w600)),
                  ),
                )
                    .toList(),
              )
            ],
          ),
        ),
      ],
    ).animate().scale(delay: 200.ms, duration: 600.ms);
  }
}