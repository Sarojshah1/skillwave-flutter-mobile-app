import 'package:flutter/material.dart';

class PasswordFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final VoidCallback onVisibilityToggle;
  final Icon visibilityIcon;

  const PasswordFieldWidget({
    required this.controller,
    required this.hint,
    required this.obscureText,
    required this.onVisibilityToggle,
    required this.visibilityIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
        suffixIcon: IconButton(
          icon: visibilityIcon,
          onPressed: onVisibilityToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
