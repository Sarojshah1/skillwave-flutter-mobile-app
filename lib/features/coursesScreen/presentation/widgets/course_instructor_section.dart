import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/extensions/text_theme_extension.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';

class CourseInstructorSection extends StatelessWidget {
  final CourseEntity course;

  const CourseInstructorSection({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                gradient: SkillWaveAppColors.purplePinkGradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  course.createdBy.name.isNotEmpty
                      ? course.createdBy.name[0].toUpperCase()
                      : 'I',
                  style: textTheme.labelMedium?.copyWith(
                    color: SkillWaveAppColors.textInverse,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructor',
                    style: textTheme.labelSmall?.copyWith(
                      color: SkillWaveAppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    course.createdBy.name,
                    style: textTheme.bodyMedium?.copyWith(
                      color: SkillWaveAppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
