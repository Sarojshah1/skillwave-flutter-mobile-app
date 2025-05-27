import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:skillwave/config/themes/app_themes.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<String> _pageTitles = [
    'Dashboard',
    'Courses',
    'Blogs',
    'Profile',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          _pageTitles[_selectedIndex],
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 12,
        currentIndex: _selectedIndex,
        selectedItemColor: SkillWaveAppColors.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,

        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.bookOpenCheck), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Blogs'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

}
