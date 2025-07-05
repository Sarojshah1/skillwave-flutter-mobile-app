import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';

class DashboardFilterChips extends StatelessWidget {
  final String selectedCategory;
  final List<String> selectedTags;
  final Function(String) onCategoryChanged;
  final Function(List<String>) onTagsChanged;

  const DashboardFilterChips({
    super.key,
    required this.selectedCategory,
    required this.selectedTags,
    required this.onCategoryChanged,
    required this.onTagsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: SkillWaveAppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                    'All',
                    'Technology',
                    'Design',
                    'Business',
                    'Marketing',
                    'Education',
                  ].map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            onCategoryChanged(category);
                          }
                        },
                        backgroundColor: SkillWaveAppColors.lightGreyBackground,
                        selectedColor: SkillWaveAppColors.primary,
                        labelStyle: AppTextStyles.labelMedium.copyWith(
                          color: isSelected
                              ? SkillWaveAppColors.textInverse
                              : SkillWaveAppColors.textSecondary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tags',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: SkillWaveAppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                  'Flutter',
                  'Dart',
                  'Mobile',
                  'Web',
                  'UI/UX',
                  'Backend',
                  'API',
                  'Database',
                ].map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      final newTags = List<String>.from(selectedTags);
                      if (selected) {
                        newTags.add(tag);
                      } else {
                        newTags.remove(tag);
                      }
                      onTagsChanged(newTags);
                    },
                    backgroundColor: SkillWaveAppColors.lightGreyBackground,
                    selectedColor: SkillWaveAppColors.secondary,
                    labelStyle: AppTextStyles.labelMedium.copyWith(
                      color: isSelected
                          ? SkillWaveAppColors.textInverse
                          : SkillWaveAppColors.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
