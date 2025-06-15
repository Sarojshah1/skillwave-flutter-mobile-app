import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  // State variables for switches
  bool twoFactorAuth = false;
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool profileVisibility = false;
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          final cards = [
            _buildCard(
              context,
              icon: Icons.lock_outline,
              title: "Security",
              children: [
                _settingTile(
                  context,
                  title: "Change Password",
                  subtitle: "Update your account password",
                  trailing: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Change"),
                  ),
                ),
                _settingTile(
                  context,
                  title: "Two-Factor Authentication",
                  subtitle: "Add an extra layer of security",
                  trailing: FlutterSwitch(
                    value: twoFactorAuth,
                    onToggle: (val) {
                      setState(() {
                        twoFactorAuth = val;
                      });
                    },
                    height: 24,
                    width: 48,
                  ),
                ),
              ],
            ),
            _buildCard(
              context,
              icon: Icons.notifications_none_outlined,
              title: "Notifications",
              children: [
                _settingTile(
                  context,
                  title: "Email Notifications",
                  subtitle: "Receive course updates via email",
                  trailing: FlutterSwitch(
                    value: emailNotifications,
                    onToggle: (val) {
                      setState(() {
                        emailNotifications = val;
                      });
                    },
                    height: 24,
                    width: 48,
                  ),
                ),
                _settingTile(
                  context,
                  title: "Push Notifications",
                  subtitle: "Get notified about new content",
                  trailing: FlutterSwitch(
                    value: pushNotifications,
                    onToggle: (val) {
                      setState(() {
                        pushNotifications = val;
                      });
                    },
                    height: 24,
                    width: 48,
                  ),
                ),
              ],
            ),
            _buildCard(
              context,
              icon: Icons.shield_outlined,
              title: "Privacy",
              children: [
                _settingTile(
                  context,
                  title: "Profile Visibility",
                  subtitle: "Make your profile public",
                  trailing: FlutterSwitch(
                    value: profileVisibility,
                    onToggle: (val) {
                      setState(() {
                        profileVisibility = val;
                      });
                    },
                    height: 24,
                    width: 48,
                  ),
                ),
                _settingTile(
                  context,
                  title: "Show Progress",
                  subtitle: "Display course progress publicly",
                  trailing: FlutterSwitch(
                    value: showProgress,
                    onToggle: (val) {
                      setState(() {
                        showProgress = val;
                      });
                    },
                    height: 24,
                    width: 48,
                  ),
                ),
              ],
            ),
            _buildCard(
              context,
              icon: Icons.delete_outline,
              title: "Danger Zone",
              titleColor: Colors.red,
              borderColor: Colors.red.shade100,
              children: [
                _settingTile(
                  context,
                  title: "Delete Account",
                  subtitle: "Permanently delete your account and data",
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {},
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ];

          if (isWide) {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2,
              ),
              itemCount: cards.length,
              itemBuilder: (_, index) => cards[index],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  cards[i],
                  if (i != cards.length - 1) const SizedBox(height: 16),
                ],
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required List<Widget> children,
        Color? titleColor,
        Color? borderColor,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: titleColor ?? Colors.black),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: titleColor ?? Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _settingTile(
      BuildContext context, {
        required String title,
        required String subtitle,
        required Widget trailing,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          trailing,
        ],
      ),
    );
  }
}
