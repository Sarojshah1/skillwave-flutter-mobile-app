import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';


enum SnackbarType { info, warning, success, error }

@lazySingleton
class SnackbarService {
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  SnackbarService({required this.messengerKey});

  void showSnackbar({
    required String message,
    required SnackbarType type,
  }) {
    final context = messengerKey.currentContext;
    final baseStyle = AppTextStyles.bodyMedium;

    final style = context == null
        ? baseStyle
        : baseStyle.copyWith(color: Theme.of(context).colorScheme.onPrimary);

    messengerKey.currentState?.removeCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(_getIcon(type), color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: style)),
        ],
      ),
      backgroundColor: _getBackgroundColor(type),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      margin: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
      duration: Duration(seconds: type == SnackbarType.error ? 5 : 3),
    );

    messengerKey.currentState?.showSnackBar(snackBar);
  }

  void showInfo(String message) => showSnackbar(message: message, type: SnackbarType.info);
  void showWarning(String message) => showSnackbar(message: message, type: SnackbarType.warning);
  void showSuccess(String message) => showSnackbar(message: message, type: SnackbarType.success);
  void showError(String message) => showSnackbar(message: message, type: SnackbarType.error);

  IconData _getIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.info:
        return Icons.info_outline;
      case SnackbarType.warning:
        return Icons.warning_amber_rounded;
      case SnackbarType.success:
        return Icons.check_circle_outline;
      case SnackbarType.error:
        return Icons.error_outline;
    }
  }

  Color _getBackgroundColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.info:
        return SkillWaveAppColors.primary;
      case SnackbarType.warning:
        return SkillWaveAppColors.red;
      case SnackbarType.success:
        return SkillWaveAppColors.primary;
      case SnackbarType.error:
        return SkillWaveAppColors.red;
    }
  }
}
