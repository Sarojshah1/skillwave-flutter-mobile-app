import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  bool twoFactorAuth = false;
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool profileVisibility = false;
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

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
                    child: Text(
                      "Change",
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                _settingTile(
                  context,
                  title: "Two-Factor Authentication",
                  subtitle: "Add an extra layer of security",
                  trailing: FlutterSwitch(
                    value: twoFactorAuth,
                    onToggle: (val) => setState(() => twoFactorAuth = val),
                    height: 24,
                    width: 48,
                    activeColor: colorScheme.primary,
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
                    onToggle: (val) => setState(() => emailNotifications = val),
                    height: 24,
                    width: 48,
                    activeColor: colorScheme.primary,
                  ),
                ),
                _settingTile(
                  context,
                  title: "Push Notifications",
                  subtitle: "Get notified about new content",
                  trailing: FlutterSwitch(
                    value: pushNotifications,
                    onToggle: (val) => setState(() => pushNotifications = val),
                    height: 24,
                    width: 48,
                    activeColor: colorScheme.primary,
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
                    onToggle: (val) => setState(() => profileVisibility = val),
                    height: 24,
                    width: 48,
                    activeColor: colorScheme.primary,
                  ),
                ),
                _settingTile(
                  context,
                  title: "Show Progress",
                  subtitle: "Display course progress publicly",
                  trailing: FlutterSwitch(
                    value: showProgress,
                    onToggle: (val) => setState(() => showProgress = val),
                    height: 24,
                    width: 48,
                    activeColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
            _buildCard(
              context,
              icon: Icons.delete_outline,
              title: "Danger Zone",
              titleColor: colorScheme.error,
              borderColor: colorScheme.errorContainer.withOpacity(0.3),
              children: [
                _settingTile(
                  context,
                  title: "Delete Account",
                  subtitle: "Permanently delete your account and data",
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                  if (i != cards.length - 1) SizedBox(height: 16),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bgColor = theme.cardColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: titleColor ?? colorScheme.onSurface),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? colorScheme.onSurface,
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
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
