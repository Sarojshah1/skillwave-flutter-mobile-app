import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/config/themes/app_themes.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_primary_button.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_text_field.dart';

@RoutePage()
class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _onSendOtp() {
    final email = _emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email")),
      );
    } else {
      context.read<AuthBloc>().add(SendOtpEvent(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = state is AuthLoading);
          } else if (state is SendOtpState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.messgae),
                backgroundColor: Colors.green,
              ),
            );
            context.router.replaceAll([VerifyOtpRoute(email: _emailController.text)]);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed: ${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Stack(
          children:[ CustomScrollView(
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
                    "Send OTP",
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        "Reset Your Password",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: SkillWaveAppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Please enter your registered email to receive an OTP.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                      ),
                      SizedBox(height: 32.h),
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Email Address",
                        prefixIcon: Icons.email_outlined,
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        child: CustomPrimaryButton(
                          text: "Send OTP",
                          icon: Icons.send,
                          onPressed: _onSendOtp,
                        ),
                      ),
          
          
                    ],
                  ),
                ),
              ),
            ],
          ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: SkillWaveAppColors.primary,
                  ),
                ),
              ),
      ]
        ),
      ),
    );
  }
}
