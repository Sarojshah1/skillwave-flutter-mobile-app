import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/features/SettingScreen/presentation/screens/settings_view.dart';
// Feature screens
import 'package:skillwave/features/auth/presentation/screens/login_view.dart';
import 'package:skillwave/features/auth/presentation/screens/reset_password_Screen.dart';
import 'package:skillwave/features/auth/presentation/screens/send_otp_screen.dart';
import 'package:skillwave/features/auth/presentation/screens/signup_view.dart';
import 'package:skillwave/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';
import 'package:skillwave/features/blogScreen/presentation/screens/blog_detail_page.dart';
import 'package:skillwave/features/blogScreen/presentation/screens/blogs_screen.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/coursesScreen/presentation/screens/course_detail_page.dart';
import 'package:skillwave/features/coursesScreen/presentation/screens/course_screen.dart';
import 'package:skillwave/features/dashboardScreen/presentation/screens/dashboard_screen.dart';
import 'package:skillwave/features/dashboardScreen/presentation/screens/create_post_screen.dart';
import 'package:skillwave/features/homeScreen/presentation/screens/home_view.dart';
import 'package:skillwave/features/my-learnings/presentation/screens/content_page.dart';
import 'package:skillwave/features/my-learnings/presentation/screens/lessons_list_screen.dart';
import 'package:skillwave/features/profileScreen/presentation/screens/profile_screen.dart';
import 'package:skillwave/features/welcomescreens/presentation/screens/onboarding_Screen.dart';
import 'package:skillwave/features/welcomescreens/presentation/screens/splash_Screen.dart';
import 'package:skillwave/features/profileScreen/presentation/screens/change_password_screen.dart';
import 'package:skillwave/features/profileScreen/presentation/screens/edit_profile_screen.dart';
import 'package:skillwave/features/my-learnings/presentation/screens/my_learnings_screen.dart';
import 'package:skillwave/features/study_groups/presentation/view/group_study_page.dart';
import 'package:skillwave/features/study_groups/presentation/view/create_group_page.dart';
import 'package:skillwave/features/study_groups/presentation/view/my_study_groups_page.dart';

import '../../features/SettingScreen/presentation/screens/aboutus_page.dart';
import '../../features/SettingScreen/presentation/screens/notification_settings_screen.dart';
import '../../features/SettingScreen/presentation/screens/security_settings_screen.dart';
import '../../features/SettingScreen/presentation/screens/privacy_settings_screen.dart';
import '../../features/SettingScreen/presentation/screens/contact_us_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page|View,Route')
@lazySingleton
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    // initial route
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    // auth routes
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignupRoute.page),
    AutoRoute(page: ResetPasswordRoute.page),
    AutoRoute(page: SendOtpRoute.page),
    AutoRoute(page: VerifyOtpRoute.page),
    // dashboard routes
    AutoRoute(
      page: HomeRoute.page,
      children: [
        AutoRoute(page: DashboardRoute.page, path: 'dashboard'),
        AutoRoute(page: CoursesRoute.page, path: 'courses'),
        AutoRoute(page: BlogsRoute.page, path: 'blogs'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
      ],
    ),
    AutoRoute(page: GroupStudyRoute.page, path: '/study-groups'),
    AutoRoute(page: AboutUsRoute.page),
    AutoRoute(page: CourseDetailsRoute.page),
    AutoRoute(page: CreatePostRoute.page, path: '/create-post'),
    AutoRoute(page: CreateGroupRoute.page, path: '/create-group'),
    AutoRoute(page: ChangePasswordRoute.page, path: '/change-password'),
    AutoRoute(page: EditProfileRoute.page, path: '/edit-profile'),
    AutoRoute(page: MyLearningsRoute.page, path: '/my-learnings'),
    AutoRoute(page: LessonsListRoute.page, path: '/lessons-list'),
    AutoRoute(page: ContentRoute.page, path: '/content-page'),
    AutoRoute(
      page: NotificationSettingsRoute.page,
      path: '/notification-settings',
    ),
    AutoRoute(page: SecuritySettingsRoute.page, path: '/security-settings'),
    AutoRoute(page: PrivacySettingsRoute.page, path: '/privacy-settings'),
    AutoRoute(page: ContactUsRoute.page, path: '/contact-us'),
    AutoRoute(page: MyStudyGroupsRoute.page, path: '/my-study-groups'),
  ];
}
