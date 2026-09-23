import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';
import '../services/services_screen.dart';
import 'home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const ServicesScreen(),
      HistoryScreen(
        onExploreServices: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,

      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'Home',
                  selected: _selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
              ),

              Expanded(
                child: _BottomNavItem(
                  icon: Icons.grid_view_rounded,
                  selectedIcon: Icons.grid_view_rounded,
                  label: 'Services',
                  selected: _selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ),

              Expanded(
                child: _BottomNavItem(
                  icon: Icons.bar_chart_outlined,
                  selectedIcon: Icons.bar_chart_rounded,
                  label: 'History',
                  selected: _selectedIndex == 2,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
              ),

              Expanded(
                child: _BottomNavItem(
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: 'Profile',
                  selected: _selectedIndex == 3,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: 56,
            height: 52,
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected ? selectedIcon : icon,
                  size: 23,
                  color: selected
                      ? AppConstants.orangeColor
                      : Colors.white.withValues(alpha: 0.78),
                ),
                const SizedBox(height: 2),
                if (selected)
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textDark,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}