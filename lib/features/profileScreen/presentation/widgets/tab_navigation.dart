import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class TabNavigation extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChange;

  const TabNavigation({super.key, required this.activeTab, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final tabs = {
      'info': Icons.info_outline,
      'courses': Icons.menu_book,
      'certificates': Icons.workspace_premium_outlined,
      'quizzes': Icons.quiz_outlined,
      'settings': Icons.settings_outlined,
    };

    return Container(
      color: isDarkMode? SkillWaveAppColors.blue_alpha:Colors.white,
      child: Row(
        children: tabs.entries.map((entry) {
          final selected = entry.key == activeTab;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTabChange(entry.key),
                splashColor: const Color(0xFF49BBBD).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Icon(entry.value, color: selected ? const Color(0xFF49BBBD) : Colors.grey),
                      const SizedBox(height: 4),
                      Text(
                        entry.key[0].toUpperCase() + entry.key.substring(1),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: selected ? const Color(0xFF49BBBD) : Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
