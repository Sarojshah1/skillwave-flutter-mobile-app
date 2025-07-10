import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';

class CourseOverviewSection extends StatelessWidget {
  final CourseEntity course;

  const CourseOverviewSection({super.key, required this.course});

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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.info_outline, size: 24),
              ),
              const SizedBox(width: 16),
              const Text(
                'Course Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildInfoRow(
            icon: Icons.access_time,
            iconColor: const Color(0xFF10B981),
            title: 'Duration',
            value: course.duration,
          ),
          const SizedBox(height: 16),

          _buildInfoRow(
            icon: Icons.trending_up,
            iconColor: const Color(0xFFF59E0B),
            title: 'Level',
            value: course.level,
          ),
          const SizedBox(height: 16),

          _buildInfoRow(
            icon: Icons.person,
            iconColor: const Color(0xFF8B5CF6),
            title: 'Instructor',
            value: course.createdBy.name,
          ),
          const SizedBox(height: 16),

          _buildInfoRow(
            icon: Icons.calendar_today,
            iconColor: const Color(0xFFEF4444),
            title: 'Created',
            value: DateFormat('MMM dd, yyyy').format(course.createdAt),
          ),
          const SizedBox(height: 16),

          _buildInfoRow(
            icon: Icons.video_library,
            iconColor: const Color(0xFF06B6D4),
            title: 'Lessons',
            value: '${course.lessons.length} lessons',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
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
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
