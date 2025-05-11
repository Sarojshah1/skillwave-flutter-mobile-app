import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/features/auth/domian/entity/sign_up_entity.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_primary_button.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:skillwave/features/auth/presentation/widgets/signup_widgets/profile_image_widget.dart';

import 'login_view.dart';

class SignupView extends StatefulWidget {
  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _profileImage;
  bool _isPasswordValid(String password) {
   
    final passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
    return passwordRegExp.hasMatch(password);
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset(SkillWaveAppAssets.appIcon, height: 100)),
                  SizedBox(height: 30),
                  Text(
                    "Create Your Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text("Join SkillWave and start your learning journey!", style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                  SizedBox(height: 30),
                  Center(
                    child: ProfileImageWidget(
                      profileImage: _profileImage, onImageSelected: (File image  ) { setState(() {
                      _profileImage = image;
                    }); },

                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(controller: _nameController, hintText: 'Full Name', prefixIcon: Icons.person, ),
                  SizedBox(height: 20),
                  CustomTextField(controller: _emailController, hintText: 'Email', prefixIcon: Icons.email),
                  SizedBox(height: 20),
                  CustomTextField(
                    prefixIcon: Icons.lock,
                    onToggleObscureText: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      if (!_isPasswordValid(value)) {
                        return 'Password must contain at least 1 uppercase letter, 1 number, and 1 special character';
                      }
                      return null;
                    },
                    controller: _passwordController,
                    hintText: "Password",
                    obscureText: _obscurePassword,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    prefixIcon: Icons.lock,
                    onToggleObscureText: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    controller:_confirmPasswordController,
                    hintText:"Confirm Password",
                    obscureText: _obscurePassword,
                  ),

                  SizedBox(height: 20),
                  CustomTextField(controller: _bioController, hintText: 'Tell us about yourself', prefixIcon: Icons.info, maxLines: 3),
                  SizedBox(height: 30),
                  Center(child: CustomPrimaryButton(onPressed: _handleSignup, text: 'SignUp', icon: Icons.arrow_right_alt_rounded,)),
                  SizedBox(height: 30),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.grey.shade600)),
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
      if(authBloc.state is SignupSuccess){
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(child: Text('🎉 Congratulations', style: TextStyle(fontWeight: FontWeight.bold))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(SkillWaveAppAssets.congrats, height: 120.h),
              SizedBox(height: 20),
              Text(
                'Your account is ready to use. You will be redirected to the home page in a few seconds.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  );
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
        );
      },
    );
  }

}
