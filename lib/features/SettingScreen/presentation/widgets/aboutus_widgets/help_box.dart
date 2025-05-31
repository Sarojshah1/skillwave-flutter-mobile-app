
import 'package:flutter/material.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/gradient_button.dart';

class HelpBox extends StatelessWidget {
  const HelpBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Need Immediate Help?",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Our support team is available 24/7 to assist you with any questions.",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            children: const [
              GradientButton("Live Chat", background: Colors.white24),
              SizedBox(width: 12),
              GradientButton("Schedule Call", background: Colors.white, textColor: Colors.blue),
            ],
          )
        ],
      ),
    );
  }
}