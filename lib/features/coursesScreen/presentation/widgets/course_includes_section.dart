import 'package:flutter/material.dart';

class CourseIncludesSection extends StatelessWidget {
  const CourseIncludesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF8B5CF6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'What You\'ll Get',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  // color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildIncludeItem(
            icon: Icons.video_library,
            iconColor: const Color(0xFF2563EB),
            title: 'HD Video Lectures',
            subtitle: 'Access to all course videos in high quality',
          ),
          const SizedBox(height: 16),

          _buildIncludeItem(
            icon: Icons.article,
            iconColor: const Color(0xFF10B981),
            title: 'Course Materials',
            subtitle: 'Downloadable resources and study guides',
          ),
          const SizedBox(height: 16),

          _buildIncludeItem(
            icon: Icons.quiz,
            iconColor: const Color(0xFFF59E0B),
            title: 'Quizzes & Assessments',
            subtitle: 'Test your knowledge with interactive quizzes',
          ),
          const SizedBox(height: 16),

          _buildIncludeItem(
            icon: Icons.school,
            iconColor: const Color(0xFF8B5CF6),
            title: 'Certificate of Completion',
            subtitle: 'Earn a certificate upon course completion',
          ),
          const SizedBox(height: 16),

          _buildIncludeItem(
            icon: Icons.support_agent,
            iconColor: const Color(0xFFEF4444),
            title: '24/7 Support',
            subtitle: 'Get help whenever you need it',
          ),
        ],
      ),
    );
  }

  Widget _buildIncludeItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
