import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:collection/collection.dart'; // For mapIndexed

class AchievementStat {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> gradient;
  final List<Color> bgGradient;

  AchievementStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
    required this.bgGradient,
  });
}

final stats = [
  AchievementStat(
    icon: LucideIcons.users,
    label: "Active Learners",
    value: "50K+",
    gradient: [Colors.blue, Colors.cyan],
    bgGradient: [Colors.blue.withOpacity(0.1), Colors.cyan.withOpacity(0.1)],
  ),
  AchievementStat(
    icon: LucideIcons.graduationCap,
    label: "Expert Mentors",
    value: "1K+",
    gradient: [Colors.green, Colors.teal],
    bgGradient: [Colors.green.withOpacity(0.1), Colors.teal.withOpacity(0.1)],
  ),
  AchievementStat(
    icon: LucideIcons.award,
    label: "Industry Awards",
    value: "15+",
    gradient: [Colors.yellow, Colors.orange],
    bgGradient: [Colors.yellow.withOpacity(0.1), Colors.orange.withOpacity(0.1)],
  ),
  AchievementStat(
    icon: LucideIcons.globe,
    label: "Countries Served",
    value: "25+",
    gradient: [Colors.purple, Colors.pink],
    bgGradient: [Colors.purple.withOpacity(0.1), Colors.pink.withOpacity(0.1)],
  ),
  AchievementStat(
    icon: LucideIcons.trendingUp,
    label: "Course Completion",
    value: "94%",
    gradient: [Colors.indigo, Colors.blue],
    bgGradient: [Colors.indigo.withOpacity(0.1), Colors.blue.withOpacity(0.1)],
  ),
  AchievementStat(
    icon: LucideIcons.star,
    label: "Average Rating",
    value: "4.9",
    gradient: [Colors.pinkAccent, Colors.redAccent],
    bgGradient: [Colors.pink.withOpacity(0.1), Colors.red.withOpacity(0.1)],
  ),
];

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final cardWidth = isWide ? 250.0 : constraints.maxWidth * 0.9;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xfff8fafc), Color(0xffebf5ff)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Animate(
                effects: [FadeEffect(duration: 800.ms), MoveEffect(
                  begin: Offset(0, 30),
                  end: Offset.zero,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                )],
                child: Column(
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffe0f2fe), Color(0xffede9fe)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(LucideIcons.trendingUp,
                              size: 16, color: Colors.blue),
                          SizedBox(width: 6),
                          Text("Our Impact",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Achievements That Matter",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Numbers that reflect our commitment to educational excellence and global impact",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Stats Grid
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: stats.mapIndexed((index, stat) {
                  return Animate(
                    delay: (index * 100).ms,
                    effects: [FadeEffect(duration: 600.ms), MoveEffect(
                      begin: Offset(0, 30),
                      end: Offset.zero,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    )],
                    child: GestureDetector(
                      onTap: () {},
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: cardWidth,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: stat.bgGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: cardWidth,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 12,
                                      color: Colors.black12.withOpacity(0.1),
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: stat.gradient,
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(stat.icon,
                                          color: Colors.white, size: 30),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(stat.value,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(stat.label,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        )),
                                    Container(
                                      height: 4,
                                      width: 40,
                                      margin: const EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: stat.gradient,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              // Featured Section
              Animate(
                effects: [FadeEffect(duration: 800.ms), MoveEffect(
                  begin: Offset(0, 30),
                  end: Offset.zero,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                )],
                delay: 400.ms,
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    {
                      "title": "Featured in TechCrunch",
                      "desc": "Recognized as a leading EdTech innovator"
                    },
                    {
                      "title": "ISO 27001 Certified",
                      "desc": "Highest standards of data security"
                    },
                    {
                      "title": "Carbon Neutral Platform",
                      "desc": "Committed to environmental sustainability"
                    },
                  ].map((e) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: cardWidth,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                e['title']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                e['desc']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
