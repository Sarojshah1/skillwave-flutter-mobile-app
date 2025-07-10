import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/extensions/text_theme_extension.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';

class CourseDescriptionSection extends StatefulWidget {
  final CourseEntity course;

  const CourseDescriptionSection({super.key, required this.course});

  @override
  State<CourseDescriptionSection> createState() =>
      _CourseDescriptionSectionState();
}

class _CourseDescriptionSectionState extends State<CourseDescriptionSection> {
  bool isReadMore = false;

  void toggleReadMore() {
    setState(() {
      isReadMore = !isReadMore;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isReadMore
                  ? widget.course.description
                  : (widget.course.description.length > 100
                        ? '${widget.course.description.substring(0, 100)}...'
                        : widget.course.description),
              style: textTheme.bodyMedium?.copyWith(
                color: SkillWaveAppColors.textSecondary,
                height: 1.5,
                fontSize: 14.sp,
              ),
              maxLines: isReadMore ? null : 3,
              overflow: TextOverflow.fade,
            ),
          ),
        ),

        if (widget.course.description.length > 100)
          GestureDetector(
            onTap: toggleReadMore,
            child: Container(
              margin: EdgeInsets.only(top: 8.h),
              child: Text(
                isReadMore ? 'Read Less' : 'Read More',
                style: textTheme.bodyMedium?.copyWith(
                  color: SkillWaveAppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),

        SizedBox(height: 20.h),
      ],
    );
  }
}
