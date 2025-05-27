import 'package:flutter/material.dart';

class CommonSnackbar {
  static void show(
      BuildContext context, {
        required String message,
        bool isError = false,
        String? title,
        Duration duration = const Duration(seconds: 3),
      }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = isError
        ? colorScheme.error.withOpacity(0.9)
        : colorScheme.secondaryContainer;

    final textColor = isError
        ? colorScheme.onError
        : colorScheme.onSecondaryContainer;

    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;

    final snackBar = SnackBar(
      duration: duration,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
