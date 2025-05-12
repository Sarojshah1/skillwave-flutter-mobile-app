import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/themes/app_themes.dart';
import 'package:skillwave/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:skillwave/features/auth/presentation/widgets/custom_primary_button.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _validateOTP(BuildContext context) async {
    String otp = _otpController.text;
    if (otp.length == 6) {
      context.read<AuthBloc>().add(VerifyOtpEvent(email: widget.email, otp: otp));
    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state is AuthLoading){

        }else if(state is VerifyOtpState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.messgae),
              backgroundColor: Colors.green,
            ),
          );
        }else if(state is AuthFailure){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
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
                  "Verify OTP",
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
                      "Enter the OTP sent to ${widget.email}",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: SkillWaveAppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Pinput(
                      length: 6,
                      controller: _otpController,
                      onCompleted: (_) => _validateOTP(context),
                      showCursor: true,
                      onChanged: (_) {},
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      child: CustomPrimaryButton(
                        text: "Verify OTP",
                        icon: Icons.lock,
                        onPressed: () => _validateOTP(context),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Resend OTP logic
                        },
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(color: SkillWaveAppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
