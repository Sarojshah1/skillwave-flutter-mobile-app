import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/contact_Card.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/contact_Form.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/help_box.dart';


class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  static final contactInfo = [
    {
      'icon': Iconsax.location,
      'title': 'Visit Us',
      'details': ['Kathmandu, Nepal', 'Thamel District'],
      'gradient': [Colors.blue, Colors.cyan],
    },
    {
      'icon': Iconsax.call,
      'title': 'Call Us',
      'details': ['+977-1234567890', '+977-9876543210'],
      'gradient': [Colors.green, Colors.teal],
    },
    {
      'icon': Iconsax.direct,
      'title': 'Email Us',
      'details': ['info@skillwave.com', 'support@skillwave.com'],
      'gradient': [Colors.purple, Colors.pink],
    },
    {
      'icon': Iconsax.clock,
      'title': 'Office Hours',
      'details': ['Mon - Fri: 9AM - 6PM', 'Sat: 10AM - 4PM'],
      'gradient': [Colors.orange, Colors.red],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLarge = MediaQuery.of(context).size.width > 800;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: SkillWaveAppColors.backgroundGradient,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Animate(
                effects: [FadeEffect(duration: 800.ms), MoveEffect(begin: Offset(0, 30))],
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: SkillWaveAppColors.badgeGradient,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Iconsax.message, size: 18, color: SkillWaveAppColors.bodyText),
                          const SizedBox(width: 8),
                          Text(
                            "Get in Touch",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: SkillWaveAppColors.headingText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Contact Us",
                      style: GoogleFonts.inter(
                        fontSize: isLarge ? 48 : 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Ready to start your learning journey? We're here to help you every step of the way",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),
              Flex(
                direction: isLarge ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ...List.generate(contactInfo.length, (index) {
                          final info = contactInfo[index];
                          return Animate(
                            delay: Duration(milliseconds: index * 100),
                            effects: [FadeEffect(duration: 600.ms), MoveEffect(begin: const Offset(0, 20))],
                            child: ContactCard(info),
                          );
                        }),
                        const SizedBox(height: 24),
                        Animate(
                          delay: 400.ms,
                          effects: [FadeEffect(duration: 800.ms), MoveEffect(begin: const Offset(0, 30))],
                          child: const HelpBox(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40, height: 40),
                  const Expanded(child: ContactForm()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}