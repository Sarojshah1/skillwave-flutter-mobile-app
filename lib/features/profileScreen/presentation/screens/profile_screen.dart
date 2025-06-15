import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/personal_info.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/profile_header.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/tab_navigation.dart';
@RoutePage()
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String activeTab = 'info';

  final user = UserEntity(
    id: '684e4edf70cc7813be613ba1',
    name: 'Saroj Shah',
    email: 'saroj@example.com',
    role: 'student',
    bio: 'I am a good student',
    profilePicture: 'profile-1749962463351-0ec215ee-a0a6-4ce0-83eb-1be83461ee04.png',
    enrolledCourses: ['Course 1', 'Course 2'],
    certificates: ['Cert 1'],
    createdAt: DateTime.parse("2025-06-15T04:41:03.356Z"),
  );

  void handleTabChange(String tab) => setState(() => activeTab = tab);

  Widget renderTabContent() {
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
        return const Center(child: Text("Settings Section"));
      default:
        return PersonalInfo(user: user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeader(user: user),
            TabNavigation(activeTab: activeTab, onTabChange: handleTabChange),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: renderTabContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




