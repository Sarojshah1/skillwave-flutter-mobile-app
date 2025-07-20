import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/themes/%20theme/dark_theme.dart';
import 'package:skillwave/config/themes/%20theme/light_theme.dart';
import 'package:skillwave/features/SettingScreen/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/blogScreen/presentation/bloc/blog_bloc.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/course_bloc.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/payment_bloc.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/realtime_comment_bloc.dart';
import 'package:skillwave/features/my-learnings/presentation/bloc/learning_bloc.dart';
import 'package:skillwave/features/my-learnings/presentation/bloc/lessons_bloc/lessons_bloc.dart';
import 'package:skillwave/features/study_groups/presentation/view_model/group_chat_bloc.dart';
import 'package:skillwave/features/study_groups/presentation/view_model/group_study_bloc.dart';
import 'config/di/di.container.dart';
import 'config/routes/app_router.dart';
import 'config/themes/theme_bloc/theme_bloc.dart';
import 'cores/services/snackbar_service.dart';
import 'features/profileScreen/presentation/bloc/profile_bloc.dart';
import 'features/profileScreen/presentation/bloc/update_profile_bloc/update_profile_bloc.dart';
import 'features/profileScreen/presentation/bloc/change_password_bloc/change_password_bloc.dart';
import 'features/welcomescreens/presentation/bloc/splashBloc/splash_bloc.dart';
import 'features/dashboardScreen/presentation/bloc/get_posts_bloc/get_posts_bloc.dart';
import 'features/dashboardScreen/presentation/bloc/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import 'features/dashboardScreen/presentation/bloc/create_post_bloc/create_post_bloc.dart';
import 'features/dashboardScreen/presentation/bloc/update_post_bloc/update_post_bloc.dart';
import 'features/dashboardScreen/presentation/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'features/dashboardScreen/presentation/bloc/like_post_bloc/like_post_bloc.dart';
import 'features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_bloc.dart';
import 'features/dashboardScreen/presentation/bloc/create_reply_bloc/create_reply_bloc.dart';
import 'features/dashboardScreen/presentation/providers/comment_provider.dart';
import 'cores/network/network_aware_app.dart';

class SkillWaveApp extends StatelessWidget {
  final AppRouter appRouter;
  const SkillWaveApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    final snackbarService = getIt<SnackbarService>();
    final navKey = getIt<GlobalKey<NavigatorState>>();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (_, child) {
        final pixelRatio = MediaQuery.of(context).devicePixelRatio;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<ThemeBloc>()..add(LoadTheme()),
              lazy: false,
            ),
            BlocProvider<SplashBloc>(
              create: (_) => getIt<SplashBloc>()..add(CheckAppStatusEvent()),
            ),
            BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
            BlocProvider<LogoutBloc>(create: (_) => getIt<LogoutBloc>()),
            BlocProvider<ProfileBloc>(create: (_) => getIt<ProfileBloc>()),
            BlocProvider<UpdateProfileBloc>(
              create: (_) => getIt<UpdateProfileBloc>(),
            ),
            BlocProvider<ChangePasswordBloc>(
              create: (_) => getIt<ChangePasswordBloc>(),
            ),
            BlocProvider<BlogBloc>(create: (_) => getIt<BlogBloc>()),
            BlocProvider<CourseBloc>(create: (_) => getIt<CourseBloc>()),
            BlocProvider<ReviewBloc>(create: (_) => getIt<ReviewBloc>()),
            BlocProvider<PaymentBloc>(create: (_) => getIt<PaymentBloc>()),
            BlocProvider<GetPostsBloc>(create: (_) => getIt<GetPostsBloc>()),
            BlocProvider<GetPostByIdBloc>(
              create: (_) => getIt<GetPostByIdBloc>(),
            ),
            BlocProvider<CreatePostBloc>(
              create: (_) => getIt<CreatePostBloc>(),
            ),
            BlocProvider<UpdatePostBloc>(
              create: (_) => getIt<UpdatePostBloc>(),
            ),
            BlocProvider<DeletePostBloc>(
              create: (_) => getIt<DeletePostBloc>(),
            ),
            BlocProvider<LikePostBloc>(create: (_) => getIt<LikePostBloc>()),
            BlocProvider<CreateCommentBloc>(
              create: (_) => getIt<CreateCommentBloc>(),
            ),
            BlocProvider<CreateReplyBloc>(
              create: (_) => getIt<CreateReplyBloc>(),
            ),
            BlocProvider<RealtimeCommentBloc>(
              create: (_) => getIt<RealtimeCommentBloc>(),
            ),
            ChangeNotifierProvider<CommentProvider>(
              create: (_) => CommentProvider(),
            ),
             BlocProvider<LearningBloc>(
              create: (_) => getIt<LearningBloc>(),
            ),
            BlocProvider<LessonsBloc>(
              create: (_) => getIt<LessonsBloc>(),
            ),
            BlocProvider<GroupStudyBloc>(
              create: (_) => getIt<GroupStudyBloc>(),
            ),
            BlocProvider<GroupChatBloc>(
              create: (_) => getIt<GroupChatBloc>(),
            ),
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return NetworkAwareApp(
                routerConfig: appRouter.config(),
                title: 'SkillWave App',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeState.themeMode,
                scaffoldMessengerKey: snackbarService.messengerKey,
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        );
      },
    );
  }
}
