import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';

class DashboardSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const DashboardSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search posts...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: SkillWaveAppColors.textDisabled,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: SkillWaveAppColors.textSecondary,
          ),
          suffixIcon: IconButton(
            onPressed: onSearch,
            icon: const Icon(
              Icons.filter_list,
              color: SkillWaveAppColors.textSecondary,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: SkillWaveAppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: SkillWaveAppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: SkillWaveAppColors.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: SkillWaveAppColors.surface,
        ),
        onSubmitted: (_) => onSearch(),
      ),
    );
  }
}
