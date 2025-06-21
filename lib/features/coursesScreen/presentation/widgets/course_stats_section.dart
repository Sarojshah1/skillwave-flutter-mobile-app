import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';

class CourseStatsSection extends StatelessWidget {
  final CourseEntity course;

  const CourseStatsSection({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: SkillWaveAppColors.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: SkillWaveAppColors.border.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.video_library,
            label: '${course.lessons.length}',
            subtitle: 'Lessons',
            color: SkillWaveAppColors.primary,
          ),
          Container(
            width: 1.w,
            height: 40.h,
            color: SkillWaveAppColors.border.withOpacity(0.3),
          ),
          _buildStatItem(
            icon: Icons.star,
            label: '4.8',
            subtitle: 'Rating',
            color: SkillWaveAppColors.accent,
          ),
          Container(
            width: 1.w,
            height: 40.h,
            color: SkillWaveAppColors.border.withOpacity(0.3),
          ),
          _buildStatItem(
            icon: Icons.people,
            label: '1.2k',
            subtitle: 'Students',
            color: SkillWaveAppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: color, size: 20.r),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: SkillWaveAppColors.textPrimary,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12.sp,
            color: SkillWaveAppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
