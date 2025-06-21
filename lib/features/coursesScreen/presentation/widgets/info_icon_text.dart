import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoIconText extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const InfoIconText({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18.sp, color: color),
        SizedBox(width: 6.w),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            label,
            style: TextStyle(color: color, fontSize: 13.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
