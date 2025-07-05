import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/data/models/post_dto.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_post_bloc/create_post_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_post_bloc/create_post_events.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_post_bloc/create_post_state.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';

@RoutePage()
class CreatePostScreen extends StatefulWidget {
  final String? profile;

  const CreatePostScreen({super.key, this.profile});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  List<String> selectedTags = [];
  List<File> selectedImages = [];
  bool isExpanded = false;
  String selectedCategory = 'General';

  final List<String> categories = [
    "general",
    "academic",
    "technical",
    "social",
    "announcement",
    "question",
    "discussion",
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadUserProfile());
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        if (mounted) {
          setState(() {
            selectedImages.add(File(image.path));
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: SkillWaveAppColors.error,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add Photo/Video',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: SkillWaveAppColors.primary,
              ),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: SkillWaveAppColors.primary,
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  void _createPost() {
    final content = _contentController.text;
    final title = _titleController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      final dto = CreatePostDto(
        title: title,
        content: content,
        images: [], 
        tags: selectedTags,
        category: selectedCategory,
      );

      context.read<CreatePostBloc>().add(
        CreatePost(
          dto,
          images: selectedImages.isNotEmpty ? selectedImages : null,
        ),
      );
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
      barrierDismissible: false,
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
                Navigator.pop(context);
                Navigator.pop(context); // Go back to dashboard
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Tags',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildTagInput(),
                    const SizedBox(height: 16),
                    ..._buildTagOptions(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SkillWaveAppColors.primary,
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _tagController,
        decoration: InputDecoration(
          hintText: 'Add custom tag...',
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.add, color: SkillWaveAppColors.primary),
            onPressed: () => _addCustomTag(),
          ),
        ),
        onSubmitted: (tag) => _addCustomTag(),
      ),
    );
  }

  List<Widget> _buildTagOptions() {
    final tags = [
      'Flutter',
      'Dart',
      'Tech',
      'Programming',
      'AI',
      'Mobile',
      'Web Development',
      'UI/UX',
      'Backend',
      'Frontend',
      'Database',
      'Cloud Computing',
      'DevOps',
      'Machine Learning',
      'Data Science',
    ];

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
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
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

  void _showCategoryDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    title: Text(category),
                    trailing: selectedCategory == category
                        ? const Icon(
                            Icons.check,
                            color: SkillWaveAppColors.primary,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
            selectedImages.clear();
          });
          // Reset the BLoC state after successful post
          context.read<CreatePostBloc>().add(const ResetCreatePost());
        } else if (state is CreatePostError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: SkillWaveAppColors.error,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
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
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            BlocBuilder<CreatePostBloc, CreatePostState>(
              builder: (context, state) {
                final isLoading = state is CreatePostLoading;
                final hasTitle = _titleController.text.trim().isNotEmpty;
                final hasContent = _contentController.text.trim().isNotEmpty;
                final canSubmit = hasTitle && hasContent && !isLoading;

                return TextButton(
                  onPressed: canSubmit ? _createPost : null,
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<CreatePostBloc, CreatePostState>(
          builder: (context, createPostState) {
            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // Main post creation area
                          Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // User info and content area
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      // User profile and "What's on your mind?"
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                SkillWaveAppColors.primary,
                                            backgroundImage:
                                                profileState is ProfileLoaded &&
                                                    profileState
                                                        .user
                                                        .profilePicture
                                                        .isNotEmpty
                                                ? CachedNetworkImageProvider(
                                                    "http://10.0.2.2:3000/profile/${profileState.user.profilePicture}",
                                                  )
                                                : null,
                                            child: profileState is ProfileLoaded
                                                ? (profileState
                                                          .user
                                                          .profilePicture
                                                          .isEmpty
                                                      ? Text(
                                                          profileState.user.name
                                                              .substring(0, 1)
                                                              .toUpperCase(),
                                                          style: AppTextStyles
                                                              .bodyLarge
                                                              .copyWith(
                                                                color: SkillWaveAppColors
                                                                    .textInverse,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        )
                                                      : null)
                                                : const CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(
                                                          SkillWaveAppColors
                                                              .textInverse,
                                                        ),
                                                  ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  profileState is ProfileLoaded
                                                      ? profileState.user.name
                                                      : 'Loading...',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const Text(
                                                  'What\'s on your mind?',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Title field
                                      TextField(
                                        controller: _titleController,
                                        decoration: const InputDecoration(
                                          hintText: 'Add a title...',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Content field
                                      TextField(
                                        controller: _contentController,
                                        maxLines: null,
                                        decoration: const InputDecoration(
                                          hintText: 'Write something...',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),

                                // Selected images
                                if (selectedImages.isNotEmpty) ...[
                                  const Divider(height: 1),
                                  Container(
                                    height: 120,
                                    padding: const EdgeInsets.all(16),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: selectedImages.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  selectedImages[index],
                                                  width: 100,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _removeImage(index),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.black54,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],

                                // Tags display
                                if (selectedTags.isNotEmpty) ...[
                                  const Divider(height: 1),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children: selectedTags.map((tag) {
                                        return Chip(
                                          label: Text(tag),
                                          deleteIcon: const Icon(
                                            Icons.clear,
                                            size: 18,
                                          ),
                                          onDeleted: () {
                                            setState(() {
                                              selectedTags.remove(tag);
                                            });
                                          },
                                          backgroundColor: SkillWaveAppColors
                                              .primary
                                              .withValues(alpha: 0.1),
                                          labelStyle: const TextStyle(
                                            color: SkillWaveAppColors.primary,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],

                                // Category display
                                if (selectedCategory != 'General') ...[
                                  const Divider(height: 1),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.category,
                                          color: SkillWaveAppColors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Category: $selectedCategory',
                                          style: const TextStyle(
                                            color: SkillWaveAppColors.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                // Action buttons
                                const Divider(height: 1),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      _buildActionButton(
                                        icon: Icons.photo_library,
                                        label: 'Photo/Video',
                                        onTap: _showImageSourceDialog,
                                      ),
                                      _buildActionButton(
                                        icon: Icons.label,
                                        label: 'Tags',
                                        onTap: _selectTags,
                                      ),
                                      _buildActionButton(
                                        icon: Icons.category,
                                        label: 'Category',
                                        onTap: _showCategoryDialog,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Loading overlay
                    if (createPostState is CreatePostLoading)
                      Container(
                        color: Colors.black.withValues(alpha: 0.5),
                        child: const Center(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Creating post...'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: SkillWaveAppColors.primary, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: SkillWaveAppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
