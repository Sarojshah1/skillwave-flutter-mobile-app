import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/features/my-learnings/domain/entity/enrollment_entity.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';

class EnrolledCourseCard extends StatelessWidget {
  final EnrollmentEntity enrollment;
  final VoidCallback? onTap;

  const EnrolledCourseCard({super.key, required this.enrollment, this.onTap});

  @override
  Widget build(BuildContext context) {
    final course = enrollment.course;
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: SkillWaveAppColors.backgroundGradient_2,
          boxShadow: [
            BoxShadow(
              color: SkillWaveAppColors.shadow.withOpacity(0.10),
              blurRadius: 18.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero image with gradient overlay
              if (course.thumbnail.isNotEmpty)
                Stack(
                  children: [
                    Hero(
                      tag: 'course-thumb-${course.id}',
                      child: Container(
                        height: 140.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              "${ApiEndpoints.baseUrlForImage}/thumbnails/${course.thumbnail}",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.25),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    // Category/Level badge
                    Positioned(
                      top: 12.h,
                      left: 16.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: SkillWaveAppColors.primary.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          course.level,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      course.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: SkillWaveAppColors.textPrimary,
                        fontSize: 18.sp,
                        shadows: [
                          Shadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16.sp,
                          color: SkillWaveAppColors.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          dateFormat.format(enrollment.enrollmentDate),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: SkillWaveAppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    // Progress and Status Row
                    Row(
                      children: [
                        // Circular progress
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 38.w,
                              height: 38.w,
                              child: CircularProgressIndicator(
                                value: enrollment.progress / 100.0,
                                backgroundColor: SkillWaveAppColors.surface,
                                color: SkillWaveAppColors.primary,
                                strokeWidth: 5,
                              ),
                            ),
                            Text(
                              '${enrollment.progress}%',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: SkillWaveAppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16.w),
                        // Status badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: SkillWaveAppColors.primary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            enrollment.status,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: SkillWaveAppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Spacer(),
                        // Action button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SkillWaveAppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 8.h,
                            ),
                          ),
                          onPressed: () {
                            context.router.push(
                              LessonsListRoute(courseId: enrollment.course.id),
                            );
                          },
                          child: Text(
                            'Continue',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
