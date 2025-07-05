import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';

@RoutePage()
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Hero Header
          SliverAppBar(
            expandedHeight: size.height * 0.4,
            floating: false,
            pinned: true,
            backgroundColor: SkillWaveAppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Background Image with Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(SkillWaveAppAssets.splash),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    bottom: 60,
                    left: 24,
                    right: 24,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'About SkillWave',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Empowering Learners for a Brighter Future',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.router.pop(),
            ),
          ),

          // Content Sections
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Mission & Vision Section
                  _buildSectionCard(
                    title: 'Our Mission & Vision',
                    icon: Icons.lightbulb,
                    children: [
                      _buildMissionVisionCard(
                        icon: Icons.rocket_launch,
                        title: 'Our Mission',
                        content:
                            'To provide high-quality, accessible education that empowers individuals to achieve their goals and excel in their careers. We deliver innovative learning experiences that are engaging, practical, and impactful.',
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      _buildMissionVisionCard(
                        icon: Icons.star,
                        title: 'Our Vision',
                        content:
                            'To be a global leader in e-learning, fostering a community of motivated and knowledgeable learners who are equipped to make a difference in the world.',
                        color: Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Team Section
                  _buildSectionCard(
                    title: 'Meet Our Team',
                    icon: Icons.people,
                    children: [_buildTeamGrid()],
                  ),

                  const SizedBox(height: 24),

                  // Achievements Section
                  _buildSectionCard(
                    title: 'Our Achievements',
                    icon: Icons.emoji_events,
                    children: [_buildAchievementsGrid()],
                  ),

                  const SizedBox(height: 24),

                  // Testimonials Section
                  _buildSectionCard(
                    title: 'What Our Students Say',
                    icon: Icons.rate_review,
                    children: [_buildTestimonialsList()],
                  ),

                  const SizedBox(height: 24),

                  // FAQ Section
                  _buildSectionCard(
                    title: 'Frequently Asked Questions',
                    icon: Icons.help,
                    children: [_buildFAQList()],
                  ),

                  const SizedBox(height: 32),

                  // Contact Section
                  _buildContactSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: SkillWaveAppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildMissionVisionCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamGrid() {
    final teamMembers = [
      {
        'name': 'Saroj Kumar Sah',
        'role': 'CEO & Founder',
        'description':
            'Visionary leader with a passion for education and technology.',
        'image': SkillWaveAppAssets.user,
      },
      {
        'name': 'Saroj Kumar Sah',
        'role': 'CTO',
        'description':
            'Tech enthusiast with expertise in e-learning solutions.',
        'image': SkillWaveAppAssets.user,
      },
      {
        'name': 'Saroj Kumar Sah',
        'role': 'Content Manager',
        'description': 'Curates engaging content that resonates with learners.',
        'image': SkillWaveAppAssets.user,
      },
    ];

    return Column(
      children: teamMembers.map((member) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildTeamMemberCard(
            name: member['name']!,
            role: member['role']!,
            description: member['description']!,
            imageUrl: member['image']!,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTeamMemberCard({
    required String name,
    required String role,
    required String description,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 25, backgroundImage: AssetImage(imageUrl)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    color: SkillWaveAppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid() {
    final achievements = [
      {
        'icon': Icons.school,
        'title': '500+ Courses',
        'description': 'Diverse range of high-quality courses',
        'color': Colors.blue,
      },
      {
        'icon': Icons.people,
        'title': '100K+ Users',
        'description': 'Trusted by learners worldwide',
        'color': Colors.green,
      },
      {
        'icon': Icons.emoji_events,
        'title': 'Award-Winning',
        'description': 'Recognized for excellence',
        'color': Colors.orange,
      },
    ];

    return Column(
      children: achievements.map((achievement) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildAchievementCard(
            icon: achievement['icon'] as IconData,
            title: achievement['title'] as String,
            description: achievement['description'] as String,
            color: achievement['color'] as Color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAchievementCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsList() {
    final testimonials = [
      {
        'name': 'Alex Johnson',
        'role': 'Software Developer',
        'testimonial':
            'This platform has transformed the way I learn. The courses are well-structured and engaging. Highly recommended!',
      },
      {
        'name': 'Sarah Lee',
        'role': 'Marketing Specialist',
        'testimonial':
            'An exceptional e-learning experience! The interactive content and expert instructors make learning enjoyable and effective.',
      },
      {
        'name': 'Michael Brown',
        'role': 'Graphic Designer',
        'testimonial':
            'The platform offers a variety of courses that cater to different learning styles. The support team is also very helpful.',
      },
    ];

    return Column(
      children: testimonials.map((testimonial) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildTestimonialCard(
            name: testimonial['name']!,
            role: testimonial['role']!,
            testimonial: testimonial['testimonial']!,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTestimonialCard({
    required String name,
    required String role,
    required String testimonial,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote,
            size: 32,
            color: SkillWaveAppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            '"$testimonial"',
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: SkillWaveAppColors.primary,
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    role,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList() {
    final faqs = [
      {
        'question': 'How can I get started?',
        'answer':
            'Getting started is easy! Click on the "Get Started" button at the top of the page, sign up, and explore our wide range of courses.',
      },
      {
        'question': 'What is the cost of the courses?',
        'answer':
            'We offer both free and paid courses. You can find detailed pricing information on each course page.',
      },
      {
        'question': 'How do I contact support?',
        'answer':
            'You can reach out to our support team through the "Contact Us" page or email us directly at support@skillwave.com.',
      },
    ];

    return Column(
      children: faqs.map((faq) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildFAQCard(
            question: faq['question']!,
            answer: faq['answer']!,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFAQCard({required String question, required String answer}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            SkillWaveAppColors.primary,
            SkillWaveAppColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.contact_support,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Get in Touch',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'For any inquiries, please contact us at:',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'info@skillwave.com',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
