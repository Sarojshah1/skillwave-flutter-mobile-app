import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';

@RoutePage()
class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _profileVisibility = true;
  bool _showEmail = false;
  bool _showPhone = false;
  bool _allowMessages = true;
  bool _allowComments = true;
  bool _dataCollection = true;
  bool _analytics = true;
  bool _personalizedAds = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Privacy',
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
                      Icons.privacy_tip,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Privacy Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Control how your information is shared and used',
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
                  // Profile Privacy
                  _buildSettingsCard(
                    title: 'Profile Privacy',
                    icon: Icons.person,
                    children: [
                      _buildSwitchTile(
                        title: 'Profile Visibility',
                        subtitle: 'Make your profile visible to other users',
                        value: _profileVisibility,
                        onChanged: (value) =>
                            setState(() => _profileVisibility = value),
                      ),
                      _buildSwitchTile(
                        title: 'Show Email',
                        subtitle: 'Display your email on your profile',
                        value: _showEmail,
                        onChanged: (value) =>
                            setState(() => _showEmail = value),
                      ),
                      _buildSwitchTile(
                        title: 'Show Phone',
                        subtitle: 'Display your phone number on your profile',
                        value: _showPhone,
                        onChanged: (value) =>
                            setState(() => _showPhone = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Communication Privacy
                  _buildSettingsCard(
                    title: 'Communication',
                    icon: Icons.chat,
                    children: [
                      _buildSwitchTile(
                        title: 'Allow Messages',
                        subtitle: 'Let other users send you messages',
                        value: _allowMessages,
                        onChanged: (value) =>
                            setState(() => _allowMessages = value),
                      ),
                      _buildSwitchTile(
                        title: 'Allow Comments',
                        subtitle: 'Let others comment on your posts',
                        value: _allowComments,
                        onChanged: (value) =>
                            setState(() => _allowComments = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Data & Analytics
                  _buildSettingsCard(
                    title: 'Data & Analytics',
                    icon: Icons.analytics,
                    children: [
                      _buildSwitchTile(
                        title: 'Data Collection',
                        subtitle:
                            'Allow us to collect usage data to improve the app',
                        value: _dataCollection,
                        onChanged: (value) =>
                            setState(() => _dataCollection = value),
                      ),
                      _buildSwitchTile(
                        title: 'Analytics',
                        subtitle:
                            'Help us improve by sharing anonymous usage data',
                        value: _analytics,
                        onChanged: (value) =>
                            setState(() => _analytics = value),
                      ),
                      _buildSwitchTile(
                        title: 'Personalized Ads',
                        subtitle: 'Show ads based on your interests',
                        value: _personalizedAds,
                        onChanged: (value) =>
                            setState(() => _personalizedAds = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Privacy Controls
                  _buildSettingsCard(
                    title: 'Privacy Controls',
                    icon: Icons.settings,
                    children: [
                      _buildNavigationTile(
                        title: 'Blocked Users',
                        subtitle: 'Manage users you have blocked',
                        icon: Icons.block,
                        onTap: () {
                          // Navigate to blocked users
                        },
                      ),
                      _buildNavigationTile(
                        title: 'Download My Data',
                        subtitle: 'Get a copy of your personal data',
                        icon: Icons.download,
                        onTap: () {
                          // Navigate to data download
                        },
                      ),
                      _buildNavigationTile(
                        title: 'Delete My Data',
                        subtitle: 'Request deletion of your personal data',
                        icon: Icons.delete_forever,
                        onTap: () {
                          _showDeleteDataDialog();
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Privacy Policy & Terms
                  _buildSettingsCard(
                    title: 'Legal',
                    icon: Icons.description,
                    children: [
                      _buildNavigationTile(
                        title: 'Privacy Policy',
                        subtitle: 'Read our privacy policy',
                        icon: Icons.privacy_tip,
                        onTap: () {
                          // Navigate to privacy policy
                        },
                      ),
                      _buildNavigationTile(
                        title: 'Terms of Service',
                        subtitle: 'Read our terms of service',
                        icon: Icons.description,
                        onTap: () {
                          // Navigate to terms of service
                        },
                      ),
                      _buildNavigationTile(
                        title: 'Cookie Policy',
                        subtitle: 'Learn about our use of cookies',
                        icon: Icons.cookie,
                        onTap: () {
                          // Navigate to cookie policy
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Privacy Status
                  Container(
                    padding: const EdgeInsets.all(20),
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: SkillWaveAppColors.success,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.shield,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Privacy Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildPrivacyItem(
                          title: 'Profile Privacy',
                          status: _profileVisibility ? 'Public' : 'Private',
                          statusColor: _profileVisibility
                              ? Colors.orange
                              : SkillWaveAppColors.success,
                        ),
                        _buildPrivacyItem(
                          title: 'Data Collection',
                          status: _dataCollection ? 'Enabled' : 'Disabled',
                          statusColor: _dataCollection
                              ? Colors.orange
                              : SkillWaveAppColors.success,
                        ),
                        _buildPrivacyItem(
                          title: 'Personalized Ads',
                          status: _personalizedAds ? 'Enabled' : 'Disabled',
                          statusColor: _personalizedAds
                              ? Colors.orange
                              : SkillWaveAppColors.success,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Save privacy preferences
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Privacy settings saved!'),
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
                        'Save Privacy Settings',
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

  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withValues(alpha: 0.1)
                    : SkillWaveAppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : SkillWaveAppColors.primary,
                size: 20,
              ),
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
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? Colors.red : Colors.black87,
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
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyItem({
    required String title,
    required String status,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Personal Data'),
        content: const Text(
          'Are you sure you want to request deletion of your personal data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle data deletion request
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
