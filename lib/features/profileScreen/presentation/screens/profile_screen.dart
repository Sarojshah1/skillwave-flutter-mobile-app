import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/personal_info.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/profile_header.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/setting_section.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/tab_navigation.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

@RoutePage()
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadUserProfile());
  }

  void _onButtonTap(String section, UserEntity user) {
    switch (section) {
      case 'info':
        _showSectionDialog('Personal Info', PersonalInfo(user: user));
        break;
      case 'courses':
        context.router.pushNamed('/courses');
        break;
      case 'certificates':
        _showSectionDialog(
          'Certificates',
          const Center(child: Text("Certificates Section")),
        );
        break;
      case 'quizzes':
        _showSectionDialog(
          'Quizzes',
          const Center(child: Text("Quizzes Section")),
        );
        break;
      case 'settings':
        _showSectionDialog('Settings', const SettingsSection());
        break;
      case 'studygroups':
        // Placeholder navigation for Study Groups
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigate to Study Groups page (to be implemented)'),
          ),
        );
        // context.router.pushNamed('/studygroups'); // Uncomment when StudyGroup page exists
        break;
      case 'changepassword':
        context.router.push(const ChangePasswordRoute());
        break;
      case 'editprofile':
        context.router.push(const EditProfileRoute());
        break;
    }
  }

  void _showSectionDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: content),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButtons(UserEntity user) {
    final List<Map<String, dynamic>> buttons = [
      {
        'icon': Icons.info_outline,
        'label': 'Info',
        'section': 'info',
        'color': SkillWaveAppColors.primary,
      },
      {
        'icon': Icons.menu_book,
        'label': 'Courses',
        'section': 'courses',
        'color': Colors.blueAccent,
      },
      {
        'icon': Icons.groups,
        'label': 'Study Groups',
        'section': 'studygroups',
        'color': Colors.deepPurple,
      },
      {
        'icon': Icons.workspace_premium_outlined,
        'label': 'Certificates',
        'section': 'certificates',
        'color': Colors.amber,
      },
      {
        'icon': Icons.quiz_outlined,
        'label': 'Quizzes',
        'section': 'quizzes',
        'color': Colors.purpleAccent,
      },
      {
        'icon': Icons.settings_outlined,
        'label': 'Settings',
        'section': 'settings',
        'color': Colors.green,
      },
      {
        'icon': Icons.lock_reset,
        'label': 'Change Password',
        'section': 'changepassword',
        'color': Colors.redAccent,
      },
      {
        'icon': Icons.edit,
        'label': 'Edit Profile',
        'section': 'editprofile',
        'color': Colors.teal,
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: buttons.map((btn) {
          return GestureDetector(
            onTap: () => _onButtonTap(btn['section'], user),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    btn['color'].withOpacity(0.85),
                    btn['color'].withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: btn['color'].withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(btn['icon'], size: 36, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    btn['label'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileBloc>().add(LoadUserProfile());
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    ProfileHeader(user: user),
                    _buildProfileButtons(user),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text("Error: ${state.failure.message}"));
            } else {
              return const SizedBox(); // initial or fallback
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
