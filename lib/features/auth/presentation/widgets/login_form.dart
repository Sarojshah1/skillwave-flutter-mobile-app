import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/auth/domian/entity/login_entity.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/homeScreen/presentation/screens/home_view.dart';

import 'custom_primary_button.dart';
import 'custom_social_button.dart';
import 'custom_text_button.dart';
import 'custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _rememberMe = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/icons/appicon.png')),
              const SizedBox(height: 40),
              Text(
                "Let's Sign In.!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Login to Your Account to Continue your Courses",
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 30.h),

              CustomTextField(
                controller: _emailController,
                hintText: "Email",
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                prefixIcon: Icons.lock,
                isPassword: true,
                obscureText: _obscureText,
                onToggleObscureText: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      const Text("Remember Me"),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      context.router.push(const SendOtpRoute());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    context.replaceRoute(const HomeRoute());
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return Center(
                    child: CustomPrimaryButton(
                      text: "Sign In",
                      icon: Icons.arrow_forward_outlined,
                      isLoading: isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          context.read<AuthBloc>().add(
                            LogInRequested(
                              entity: LogInEntity(
                                email: email,
                                password: password,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSocialButton(
                    icon: Icons.facebook,
                    onPressed: () {
                      // todo: after doing in backend will implement in near future
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16.sp,
                      ),
                    ),
                    CustomTextLink(
                      color: SkillWaveAppColors.primary,
                      text: "Sign Up",
                      onTap: () {
                        context.router.replaceAll([const SignupRoute()]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
