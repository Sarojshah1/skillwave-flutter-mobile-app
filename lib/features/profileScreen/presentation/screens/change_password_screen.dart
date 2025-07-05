import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/change_password_widgets/change_password_app_bar.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/change_password_widgets/change_password_header_icon.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/change_password_widgets/change_password_header_text.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/change_password_widgets/change_password_field.dart';
import 'package:skillwave/features/profileScreen/presentation/widgets/change_password_widgets/change_password_submit_button.dart';

@RoutePage()
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final current = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (newPass != confirm) {
      _showSnackBar("New passwords do not match");
      return;
    }

    context.read<ChangePasswordBloc>().add(
      ChangePasswordRequested(
        currentPassword: current,
        newPassword: newPass,
        confirmPassword: confirm,
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          _showSnackBar("Password changed successfully!");
          Navigator.of(context).pop();
        } else if (state is ChangePasswordError) {
          _showSnackBar(state.failure.message);
        }
      },
      child: Scaffold(
        appBar: const ChangePasswordAppBar(),
        body: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
          builder: (context, state) {
            final isLoading = state is ChangePasswordLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ChangePasswordHeaderIcon(),
                    const SizedBox(height: 24),
                    const ChangePasswordHeaderText(),
                    const SizedBox(height: 32),
                    ChangePasswordField(
                      controller: _currentPasswordController,
                      label: "Current Password",
                      icon: Icons.lock_outline,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ChangePasswordField(
                      controller: _newPasswordController,
                      label: "New Password",
                      icon: Icons.lock,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ChangePasswordField(
                      controller: _confirmPasswordController,
                      label: "Confirm New Password",
                      icon: Icons.lock_reset_outlined,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ChangePasswordSubmitButton(
                      isLoading: isLoading,
                      onPressed: _handleChangePassword,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
