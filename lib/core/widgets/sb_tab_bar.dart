import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SbTabBarItem {
  const SbTabBarItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
}

class SbTabBar extends StatelessWidget {
  const SbTabBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<SbTabBarItem> items = [
    SbTabBarItem(
      label: 'Accueil',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      route: '/app/home',
    ),
    SbTabBarItem(
      label: 'Grossesse',
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      route: '/app/tracking',
    ),
    SbTabBarItem(
      label: 'Rendez-vous',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today_rounded,
      route: '/app/appointments',
    ),
    SbTabBarItem(
      label: 'Bébé',
      icon: Icons.child_care_outlined,
      activeIcon: Icons.child_care_rounded,
      route: '/app/baby',
    ),
    SbTabBarItem(
      label: 'Profil',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      route: '/app/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark
        ? AppColors.darkCard.withValues(alpha: 0.95)
        : Colors.white.withValues(alpha: 0.95);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final activeColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final inactiveColor = isDark
        ? AppColors.darkMutedForeground
        : AppColors.mutedForeground;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              final color = isSelected ? activeColor : inactiveColor;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        size: 22,
                        color: color,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
