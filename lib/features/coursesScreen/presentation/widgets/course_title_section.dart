import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/extensions/text_theme_extension.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';

class CourseTitleSection extends StatelessWidget {
  final CourseEntity course;

  const CourseTitleSection({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.title,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: SkillWaveAppColors.textPrimary,
            fontSize: 20.sp,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
