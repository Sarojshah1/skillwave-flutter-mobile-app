import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/drop_down_field.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/gradient_button.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/text_field.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [FadeEffect(duration: 800.ms), MoveEffect(begin: const Offset(50, 0))],
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Send us a Message", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            CustomTextField(label: "First Name"),
            CustomTextField(label: "Last Name"),
            CustomTextField(label: "Email"),
            DropdownField(),
            CustomTextField(label: "Message", maxLines: 5),
            SizedBox(height: 16),
            GradientButton("Send Message", background: Colors.blue, textColor: Colors.white),
          ],
        ),
      ),
    );
  }
}