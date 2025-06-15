import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  const DropdownField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: "General Inquiry",
        items: const [
          DropdownMenuItem(value: "General Inquiry", child: Text("General Inquiry")),
          DropdownMenuItem(value: "Course Information", child: Text("Course Information")),
          DropdownMenuItem(value: "Technical Support", child: Text("Technical Support")),
          DropdownMenuItem(value: "Partnership", child: Text("Partnership")),
        ],
        onChanged: null,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white70,
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
      ),
    );
  }
}