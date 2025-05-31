import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/theme_bloc/theme_bloc.dart';
import 'package:skillwave/features/SettingScreen/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/setting_widgets/section_card.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/setting_widgets/settings_dropdown_tile.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/setting_widgets/settings_navigation_tile.dart';
import 'package:skillwave/features/SettingScreen/presentation/widgets/setting_widgets/settings_switch_tile.dart';

@RoutePage()
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  void _loadThemePreference() {
    context.read<ThemeBloc>().add(LoadTheme());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            centerTitle: true,
            backgroundColor: SkillWaveAppColors.primary,
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SectionCard(children: [
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      bool isDarkMode = themeState is ThemeDark;

                      return SettingsSwitchTile(
                        title: 'Dark Mode',
                        subtitle: 'Toggle dark mode for better night-time reading',
                        value: isDarkMode,
                        onChanged: (value) {
                          context.read<ThemeBloc>().add(ToggleTheme());
                        },
                      );
                    },
                  ),
                  SettingsDropdownTile(
                    title: 'Language',
                    subtitle: 'Select your preferred language',
                    value: 'English',
                    items: const ['English', 'Spanish', 'French', 'German'],
                    onChanged: (value) {},
                  ),
                ]),
                const SizedBox(height: 16),
                SectionCard(children: [
                  SettingsNavigationTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage notifications',
                    onTap: () {},
                  ),
                  SettingsNavigationTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {},
                  ),
                  SettingsNavigationTile(
                    icon: Icons.security_outlined,
                    title: 'Security',
                    subtitle: 'Manage security settings',
                    onTap: () {},
                  ),
                  SettingsNavigationTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy',
                    subtitle: 'Privacy policy',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 16),
                SectionCard(children: [
                  SettingsNavigationTile(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    subtitle: 'Learn more about us',
                    onTap: () {
                      context.router.navigate(AboutUsRoute());
                    },
                  ),
                  SettingsNavigationTile(
                    icon: Icons.contact_mail_outlined,
                    title: 'Contact Us',
                    subtitle: 'Support and help',
                    onTap: () {},
                  ),
                  SettingsNavigationTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    iconColor: Colors.red,
                    onTap: () => _showLogoutDialog(context),
                  ),
                ]),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Confirm Logout',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                      context.read<LogoutBloc>().add(LogoutEventTriggered());
                    },
                    child: const Text('Logout'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
     context.replaceRoute(LoginRoute());
    }
  }
}

