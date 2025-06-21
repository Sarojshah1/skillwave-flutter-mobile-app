import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_hero_image.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_title_section.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_instructor_section.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_description_section.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_stats_section.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_action_section.dart';

class CourseCard extends StatefulWidget {
  final CourseEntity course;
  final VoidCallback onEnroll;

  const CourseCard({Key? key, required this.course, required this.onEnroll})
    : super(key: key);

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> with TickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() {
      isHovered = hovering;
    });
    if (hovering) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onEnroll,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: SkillWaveAppColors.shadow.withOpacity(
                        0.1 + (_shadowAnimation.value * 0.1),
                      ),
                      blurRadius: 20.r + (_shadowAnimation.value * 10),
                      offset: Offset(0, 8.h + (_shadowAnimation.value * 4)),
                      spreadRadius: _shadowAnimation.value * 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: SkillWaveAppColors.backgroundGradient_2,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CourseHeroImage(course: widget.course),
                        Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CourseTitleSection(course: widget.course),
                              CourseInstructorSection(course: widget.course),
                              CourseDescriptionSection(course: widget.course),
                              CourseStatsSection(course: widget.course),
                              SizedBox(height: 20.h),
                              CourseActionSection(
                                course: widget.course,
                                onEnroll: widget.onEnroll,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
