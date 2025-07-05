import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class ChangePasswordSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const ChangePasswordSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.check_circle),
        label: Text(isLoading ? "Please wait..." : "Change Password"),
        style: ElevatedButton.styleFrom(
          backgroundColor: SkillWaveAppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: isLoading ? null : onPressed,
      ),
    );
  }
}
