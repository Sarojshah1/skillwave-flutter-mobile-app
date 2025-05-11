import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const CustomTextLink({
    super.key,
    required this.text,
    required this.onTap,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w800,
          fontSize: 16.sp
        ),
      ),
    );
  }
}