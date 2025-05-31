import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF312E81), Color(0xFF6B21A8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Floating Circles
          Positioned(
            top: 80,
            left: 50,
            child: Circle(color: Colors.blue.shade400, size: 16, duration: 3.seconds),
          ),
          Positioned(
            top: 160,
            right: 80,
            child: Circle(color: Colors.purple.shade400, size: 24, duration: 4.seconds, delay: 1.seconds),
          ),
          Positioned(
            bottom: 160,
            left: 80,
            child: Circle(color: Colors.cyan.shade400, size: 12, duration: 2.5.seconds, delay: 2.seconds),
          ),

          // Main Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tagline
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 16, color: Colors.yellow.shade400),
                        const SizedBox(width: 6),
                        const Text(
                          'Empowering Future Leaders',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 800.ms),

                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'About SkillWave',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        foreground:  Paint()
                          ..shader = const LinearGradient(
                            colors: [Colors.white, Color(0xFFBFDBFE), Color(0xFFE9D5FF)],
                          ).createShader(const Rect.fromLTWH(0, 0, 400, 0)),
                      ),
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 800.ms).slideY(begin: 0.2),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Transforming education through innovation, community, and excellence. Join thousands of learners on their journey to success.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFBFDBFE),
                      height: 1.5,
                    ),
                  ).animate(delay: 400.ms).fadeIn(duration: 800.ms).slideY(begin: 0.2),

                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Get Started'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ).animate().scale(),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Watch Story'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                      ).animate().scale(),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // Scroll Indicator
                  Animate(
                    effects: [FadeEffect(delay: 1.5.seconds), MoveEffect(begin: Offset(0, 10), end: Offset(0, 0), duration: 2.seconds, curve: Curves.easeInOut)],
                    child: Container(
                      width: 24,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white38),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 4,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;
  final Duration? delay;

  const Circle({
    super.key,
    required this.color,
    required this.size,
    required this.duration,
    this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      delay: delay,
      effects: [
        MoveEffect(
          begin: Offset(0, 0),
          end: Offset(0, -20),
          duration: duration,
          curve: Curves.easeInOut,
        ),
        FadeEffect(
          duration: duration,
          curve: Curves.easeInOut,
          begin: 0.5,
          end: 1.0,

        ),
      ],
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
