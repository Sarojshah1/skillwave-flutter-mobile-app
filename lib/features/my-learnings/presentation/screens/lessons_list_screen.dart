import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/my-learnings/presentation/bloc/lessons_bloc/lessons_bloc.dart';
import 'package:skillwave/features/my-learnings/presentation/bloc/lessons_bloc/lessons_state.dart';
import 'package:skillwave/features/my-learnings/presentation/bloc/lessons_bloc/lessons_event.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/my-learnings/presentation/screens/content_page.dart';

@RoutePage()
class LessonsListScreen extends StatefulWidget {
  final String courseId;
  const LessonsListScreen({super.key, required this.courseId});

  @override
  State<LessonsListScreen> createState() => _LessonsListScreenState();
}

class _LessonsListScreenState extends State<LessonsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LessonsBloc>().add(FetchLessonsEvent(widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final text = theme.textTheme;
    return Scaffold(
      backgroundColor: SkillWaveAppColors.background,
      appBar: AppBar(
        title: Text(
          'Lessons',
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: BlocBuilder<LessonsBloc, LessonsState>(
          builder: (context, state) {
            if (state is LessonsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LessonsLoaded) {
              if (state.lessons.isEmpty) {
                return Center(
                  child: Text(
                    'No lessons found.',
                    style: text.bodyLarge?.copyWith(color: color.onSurface),
                  ),
                );
              }
              return ListView.separated(
                itemCount: state.lessons.length,
                separatorBuilder: (_, __) => SizedBox(height: 14.h),
                itemBuilder: (context, index) {
                  final lesson = state.lessons[index];
                  return _LessonCard(lesson: lesson, index: index);
                },
              );
            } else if (state is LessonsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: text.bodyLarge?.copyWith(color: color.error),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LessonEntity lesson;
  final int index;
  const _LessonCard({required this.lesson, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: () {
        context.router.push(ContentRoute(lesson: lesson));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => ContentPage(lesson: lesson)),
        // );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        elevation: 6,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: SkillWaveAppColors.primary.withOpacity(0.1),
                child: Text(
                  '${lesson.order}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: SkillWaveAppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: SkillWaveAppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      lesson.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: SkillWaveAppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.play_circle_fill,
                  color: SkillWaveAppColors.primary,
                  size: 32.sp,
                ),
                onPressed: () {
                  context.router.push(ContentRoute(lesson: lesson));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
