import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/features/my-learnings/presentation/bloc/learning_bloc.dart';
import 'package:skillwave/features/my-learnings/presentation/bloc/learning_state.dart';
import 'package:skillwave/features/my-learnings/presentation/bloc/learning_event.dart';
import 'package:skillwave/features/my-learnings/presentation/widgets/enrolled_course_card.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class MyLearningsScreen extends StatefulWidget {
  const MyLearningsScreen({super.key});

  @override
  State<MyLearningsScreen> createState() => _MyLearningsScreenState();
}

class _MyLearningsScreenState extends State<MyLearningsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LearningBloc>().add(FetchLearningEvent());
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
          'My Learnings',
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: BlocBuilder<LearningBloc, LearningState>(
          builder: (context, state) {
            if (state is LearningLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LearningLoaded) {
              if (state.learnings.isEmpty) {
                return Center(
                  child: Text(
                    'No enrolled courses yet.',
                    style: text.bodyLarge?.copyWith(color: color.onSurface),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.learnings.length,
                itemBuilder: (context, index) {
                  final enrollment = state.learnings[index];
                  return EnrolledCourseCard(
                    enrollment: enrollment,
                    onTap: () {
                      // TODO: Navigate to course details or learning progress
                    },
                  );
                },
              );
            } else if (state is LearningFailure) {
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
