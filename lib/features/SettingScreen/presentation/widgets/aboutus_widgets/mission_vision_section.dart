import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/core_value_card.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/mission_vision_card.dart';

class MissionVisionSection extends StatelessWidget {
  const MissionVisionSection({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Animate(
                effects: [FadeEffect(duration: 800.ms), SlideEffect(begin: Offset(0, 0.1), duration: 800.ms)],
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.lightbulb, size: 18, color: Color(0xFF1E40AF)),
                          SizedBox(width: 8),
                          Text(
                            "Our Purpose",
                            style: TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    const Text(
                      "Mission & Vision",
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 600,
                      child: Text(
                        "Driving the future of education with purpose and innovation",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 64),

              // Mission and Vision Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Animate(
                      effects: [
                        FadeEffect(duration: 800.ms, delay: 200.ms),
                        SlideEffect(begin: Offset(-0.3, 0), duration: 800.ms, delay: 200.ms)
                      ],
                      child: MissionVisionCard(
                        title: "Our Mission",
                        icon: Icons.tablet_sharp,
                        iconGradient:SkillWaveAppColors.blueGradient,
                        backgroundGradient: LinearGradient(
                          colors: [Colors.blue.withOpacity(0.15), Colors.purple.withOpacity(0.15)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        description:
                        "To democratize high-quality education by providing accessible, innovative learning experiences that empower individuals to achieve their full potential and excel in their chosen careers.",
                        tags: ["Accessibility", "Innovation", "Excellence"],
                        tagBackgroundColor: Colors.blue[100]!,
                        tagTextColor: Colors.blue[700]!,
                        underlineGradient: SkillWaveAppColors.blueGradient,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Animate(
                      effects: [
                        FadeEffect(duration: 800.ms, delay: 400.ms),
                        SlideEffect(begin: Offset(0.3, 0), duration: 800.ms, delay: 400.ms)
                      ],
                      child: MissionVisionCard(
                        title: "Our Vision",
                        icon: Icons.remove_red_eye_outlined,
                        iconGradient: SkillWaveAppColors.purplePinkGradient,
                        backgroundGradient: LinearGradient(
                          colors: [Colors.purple.withOpacity(0.15), Colors.pink.withOpacity(0.15)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        description:
                        "To become the world's leading e-learning platform, creating a global community where education transcends boundaries and becomes the bridge to unlimited opportunities and success.",
                        tags: ["Global Impact", "Community", "Future-Ready"],
                        tagBackgroundColor: Colors.purple[100]!,
                        tagTextColor: Colors.purple[700]!,
                        underlineGradient: SkillWaveAppColors.purplePinkGradient,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 64),

              // Core Values Section
              Animate(
                effects: [FadeEffect(duration: 800.ms, delay: 600.ms), SlideEffect(begin: Offset(0, 0.1), duration: 800.ms, delay: 600.ms)],
                child: Column(
                  children: [
                    const Text(
                      "Our Core Values",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 24,
                      runSpacing: 24,
                      children: [
                        CoreValueCard(
                          icon: Icons.rocket_launch,
                          title: "Innovation",
                          description: "Pushing boundaries in education technology",
                          gradient: SkillWaveAppColors.blueGradient,
                        ),
                        CoreValueCard(
                          icon: Icons.track_changes,
                          title: "Excellence",
                          description: "Delivering the highest quality learning experiences",
                          gradient: SkillWaveAppColors.blueGradient,
                        ),
                        CoreValueCard(
                          icon: Icons.remove_red_eye_outlined,
                          title: "Transparency",
                          description: "Open and honest in all our interactions",
                          gradient: SkillWaveAppColors.blueGradient,
                        ),
                        CoreValueCard(
                          icon: Icons.lightbulb,
                          title: "Growth",
                          description: "Continuous improvement and learning",
                          gradient: SkillWaveAppColors.blueGradient,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
