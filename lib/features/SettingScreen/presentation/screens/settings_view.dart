import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionCard(
            children: [
              _buildSwitchTile(
                context,
                title: 'Dark Mode',
                subtitle: 'Toggle dark mode for better night-time reading',
                value: false, // Replace with state from BLoC
                onChanged: (value) {
                  // Dispatch BLoC event to toggle dark mode
                },
              ),
              _buildDropdownTile(
                context,
                title: 'Language',
                subtitle: 'Select your preferred language',
                value: 'English', // Replace with state from BLoC
                items: ['English', 'Spanish', 'French', 'German'],
                onChanged: (value) {
                  // Dispatch BLoC event to change language
                },
              ),
            ],
          ),
          _buildSectionCard(
            children: [
              _buildNavigationTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage notifications',
                onTap: () {
                  // context.pushRoute(NotificationsRoute());
                },
              ),
              _buildNavigationTile(
                icon: Icons.lock,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  // context.pushRoute(ChangePasswordRoute());
                },
              ),
              _buildNavigationTile(
                icon: Icons.security,
                title: 'Security',
                subtitle: 'Manage security settings',
                onTap: () {
                  // context.pushRoute(SecurityRoute());
                },
              ),
              _buildNavigationTile(
                icon: Icons.privacy_tip,
                title: 'Privacy',
                subtitle: 'Privacy policy',
                onTap: () {
                  // context.pushRoute(PrivacyPolicyRoute());
                },
              ),
            ],
          ),
          _buildSectionCard(
            children: [
              _buildNavigationTile(
                icon: Icons.info,
                title: 'About Us',
                subtitle: 'Learn more about us',
                onTap: () {
                  // context.pushRoute(AboutUsRoute());
                },
              ),
              _buildNavigationTile(
                icon: Icons.contact_mail,
                title: 'Contact Us',
                subtitle: 'Support and help',
                onTap: () {
                  // context.pushRoute(ContactUsRoute());
                },
              ),
              _buildNavigationTile(
                icon: Icons.exit_to_app,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                iconColor: Colors.red,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
      BuildContext context, {
        required String title,
        required String subtitle,
        required bool value,
        required void Function(bool) onChanged,
      }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownTile(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String value,
        required List<String> items,
        required void Function(String?) onChanged,
      }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = Colors.purple,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      // Trigger logout via BLoC or clear shared prefs
      // Then navigate to login screen using auto_route
    }
  }
}
