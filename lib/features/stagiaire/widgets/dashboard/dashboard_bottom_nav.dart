// lib/features/stagiaire/widgets/dashboard/dashboard_bottom_nav.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DashboardBottomNav extends StatelessWidget {
  final int           currentIndex;
  final ValueChanged<int> onTap;

  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(index: 0, current: currentIndex, icon: Icons.home_outlined,             activeIcon: Icons.home_rounded,             label: 'Accueil', onTap: onTap),
              _NavItem(index: 1, current: currentIndex, icon: Icons.checklist_outlined,        activeIcon: Icons.checklist_rounded,        label: 'Tâches',  onTap: onTap),
              _NavItem(index: 2, current: currentIndex, icon: Icons.description_outlined,      activeIcon: Icons.description_rounded,      label: 'Rapport', onTap: onTap),
              _NavItem(index: 3, current: currentIndex, icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded,    label: 'Chat',    onTap: onTap),
              _NavItem(index: 4, current: currentIndex, icon: Icons.person_outline_rounded,    activeIcon: Icons.person_rounded,           label: 'Profil',  onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int              index;
  final int              current;
  final IconData         icon;
  final IconData         activeIcon;
  final String           label;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.current,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = current == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 44,
            height: 30,
            decoration: BoxDecoration(
              color: sel
                  ? AppTheme.primary.withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Icon(
                sel ? activeIcon : icon,
                color: sel ? AppTheme.primary : const Color(0xFFCBD5E1),
                size: 19,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9,
              fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
              color: sel ? AppTheme.primary : const Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }
}