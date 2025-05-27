import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

enum IconPosition { left, right, center, top }

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final double fontSize;
  final Color buttonColor;
  final Color textColor;
  final Color iconColor;
  final double width;
  final double height;
  final IconPosition iconPosition;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.fontSize = 18,
    this.buttonColor = SkillWaveAppColors.primary,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.width = double.infinity,
    this.height = 50,
    this.iconPosition = IconPosition.left,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = SizedBox(
        height: 24.sp,
        width: 24.sp,
        child: CircularProgressIndicator(color: textColor, strokeWidth: 2.5),
      );
    } else {
      final iconWidget = Icon(icon, size: 22.sp, color: iconColor);
      final textWidget = Text(
        text,
        style: TextStyle(
          fontSize: fontSize.sp,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      );

      switch (iconPosition) {
        case IconPosition.left:
          content = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [iconWidget, SizedBox(width: 8.w), textWidget],
          );
          break;
        case IconPosition.right:
          content = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [textWidget, SizedBox(width: 8.w), iconWidget],
          );
          break;
        case IconPosition.center:
          content = iconWidget;
          break;
        case IconPosition.top:
          content = Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [iconWidget, SizedBox(height: 4.h), textWidget],
          );
          break;
      }
    }

    return SizedBox(
      width: width,
      height: height.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        ),
        child: content,
      ),
    );
  }
}
