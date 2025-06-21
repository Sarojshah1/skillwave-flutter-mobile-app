import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/personal_info.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/profile_header.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/setting_section.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/tab_navigation.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';

@RoutePage()
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String activeTab = 'info';

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadUserProfile());
  }

  void handleTabChange(String tab) => setState(() => activeTab = tab);

  Widget renderTabContent(UserEntity user) {
    switch (activeTab) {
      case 'info':
        return PersonalInfo(user: user);
      case 'courses':
        return const Center(child: Text("Courses Section"));
      case 'certificates':
        return const Center(child: Text("Certificates Section"));
      case 'quizzes':
        return const Center(child: Text("Quizzes Section"));
      case 'settings':
        return const SettingsSection();
      default:
        return PersonalInfo(user: user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final user = state.user;
              return Column(
                children: [
                  ProfileHeader(user: user),
                  TabNavigation(
                    activeTab: activeTab,
                    onTabChange: handleTabChange,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: renderTabContent(user),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is ProfileError) {
              return Center(child: Text("Error: ${state.failure.message}"));
            } else {
              return const SizedBox(); // initial or fallback
            }
          },
        ),
      ),
    );
  }
}
