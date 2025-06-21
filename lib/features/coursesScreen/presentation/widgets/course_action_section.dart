import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/extensions/text_theme_extension.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';

class CourseActionSection extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback onEnroll;

  const CourseActionSection({
    Key? key,
    required this.course,
    required this.onEnroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price',
              style: textTheme.labelSmall?.copyWith(
                color: SkillWaveAppColors.textSecondary,
                fontSize: 12.sp,
              ),
            ),
            Text(
              'NPR ${course.price}',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: SkillWaveAppColors.primary,
                fontSize: 24.sp,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            gradient: SkillWaveAppColors.blueGradient,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: SkillWaveAppColors.primary.withOpacity(0.3),
                blurRadius: 12.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onEnroll,
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school,
                  color: SkillWaveAppColors.textInverse,
                  size: 18.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Enroll Now',
                  style: textTheme.button?.copyWith(
                    color: SkillWaveAppColors.textInverse,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
