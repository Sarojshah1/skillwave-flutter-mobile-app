import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/extensions/text_theme_extension.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';

class CourseHeroImage extends StatelessWidget {
  final CourseEntity course;

  const CourseHeroImage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: '${ApiEndpoints.baseUrlForImage}/thumbnails/${course.thumbnail}',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                gradient: SkillWaveAppColors.blueGradient,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: SkillWaveAppColors.textInverse,
                  strokeWidth: 3.w,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                gradient: SkillWaveAppColors.blueGradient,
              ),
              child: Icon(
                Icons.school,
                size: 64.r,
                color: SkillWaveAppColors.textInverse,
              ),
            ),
          ),
        ),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  SkillWaveAppColors.textPrimary.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: 16.h,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: SkillWaveAppColors.secondary,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: SkillWaveAppColors.shadow,
                  blurRadius: 8.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Text(
              course.level.toUpperCase(),
              style: textTheme.labelSmall?.copyWith(
                color: SkillWaveAppColors.textInverse,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),

        Positioned(
          top: 16.h,
          left: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: SkillWaveAppColors.textPrimary.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  color: SkillWaveAppColors.textInverse,
                  size: 16.r,
                ),
                SizedBox(width: 4.w),
                Text(
                  course.duration,
                  style: textTheme.labelSmall?.copyWith(
                    color: SkillWaveAppColors.textInverse,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
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
