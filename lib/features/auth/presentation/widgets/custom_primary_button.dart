import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/themes/app_themes.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 22.sp),
      ),
      label: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(8.0.sp),
        child: Icon(icon,size: 22.sp,weight: 20.sp, color: SkillWaveAppColors.primary),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: SkillWaveAppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0.r)),
        padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 12.h),
      ),
    );
  }
}