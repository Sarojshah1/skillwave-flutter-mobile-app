import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/themes/app_themes.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_primary_button.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _changePassword(BuildContext context) {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    // TODO: Trigger password reset logic via Bloc or service
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password changed successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
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
            leading: Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                spacing: 8,
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
                    isPassword: true,
                    controller: _confirmPasswordController,
                    hintText: "Confirm Password",

                    prefixIcon: Icons.lock_reset_outlined,
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: CustomPrimaryButton(
                      iconPosition: IconPosition.right,
                      width: double.infinity,

                      fontSize: 16.sp,
                      text: "Change Password",
                      icon: Icons.check_circle,
                      onPressed: () => _changePassword(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
