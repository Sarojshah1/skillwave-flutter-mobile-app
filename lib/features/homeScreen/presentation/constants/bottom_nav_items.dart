import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavItems {
  static const _pageTitles = [
    'Dashboard',
    'Courses',
    'Blogs',
    'Profile',
    'Settings',
  ];

  static const _icons = [
    Icons.home_filled,
    LucideIcons.bookOpenCheck,
    Icons.book_online,
    LucideIcons.user,
    Icons.settings,
  ];

  static final items = List<BottomNavigationBarItem>.generate(
    _pageTitles.length,
        (index) => BottomNavigationBarItem(
      icon: Icon(_icons[index]),
      label: _pageTitles[index],
    ),
  );
}
