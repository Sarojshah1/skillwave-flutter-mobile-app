import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/cores/common/common_snackbar.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_primary_button.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_text_field.dart';

@RoutePage()
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _changePassword(BuildContext context) {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar("Please fill in all fields");
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("Passwords do not match");
      return;
    }

    context.read<AuthBloc>().add(
      ResetPasswordEvent(email: widget.email, password: password),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is ForgetPasswordState) {
            CommonSnackbar.show(context, message: state.messgae,title: "Success");
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            CommonSnackbar.show(context, message: state.message,title: "Error",isError: true);
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: SkillWaveAppColors.primary,
                expandedHeight: 140.h,
                pinned: true,
                floating: false,
                elevation: 0,
                automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24.r),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.only(bottom: 20.h),
                  title: Text(
                    "Reset Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: Image.asset(
                            SkillWaveAppAssets.appIcon,
                            height: 90.h,
                          ),
                        ),
                      ),
                      Text(
                        "Create a new password for ${widget.email}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: SkillWaveAppColors.primary,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: "New Password",
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: "Confirm Password",
                        isPassword: true,
                        prefixIcon: Icons.lock_reset_outlined,
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        child: CustomPrimaryButton(
                          iconPosition: IconPosition.right,
                          width: double.infinity,
                          fontSize: 16.sp,
                          text: _isLoading ? "Please wait..." : "Change Password",
                          icon: Icons.check_circle,
                          isLoading: _isLoading,
                          onPressed:  () => _changePassword(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
