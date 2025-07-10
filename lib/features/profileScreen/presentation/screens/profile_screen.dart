import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/personal_info.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/profile_header.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/setting_section.dart';
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
        context.router.pushNamed('/my-learnings');
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
        'label': 'Personal Information',
        'section': 'info',
        'color': SkillWaveAppColors.primary,
        'subtitle': 'View your personal details',
      },
      {
        'icon': Icons.menu_book,
        'label': 'My Courses',
        'section': 'courses',
        'color': Colors.blueAccent,
        'subtitle': 'View your enrolled courses',
      },
      {
        'icon': Icons.groups,
        'label': 'Study Groups',
        'section': 'studygroups',
        'color': Colors.deepPurple,
        'subtitle': 'Join or create study groups',
      },
      {
        'icon': Icons.workspace_premium_outlined,
        'label': 'Certificates',
        'section': 'certificates',
        'color': Colors.amber,
        'subtitle': 'View your earned certificates',
      },
      {
        'icon': Icons.quiz_outlined,
        'label': 'Quizzes',
        'section': 'quizzes',
        'color': Colors.purpleAccent,
        'subtitle': 'Take quizzes and assessments',
      },
      {
        'icon': Icons.settings_outlined,
        'label': 'Settings',
        'section': 'settings',
        'color': Colors.green,
        'subtitle': 'App preferences and settings',
      },
      {
        'icon': Icons.lock_reset,
        'label': 'Change Password',
        'section': 'changepassword',
        'color': Colors.redAccent,
        'subtitle': 'Update your password',
      },
      {
        'icon': Icons.edit,
        'label': 'Edit Profile',
        'section': 'editprofile',
        'color': Colors.teal,
        'subtitle': 'Modify your profile information',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: buttons.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final btn = buttons[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: btn['color'].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(btn['icon'], color: btn['color'], size: 24),
            ),
            title: Text(
              btn['label'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              btn['subtitle'],
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
            onTap: () => _onButtonTap(btn['section'], user),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
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
                    SizedBox(height: 80.h),
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
