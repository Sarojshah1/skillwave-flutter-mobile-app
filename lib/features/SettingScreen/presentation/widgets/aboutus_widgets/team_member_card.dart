import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:skillwave/features/SettingScreen/data/model/team_member.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/social_icon_button.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMember member;
  final int index;

  const TeamMemberCard({super.key, required this.member, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                // Profile image + online dot
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        member.imagePath,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green[500],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  member.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.role,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.blue[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  member.intro,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),

                // Skills chips
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: member.skills
                      .map(
                        (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFDBEAFE),
                            Color(0xFFEDE9FE),
                          ],
                        ),
                      ),
                      child: Text(
                        skill,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF3730A3),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Social Icons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIconButton(icon: EvaIcons.linkedin),
                    const SizedBox(width: 12),
                    SocialIconButton(icon: EvaIcons.email),
                    const SizedBox(width: 12),
                    SocialIconButton(icon: EvaIcons.phone_call),
                  ],
                )
              ],
            ),
          ),
        ),
      )
          .animate(delay: Duration(milliseconds: 200 * index))
          .fade(duration: 700.ms)
          .slide(begin: const Offset(0, 0.2), duration: 700.ms)
          .scale(begin: Offset(0.1, 0.9), duration: 700.ms),
    );
  }
}