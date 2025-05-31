import 'package:flutter/material.dart';
import 'package:skillwave/features/SettingScreen/data/model/stat.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/cta_buttons.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/floating_dots.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/aboutus_widgets/stats_grid.dart';


class CTASection extends StatelessWidget {
  const CTASection({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      Stat(icon: Icons.group, number: '50K+', label: 'Active Students'),
      Stat(icon: Icons.book_outlined, number: '500+', label: 'Courses'),
      Stat(icon: Icons.emoji_events, number: '95%', label: 'Success Rate'),
      Stat(icon: Icons.star, number: '24/7', label: 'Support'),
    ];

    return Stack(
      children: [
        Container(
          height: 600,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1e3a8a), Color(0xff4c1d95), Color(0xff7e22ce)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const Positioned(top: 80, left: 80, child: FloatingDot(color: Color(0x664fb3f6), size: 24, verticalMovement: 20, duration: Duration(seconds: 4), delay: Duration.zero)),
        const Positioned(top: 160, right: 120, child: FloatingDot(color: Color(0x664f46e5), size: 16, verticalMovement: 30, duration: Duration(seconds: 3), delay: Duration(seconds: 1))),
        const Positioned(bottom: 140, left: 160, child: FloatingDot(color: Color(0x3340e0d0), size: 32, verticalMovement: 25, duration: Duration(seconds: 5), delay: Duration(seconds: 2))),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Join the Revolution', style: TextStyle(color: Colors.yellow[400], fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                    children: [
                      const TextSpan(text: 'Ready to Transform\n'),
                      TextSpan(
                        text: 'Your Future?',
                        style: TextStyle(
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: <Color>[Colors.blue.shade400, Colors.purple.shade400, Colors.pink.shade400],
                            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Join thousands of learners who have already transformed their careers with SkillWave. Start your journey today and unlock unlimited possibilities.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xffbfdbfe), fontSize: 20),
                ),
                const SizedBox(height: 32),
                StatsGrid(stats: stats),
                const SizedBox(height: 32),
                const CTAButtons(),
                // You can add TrustedBy widget similarly
              ],
            ),
          ),
        )
      ],
    );
  }
}
