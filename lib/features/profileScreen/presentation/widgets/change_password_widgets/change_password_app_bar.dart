import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class ChangePasswordAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChangePasswordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Change Password'),
      backgroundColor: SkillWaveAppColors.primary,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
