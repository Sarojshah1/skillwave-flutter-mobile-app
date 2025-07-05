import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/routes/app_router.dart';

class CreatePostFab extends StatelessWidget {
  const CreatePostFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.router.push(CreatePostRoute());
      },
      backgroundColor: SkillWaveAppColors.primary,
      foregroundColor: SkillWaveAppColors.textInverse,
      child: const Icon(Icons.add),
    );
  }
}
