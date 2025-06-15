import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_primary_button.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:skillwave/features/auth/presentation/widgets/signup_widgets/profile_image_widget.dart';

@RoutePage()
class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _bioController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _profileImage;

  bool _isPasswordValid(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: SkillWaveAppColors.primary,
            expandedHeight: 80,
            pinned: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 20),
              title: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ProfileImageWidget(
                      profileImage: _profileImage,
                      onImageSelected: (File image) {
                        setState(() {
                          _profileImage = image;
                        });
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Full Name',
                      prefixIcon: Icons.person,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      hintText: "Password",
                      onToggleObscureText: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your password';
                        if (value.length < 6) return 'Password must be at least 6 characters';
                        if (!_isPasswordValid(value)) {
                          return 'Must have 1 uppercase, 1 number, 1 special character';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                      onToggleObscureText: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please confirm your password';
                        if (value != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      controller: _bioController,
                      hintText: 'Tell us about yourself',
                      prefixIcon: Icons.info,
                      maxLines: 3,
                    ),
                    SizedBox(height: 30.h),
                    CustomPrimaryButton(
                      text: 'Sign Up',
                      icon: Icons.arrow_right_alt_rounded,
                      onPressed: _handleSignup,
                    ),
                    SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.router.replace(const LoginRoute());
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      final user = SignUpEntity(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        role: 'student',
      );

      final authBloc = BlocProvider.of<AuthBloc>(context);
      authBloc.add(SignUpRequested(user: user, profilePicture: _profileImage));

      if (authBloc.state is SignupSuccess) {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(child: Text('🎉 Congratulations', style: TextStyle(fontWeight: FontWeight.bold))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(SkillWaveAppAssets.congrats, height: 120.h),
            SizedBox(height: 20),
            Text(
              'Your account is ready to use. You will be redirected to the login page.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.router.replace(const LoginRoute());
              },
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                backgroundColor: Colors.blueAccent,
              ),
              child: Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}
