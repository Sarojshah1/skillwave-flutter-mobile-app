import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/config/routes/app_router.dart';

class DashboardAppBar extends StatefulWidget {
  const DashboardAppBar({super.key});

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();
}

class _DashboardAppBarState extends State<DashboardAppBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Load user profile when widget initializes
    context.read<ProfileBloc>().add(LoadUserProfile());

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                SkillWaveAppColors.primary.withOpacity(0.95),
                SkillWaveAppColors.primary.withOpacity(0.8),
                SkillWaveAppColors.primary.withOpacity(0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: SkillWaveAppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Profile and Input Row
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Row(
                        children: [
                          // Enhanced Profile Avatar
                          _buildProfileAvatar(),
                          const SizedBox(width: 12),
                          // Enhanced Create Post Input
                          Expanded(child: _buildCreatePostInput()),
                          const SizedBox(width: 8),
                          // Enhanced Menu Button
                          _buildMenuButton(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
      leading: null, // Remove default leading
      title: null, // Remove default title
      actions: null, // Remove default actions
      centerTitle: false,
    );
  }

  Widget _buildProfileAvatar() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: SkillWaveAppColors.primary,
            backgroundImage:
                profileState is ProfileLoaded &&
                    profileState.user.profilePicture.isNotEmpty
                ? CachedNetworkImageProvider(
                    "http://10.0.2.2:3000/profile/${profileState.user.profilePicture}",
                  )
                : null,
            child: profileState is ProfileLoaded
                ? (profileState.user.profilePicture.isEmpty
                      ? Text(
                          profileState.user.name.substring(0, 1).toUpperCase(),
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: SkillWaveAppColors.textInverse,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      : null)
                : Container(
                    width: 24,
                    height: 24,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        SkillWaveAppColors.textInverse,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildCreatePostInput() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        return GestureDetector(
          onTap: () {
            context.router.push(CreatePostRoute());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: SkillWaveAppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: SkillWaveAppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    profileState is ProfileLoaded
                        ? 'What\'s on your mind, ${profileState.user.name}?'
                        : 'What\'s on your mind?',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 16,
                      color: SkillWaveAppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: SkillWaveAppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: SkillWaveAppColors.primary,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'group_chats':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text('Group Chats coming soon!'),
                    ],
                  ),
                  backgroundColor: SkillWaveAppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              break;
            case 'group_projects':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.assignment_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text('Group Projects coming soon!'),
                    ],
                  ),
                  backgroundColor: SkillWaveAppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              break;
          }
        },
        icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              value: 'group_chats',
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: SkillWaveAppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: SkillWaveAppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Group Chats',
                        style: TextStyle(
                          color: SkillWaveAppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Connect with study groups',
                        style: TextStyle(
                          color: SkillWaveAppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'group_projects',
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: SkillWaveAppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      color: SkillWaveAppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Group Projects',
                        style: TextStyle(
                          color: SkillWaveAppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Collaborate on projects',
                        style: TextStyle(
                          color: SkillWaveAppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
