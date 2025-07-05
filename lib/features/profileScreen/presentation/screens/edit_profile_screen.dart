import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/update_profile_bloc/update_profile_bloc.dart';
import 'package:skillwave/features/profileScreen/domin/entity/user_entity.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/edit_profile_widgets/edit_profile_app_bar.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/edit_profile_widgets/edit_profile_avatar.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/edit_profile_widgets/edit_profile_header_text.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/edit_profile_widgets/edit_profile_text_field.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/edit_profile_widgets/edit_profile_action_buttons.dart';

@RoutePage()
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _bioController;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
    _bioController?.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_nameController == null ||
        _emailController == null ||
        _bioController == null) {
      return;
    }

    final name = _nameController!.text.trim();
    final email = _emailController!.text.trim();
    final bio = _bioController!.text.trim();

    context.read<UpdateProfileBloc>().add(
      UpdateProfileRequested(name: name, email: email, bio: bio),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccess) {
          _showSnackBar("Profile updated successfully!");
          Navigator.of(context).pop();
        } else if (state is UpdateProfileError) {
          _showSnackBar(state.failure.message);
        }
      },
      child: Scaffold(
        appBar: const EditProfileAppBar(),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final UserEntity user = state.user;
              _nameController ??= TextEditingController(text: user.name);
              _emailController ??= TextEditingController(text: user.email);
              _bioController ??= TextEditingController(text: user.bio);

              return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
                builder: (context, updateState) {
                  final isLoading = updateState is UpdateProfileLoading;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const EditProfileAvatar(),
                          const SizedBox(height: 24),
                          const EditProfileHeaderText(),
                          const SizedBox(height: 32),
                          EditProfileTextField(
                            controller: _nameController!,
                            label: "Name",
                            icon: Icons.person_outline,
                            enabled: !isLoading,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          EditProfileTextField(
                            controller: _emailController!,
                            label: "Email",
                            icon: Icons.email_outlined,
                            enabled: !isLoading,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          EditProfileTextField(
                            controller: _bioController!,
                            label: "Bio",
                            icon: Icons.info_outline,
                            enabled: !isLoading,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 32),
                          EditProfileActionButtons(
                            isLoading: isLoading,
                            onSave: _handleSave,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.failure.message));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
