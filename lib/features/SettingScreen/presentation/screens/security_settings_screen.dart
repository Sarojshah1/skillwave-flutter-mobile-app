import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

@RoutePage()
class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometricEnabled = false;
  bool _twoFactorAuth = false;
  bool _loginNotifications = true;
  bool _deviceManagement = true;
  bool _sessionTimeout = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Security',
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
                      Icons.security,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Security Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Protect your account with advanced security features',
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
                  // Authentication
                  _buildSettingsCard(
                    title: 'Authentication',
                    icon: Icons.fingerprint,
                    children: [
                      _buildSwitchTile(
                        title: 'Biometric Login',
                        subtitle: 'Use fingerprint or face ID to login',
                        value: _biometricEnabled,
                        onChanged: (value) =>
                            setState(() => _biometricEnabled = value),
                      ),
                      _buildSwitchTile(
                        title: 'Two-Factor Authentication',
                        subtitle: 'Add an extra layer of security',
                        value: _twoFactorAuth,
                        onChanged: (value) =>
                            setState(() => _twoFactorAuth = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Login Security
                  _buildSettingsCard(
                    title: 'Login Security',
                    icon: Icons.login,
                    children: [
                      _buildSwitchTile(
                        title: 'Login Notifications',
                        subtitle: 'Get notified of new login attempts',
                        value: _loginNotifications,
                        onChanged: (value) =>
                            setState(() => _loginNotifications = value),
                      ),
                      _buildSwitchTile(
                        title: 'Session Timeout',
                        subtitle: 'Automatically logout after inactivity',
                        value: _sessionTimeout,
                        onChanged: (value) =>
                            setState(() => _sessionTimeout = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Device Management
                  _buildSettingsCard(
                    title: 'Device Management',
                    icon: Icons.devices,
                    children: [
                      _buildSwitchTile(
                        title: 'Device Management',
                        subtitle: 'Manage your logged-in devices',
                        value: _deviceManagement,
                        onChanged: (value) =>
                            setState(() => _deviceManagement = value),
                      ),
                      _buildNavigationTile(
                        title: 'Active Sessions',
                        subtitle: 'View and manage active sessions',
                        icon: Icons.computer,
                        onTap: () {
                          // Navigate to active sessions
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Password & Recovery
                  _buildSettingsCard(
                    title: 'Password & Recovery',
                    icon: Icons.lock_reset,
                    children: [
                      _buildNavigationTile(
                        title: 'Change Password',
                        subtitle: 'Update your account password',
                        icon: Icons.password,
                        onTap: () {
                          // Navigate to change password
                        },
                      ),
                      _buildNavigationTile(
                        title: 'Recovery Email',
                        subtitle: 'Manage recovery email address',
                        icon: Icons.email,
                        onTap: () {
                          // Navigate to recovery email settings
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Privacy & Data
                  _buildSettingsCard(
                    title: 'Privacy & Data',
                    icon: Icons.privacy_tip,
                    children: [
                      _buildNavigationTile(
                        title: 'Data Export',
                        subtitle: 'Download your personal data',
                        icon: Icons.download,
                        onTap: () {
                          // Navigate to data export
                        },
                      ),
                      _buildNavigationTile(
                        title: 'Account Deletion',
                        subtitle: 'Permanently delete your account',
                        icon: Icons.delete_forever,
                        onTap: () {
                          _showDeleteAccountDialog();
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Security Status
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
                              'Security Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSecurityItem(
                          title: 'Password Strength',
                          status: 'Strong',
                          statusColor: SkillWaveAppColors.success,
                        ),
                        _buildSecurityItem(
                          title: 'Two-Factor Auth',
                          status: _twoFactorAuth ? 'Enabled' : 'Disabled',
                          statusColor: _twoFactorAuth
                              ? SkillWaveAppColors.success
                              : Colors.orange,
                        ),
                        _buildSecurityItem(
                          title: 'Login Notifications',
                          status: _loginNotifications ? 'Enabled' : 'Disabled',
                          statusColor: _loginNotifications
                              ? SkillWaveAppColors.success
                              : Colors.orange,
                        ),
                      ],
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

  Widget _buildSecurityItem({
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
