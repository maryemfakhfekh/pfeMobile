// lib/features/stagiaire/pages/stagiaire_dashboard_page.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_model.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/tabs/home_tab.dart';
import '../widgets/dashboard/tabs/taches_tab.dart';
import '../widgets/dashboard/tabs/rapport_tab.dart';
import '../widgets/dashboard/tabs/chat_tab.dart';
import '../widgets/dashboard/tabs/profil_tab.dart';

class StaigaireDashboardPage extends StatefulWidget {
  final StagiaireModel dossier;
  const StaigaireDashboardPage({super.key, required this.dossier});

  @override
  State<StaigaireDashboardPage> createState() =>
      _StaigaireDashboardPageState();
}

class _StaigaireDashboardPageState
    extends State<StaigaireDashboardPage> {
  int _currentIndex = 0;

  bool get _showHeader =>
      _currentIndex == 0 || _currentIndex == 4;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      HomeTab(
        dossier:      widget.dossier,
        onGoToTaches: () => setState(() => _currentIndex = 1),
        onGoToChat:   () => setState(() => _currentIndex = 3),
      ),
      const TachesTab(),
      const RapportTab(),
      ChatTab(dossier: widget.dossier),
      ProfilTab(dossier: widget.dossier),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (_showHeader)
              DashboardHeader(
                dossier:     widget.dossier,
                onProfilTap: () =>
                    setState(() => _currentIndex = 4),
                notifCount:  0, // ← à connecter si notifs réelles
              ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: tabs,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_outlined,
                  Icons.home_rounded, 'Accueil'),
              _navItem(1, Icons.checklist_outlined,
                  Icons.checklist_rounded, 'Tâches'),
              _navItem(2, Icons.description_outlined,
                  Icons.description_rounded, 'Rapport'),
              _navItem(3, Icons.chat_bubble_outline_rounded,
                  Icons.chat_bubble_rounded, 'Chat'),
              _navItem(4, Icons.person_outline_rounded,
                  Icons.person_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon,
      String label) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey<bool>(isActive),
                color: isActive
                    ? AppTheme.primary
                    : AppTheme.textLight,
                size: 21,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: isActive
                    ? AppTheme.primary
                    : AppTheme.textLight,
                fontSize: 10,
                fontWeight: isActive
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}