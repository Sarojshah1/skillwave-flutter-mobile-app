import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class CTAButtons extends StatelessWidget {
  const CTAButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/signup'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: SkillWaveAppColors.background
          ),
          icon: const Icon(Icons.arrow_right_alt),
          label: const Text('Start Learning Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/courses'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            side: BorderSide(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          icon: const Icon(Icons.book_outlined),
          label: const Text('Explore Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        )
      ],
    );
  }
}
