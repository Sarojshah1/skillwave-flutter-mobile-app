import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class CreatePostFab extends StatelessWidget {
  const CreatePostFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // TODO: Navigate to create post screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Create post functionality coming soon!'),
            backgroundColor: SkillWaveAppColors.primary,
          ),
        );
      },
      backgroundColor: SkillWaveAppColors.primary,
      foregroundColor: SkillWaveAppColors.textInverse,
      child: const Icon(Icons.add),
    );
  }
}
