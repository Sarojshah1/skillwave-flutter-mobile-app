import 'dart:ui';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/achievements_section.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/contact_section.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/cta_Section.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/hero_section.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/mission_vision_section.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/team_section.dart';

@RoutePage()
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: SkillWaveAppColors.backgroundGradient_2,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -160,
              right: -160,
              child: _BlurredCircle(
                width: 320,
                height: 320,
                colors: [
                  SkillWaveAppColors.blue_alpha,
                  SkillWaveAppColors.purple_alpha
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5 - 160,
              left: -160,
              child: _BlurredCircle(
                width: 320,
                height: 320,
                colors: [
                  SkillWaveAppColors.indigo_alpha,
                  SkillWaveAppColors.pink_alpha
                ],
              ),
            ),
            Positioned(
              bottom: -160,
              right: MediaQuery.of(context).size.width / 3,
              child: _BlurredCircle(
                width: 320,
                height: 320,
                colors: [
                 SkillWaveAppColors.cyan_alpha,
                  SkillWaveAppColors.blue_alpha,
                ],
              ),
            ),

            // Main scrollable content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  spacing: 48,
                  children: const [
                    HeroSection(),
                    MissionVisionSection(),
                    AchievementsSection(),
                    TeamSection(),
                    ContactSection(),
                    CTASection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlurredCircle extends StatelessWidget {
  final double width;
  final double height;
  final List<Color> colors;

  const _BlurredCircle({
    required this.width,
    required this.height,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
