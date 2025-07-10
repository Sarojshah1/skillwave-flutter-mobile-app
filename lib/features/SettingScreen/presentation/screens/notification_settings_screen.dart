import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

@RoutePage()
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _courseUpdates = true;
  bool _newComments = true;
  bool _replies = true;
  bool _achievements = true;
  bool _weeklyDigest = false;
  bool _marketingEmails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [SkillWaveAppColors.primary, SkillWaveAppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    SkillWaveAppColors.primary,
                    SkillWaveAppColors.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                      Icons.notifications_active,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Notification Preferences',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Customize how you receive notifications',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Settings Sections
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // General Notifications
                  _buildSettingsCard(
                    title: 'General Notifications',
                    icon: Icons.settings,
                    children: [
                      _buildSwitchTile(
                        title: 'Push Notifications',
                        subtitle: 'Receive notifications on your device',
                        value: _pushNotifications,
                        onChanged: (value) =>
                            setState(() => _pushNotifications = value),
                      ),
                      _buildSwitchTile(
                        title: 'Email Notifications',
                        subtitle: 'Receive notifications via email',
                        value: _emailNotifications,
                        onChanged: (value) =>
                            setState(() => _emailNotifications = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Course Updates
                  _buildSettingsCard(
                    title: 'Course Updates',
                    icon: Icons.school,
                    children: [
                      _buildSwitchTile(
                        title: 'New Course Content',
                        subtitle: 'Get notified when new content is added',
                        value: _courseUpdates,
                        onChanged: (value) =>
                            setState(() => _courseUpdates = value),
                      ),
                      _buildSwitchTile(
                        title: 'Course Reminders',
                        subtitle: 'Reminders for incomplete courses',
                        value: _courseUpdates,
                        onChanged: (value) =>
                            setState(() => _courseUpdates = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Social Interactions
                  _buildSettingsCard(
                    title: 'Social Interactions',
                    icon: Icons.people,
                    children: [
                      _buildSwitchTile(
                        title: 'New Comments',
                        subtitle: 'When someone comments on your posts',
                        value: _newComments,
                        onChanged: (value) =>
                            setState(() => _newComments = value),
                      ),
                      _buildSwitchTile(
                        title: 'Replies',
                        subtitle: 'When someone replies to your comments',
                        value: _replies,
                        onChanged: (value) => setState(() => _replies = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Achievements & Progress
                  _buildSettingsCard(
                    title: 'Achievements & Progress',
                    icon: Icons.emoji_events,
                    children: [
                      _buildSwitchTile(
                        title: 'Achievements',
                        subtitle: 'When you earn new badges or certificates',
                        value: _achievements,
                        onChanged: (value) =>
                            setState(() => _achievements = value),
                      ),
                      _buildSwitchTile(
                        title: 'Progress Updates',
                        subtitle: 'Weekly progress summaries',
                        value: _weeklyDigest,
                        onChanged: (value) =>
                            setState(() => _weeklyDigest = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Marketing & Updates
                  _buildSettingsCard(
                    title: 'Marketing & Updates',
                    icon: Icons.campaign,
                    children: [
                      _buildSwitchTile(
                        title: 'Marketing Emails',
                        subtitle: 'Receive promotional content and offers',
                        value: _marketingEmails,
                        onChanged: (value) =>
                            setState(() => _marketingEmails = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Save notification preferences
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification preferences saved!'),
                            backgroundColor: SkillWaveAppColors.success,
                          ),
                        );
                        context.router.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SkillWaveAppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Save Preferences',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SkillWaveAppColors.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: SkillWaveAppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Content
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: SkillWaveAppColors.primary,
            activeTrackColor: SkillWaveAppColors.primary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
