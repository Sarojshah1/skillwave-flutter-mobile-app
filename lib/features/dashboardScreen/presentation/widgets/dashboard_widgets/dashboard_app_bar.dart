import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Dashboard',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: SkillWaveAppColors.textPrimary,
        ),
      ),
      backgroundColor: SkillWaveAppColors.surface,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Implement notifications
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: SkillWaveAppColors.textSecondary,
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: Implement profile
          },
          icon: const Icon(
            Icons.person_outline,
            color: SkillWaveAppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
