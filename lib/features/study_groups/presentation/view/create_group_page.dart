import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/features/study_groups/presentation/view_model/group_study_bloc.dart';
import 'package:skillwave/config/di/di.container.dart';

@RoutePage()
class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  String? _error;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _submit() {
    setState(() {
      _error = null;
    });
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      setState(() {
        _error = _imageFile == null ? 'Please select a group image.' : null;
      });
      return;
    }
    context.read<GroupStudyBloc>().add(
      CreateGroupRequested(
        groupName: _nameController.text.trim(),
        groupImage: _imageFile!,
        description: _descController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (_) => getIt<GroupStudyBloc>(),
      child: BlocListener<GroupStudyBloc, GroupStudyState>(
        listener: (context, state) {
          if (state is GroupStudyLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }
          if (state is GroupCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Group "${state.group.groupName}" created!'),
                backgroundColor: SkillWaveAppColors.success,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is GroupStudyError) {
            setState(() {
              _error = state.failure.message;
            });
          }
        },
        child: Scaffold(
          backgroundColor: SkillWaveAppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Custom AppBar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 0,
                      right: 0,
                      bottom: 0,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          SkillWaveAppColors.primary,
                          SkillWaveAppColors.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: SkillWaveAppColors.primary,
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Create Study Group',
                            style: textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width > 500 ? size.width * 0.2 : 24,
                    ),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 32,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: SkillWaveAppColors
                                              .backgroundGradient_2,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.08,
                                              ),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: _imageFile != null
                                            ? ClipOval(
                                                child: Image.file(
                                                  _imageFile!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.camera_alt,
                                                size: 40,
                                                color:
                                                    SkillWaveAppColors.primary,
                                              ),
                                      ),
                                      if (_imageFile != null)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: SkillWaveAppColors.primary,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: SkillWaveAppColors
                                                      .primary
                                                      .withOpacity(0.2),
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(6),
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              TextFormField(
                                controller: _nameController,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: SkillWaveAppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Group Name',
                                  labelStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: SkillWaveAppColors.primary,
                                  ),
                                  filled: true,
                                  fillColor:
                                      SkillWaveAppColors.lightGreyBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Enter group name'
                                    : null,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _descController,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: SkillWaveAppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: SkillWaveAppColors.primary,
                                  ),
                                  filled: true,
                                  fillColor:
                                      SkillWaveAppColors.lightGreyBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                ),
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Enter description'
                                    : null,
                                minLines: 2,
                                maxLines: 4,
                              ),
                              const SizedBox(height: 24),
                              if (_error != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    _error!,
                                    style: const TextStyle(
                                      color: SkillWaveAppColors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: SkillWaveAppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 6,
                                    textStyle: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : const Text('Create Group'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
