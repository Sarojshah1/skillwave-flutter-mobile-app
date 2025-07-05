import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/data/models/post_dto.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_post_bloc/create_post_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_post_bloc/create_post_events.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_post_bloc/create_post_state.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';
import 'package:skillwave/config/routes/app_router.dart';

@RoutePage()
class CreatePostScreen extends StatefulWidget {
  final String? profile;

  const CreatePostScreen({Key? key, this.profile}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    // Load user profile when widget initializes
    context.read<ProfileBloc>().add(LoadUserProfile());
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _createPost() {
    final content = _contentController.text;
    final title = _titleController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      final dto = CreatePostDto(
        title: title,
        content: content,
        images: [], // TODO: Add image upload functionality
        tags: selectedTags,
        category: 'General', // TODO: Add category selection
      );

      context.read<CreatePostBloc>().add(CreatePost(dto));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            title.isEmpty ? 'Please enter a title' : 'Please enter content',
          ),
          backgroundColor: SkillWaveAppColors.error,
        ),
      );
    }
  }

  void _showPostCreatedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/success.json',
                width: 150,
                height: 150,
                repeat: false,
              ),
              const SizedBox(height: 20),
              const Text(
                'Post Created!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: SkillWaveAppColors.success,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your post has been successfully created.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.router.pop();
                context.router.pop(); // Go back to dashboard
              },
              child: const Text(
                'OK',
                style: TextStyle(color: SkillWaveAppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _selectTags() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Tags"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [..._buildTagOptions(), _buildTagInput()],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.router.pop();
              },
              child: const Text(
                'Done',
                style: TextStyle(color: SkillWaveAppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTagInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _tagController,
        decoration: InputDecoration(
          hintText: 'Add custom tag...',
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.add, color: SkillWaveAppColors.primary),
            onPressed: () {
              _addCustomTag();
            },
          ),
        ),
        onSubmitted: (tag) {
          _addCustomTag();
        },
      ),
    );
  }

  List<Widget> _buildTagOptions() {
    final tags = ['Flutter', 'Dart', 'Tech', 'Programming', 'AI', 'Mobile'];
    return tags.map((tag) {
      return CheckboxListTile(
        title: Text(tag),
        value: selectedTags.contains(tag),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              selectedTags.add(tag);
            } else {
              selectedTags.remove(tag);
            }
          });
        },
      );
    }).toList();
  }

  void _addCustomTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !selectedTags.contains(tag)) {
      setState(() {
        selectedTags.add(tag);
        _tagController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostLoaded) {
          _showPostCreatedDialog();
          _contentController.clear();
          _titleController.clear();
          setState(() {
            selectedTags.clear();
          });
        } else if (state is CreatePostError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: SkillWaveAppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create Post',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SkillWaveAppColors.primary,
                  SkillWaveAppColors.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 4,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.router.pop();
            },
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 22,
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
                                        profileState.user.name
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: SkillWaveAppColors.textInverse,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null)
                              : const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    SkillWaveAppColors.textInverse,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'What\'s on your mind?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: SkillWaveAppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter post title...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: SkillWaveAppColors.textDisabled,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Write something...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: SkillWaveAppColors.textDisabled,
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1),
                  Wrap(
                    spacing: 8.0,
                    children: selectedTags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        deleteIcon: const Icon(Icons.clear),
                        onDeleted: () {
                          setState(() {
                            selectedTags.remove(tag);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPostOption(Icons.photo, 'Photo/Video'),
                      _buildPostOption(Icons.tag, 'Tag Friends'),
                      IconButton(
                        icon: const Icon(
                          Icons.label,
                          color: SkillWaveAppColors.primary,
                        ),
                        onPressed: _selectTags,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: BlocBuilder<CreatePostBloc, CreatePostState>(
                      builder: (context, state) {
                        final isLoading = state is CreatePostLoading;
                        final hasTitle = _titleController.text
                            .trim()
                            .isNotEmpty;
                        final hasContent = _contentController.text
                            .trim()
                            .isNotEmpty;
                        final canSubmit = hasTitle && hasContent && !isLoading;

                        return ElevatedButton(
                          onPressed: canSubmit ? _createPost : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 24.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: SkillWaveAppColors.primary,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      SkillWaveAppColors.textInverse,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Post',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: SkillWaveAppColors.textInverse,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostOption(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // TODO: Add functionality for each option like image picker
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label functionality coming soon!'),
            backgroundColor: SkillWaveAppColors.primary,
          ),
        );
      },
      child: Row(
        children: [
          Icon(icon, color: SkillWaveAppColors.success),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: SkillWaveAppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
