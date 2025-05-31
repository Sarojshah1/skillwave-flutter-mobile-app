import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/SettingScreen/data/model/team_member.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/stat_card.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/team_member_card.dart';


final List<TeamMember> teamMembers = List.generate(
  4,
      (index) => TeamMember(
    name: 'Saroj Kumar Sah',
    role: 'Founder & CEO',
    imagePath: SkillWaveAppAssets.user,
    intro: 'Visionary entrepreneur driving innovation in e-learning.',
    skills: ['Leadership', 'Strategy', 'Innovation'],
  ),
);

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (width >= 1024) {
      crossAxisCount = 4;
    } else if (width >= 768) {
      crossAxisCount = 2;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        gradient: SkillWaveAppColors.blueGradient,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header with fade+slide animation
              Column(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: SkillWaveAppColors.purplePinkGradient,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.purple[500],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Meet the Team',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.purple[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'The Minds Behind SkillWave',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w900,
                      fontSize: 48,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Text(
                      'Passionate professionals dedicated to transforming education and empowering learners worldwide',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              )
                  .animate() // Animate the entire header
                  .fade(duration: 700.ms)
                  .slide(begin: const Offset(0, 0.2), duration: 700.ms),

              const SizedBox(height: 48),

              // Team Members Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 0.75,
                ),
                itemCount: teamMembers.length,
                itemBuilder: (context, index) {
                  final member = teamMembers[index];
                  return TeamMemberCard(
                    member: member,
                    index: index,
                  );
                },
              ),

              const SizedBox(height: 48),

              // Stats
              Wrap(
                spacing: 24,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  StatCard(number: '50+', label: 'Team Members'),
                  StatCard(number: '15+', label: 'Countries'),
                  StatCard(number: '8+', label: 'Years Experience'),
                  StatCard(number: '24/7', label: 'Support'),
                ],
              )
                  .animate(delay: 400.ms)
                  .fade(duration: 700.ms)
                  .slide(begin: const Offset(0, 0.2), duration: 700.ms),
            ],
          ),
        ),
      ),
    );
  }
}


