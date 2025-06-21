import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class CourseTabNavigation extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChanged;
  final VoidCallback? onReviewsTabSelected;

  const CourseTabNavigation({
    Key? key,
    required this.activeTab,
    required this.onTabChanged,
    this.onReviewsTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(child: _buildTabButton('Overview')),
            Expanded(child: _buildTabButton('Description')),
            Expanded(child: _buildTabButton('Reviews')),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label) {
    final isActive = activeTab == label.toLowerCase();

    return GestureDetector(
      onTap: () {
        onTabChanged(label.toLowerCase());
        if (label.toLowerCase() == 'reviews' && onReviewsTabSelected != null) {
          onReviewsTabSelected!();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? SkillWaveAppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
