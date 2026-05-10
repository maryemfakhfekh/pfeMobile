import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DetailTabBar extends StatelessWidget {
  final TabController controller;

  const DetailTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppTheme.textDark,
        unselectedLabelColor: AppTheme.textLight,
        labelPadding: EdgeInsets.zero,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          _Tab(icon: Icons.checklist_rounded,        label: 'Tâches'),
          _Tab(icon: Icons.description_outlined,     label: 'Rapport'),
          _Tab(icon: Icons.person_outline_rounded,   label: 'Infos'),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Tab({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}