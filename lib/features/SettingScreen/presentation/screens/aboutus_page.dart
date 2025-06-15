
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/constants/app_assets.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/config/themes/styles/text_theme.dart';

@RoutePage()
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
                children: [
                  Container(
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(SkillWaveAppAssets.splash),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: size.height * 0.1,
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About Us',
                          style: TextStyle(
                            fontSize: size.width * 0.1,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'Empowering Learners for a Brighter Future',
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),),]),

            // Mission Section
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Mission',
                    style: skillWaveTextTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.03),
                  _buildMissionVisionCard(
                    context,
                    Icons.lightbulb,
                    'Our Mission',
                    'To provide high-quality, accessible education that empowers individuals to achieve their goals and excel in their careers. We deliver innovative learning experiences that are engaging, practical, and impactful.',
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Vision',
                    style: skillWaveTextTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.03),
                  _buildMissionVisionCard(
                    context,
                    Icons.star,
                    'Our Vision',
                    'To be a global leader in e-learning, fostering a community of motivated and knowledgeable learners who are equipped to make a difference in the world.',
                  ),
                ],
              ),
            ),

            // Team Section
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meet Our Team',
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Wrap(
                    spacing: size.width * 0.04,
                    runSpacing: size.height * 0.02,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildTeamMember(
                        'Saroj Kumar Sah',
                        'CEO & Founder',
                        'Saroj is a visionary leader with a passion for education and technology. He is dedicated to creating an inclusive learning environment that empowers students worldwide.',
                        SkillWaveAppAssets.user,
                      ),
                      _buildTeamMember(
                        'Saroj Kumar Sah',
                        'CTO',
                        'Saroj is a tech enthusiast with expertise in e-learning solutions. He drives innovation to enhance our platform\'s functionality and user experience.',
                        SkillWaveAppAssets.user,
                      ),
                      _buildTeamMember(
                        'Saroj Kumar Sah',
                        'Content Manager',
                        'Saroj curates and creates engaging content that resonates with learners. His goal is to ensure that our educational materials are relevant, up-to-date, and impactful.',
                        SkillWaveAppAssets.user,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Testimonials Section
            Container(
              padding: EdgeInsets.all(size.width * 0.04),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What Our Students Say',
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Column(
                    children: [
                      _buildTestimonial(
                        'Alex Johnson',
                        'Software Developer',
                        'This platform has transformed the way I learn. The courses are well-structured and engaging. Highly recommended!',
                      ),
                      SizedBox(height: size.height * 0.02),
                      _buildTestimonial(
                        'Sarah Lee',
                        'Marketing Specialist',
                        'An exceptional e-learning experience! The interactive content and expert instructors make learning enjoyable and effective.',
                      ),
                      SizedBox(height: size.height * 0.02),
                      _buildTestimonial(
                        'Michael Brown',
                        'Graphic Designer',
                        'The platform offers a variety of courses that cater to different learning styles. The support team is also very helpful.',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Achievements Section
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Achievements',
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Wrap(
                    spacing: size.width * 0.04,
                    runSpacing: size.height * 0.02,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildAchievement(
                        Icons.emoji_events,
                        '500+ Courses',
                        'We offer a diverse range of over 500 high-quality courses across various domains.',
                      ),
                      _buildAchievement(
                        Icons.emoji_events,
                        '100K+ Users',
                        'Our platform is trusted by over 100,000 learners around the world.',
                      ),
                      _buildAchievement(
                        Icons.emoji_events,
                        'Award-Winning',
                        'Recognized for excellence in e-learning with multiple industry awards.',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // FAQ Section
            Container(
              padding: EdgeInsets.all(size.width * 0.04),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.03),
                  _buildFAQ('How can I get started?', 'Getting started is easy! Click on the "Get Started" button at the top of the page, sign up, and explore our wide range of courses.'),
                  _buildFAQ('What is the cost of the courses?', 'We offer both free and paid courses. You can find detailed pricing information on each course page.'),
                  _buildFAQ('How do I contact support?', 'You can reach out to our support team through the "Contact Us" page or email us directly at support@skillwave.com.'),
                ],
              ),
            ),

            // Contact Section
            Container(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.05, horizontal: size.width * 0.05),
              color: Colors.blue[600],
              child: Column(
                children: [
                  Text(
                    'Get in Touch',
                    style: TextStyle(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'For any inquiries, please contact us at:',
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'info@skillwave.com',
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionVisionCard(BuildContext context, IconData icon, String title, String content) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Row(
          children: [
            Icon(icon, size: 40,),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: skillWaveTextTheme.headlineLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    content,
                    style: skillWaveTextTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String description, String imageUrl) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(imageUrl),
          ),
          SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            role,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTestimonial(String name, String role, String testimonial) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          children: [
            Text(
              '"$testimonial"',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '- $name',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              role,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievement(IconData icon, String title, String description) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.blue[600],
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ(String question, String answer) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              answer,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }
}