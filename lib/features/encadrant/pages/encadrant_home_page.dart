import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../logic/encadrant_bloc.dart';
import '../logic/encadrant_event.dart';
import '../widgets/accueil/accueil_tab.dart';
import '../widgets/mes_stagiaires/stagiaires_tab.dart';
import '../widgets/chat/messages_tab.dart';
import '../widgets/taches/taches_tab.dart';
import '../widgets/candidatures/candidatures_tab.dart';
import '../pages/evaluation_page.dart';
import '../widgets/profile/profil_tab.dart';

@RoutePage()
class EncadrantHomePage extends StatefulWidget {
  const EncadrantHomePage({super.key});

  @override
  State<EncadrantHomePage> createState() => _EncadrantHomePageState();
}

class _EncadrantHomePageState extends State<EncadrantHomePage> {
  int _index = 0;
  String _nomComplet = '';

  @override
  void initState() {
    super.initState();
    _loadNom();
    context.read<EncadrantBloc>()
      ..add(EncadrantDashboardRequested())
      ..add(EncadrantStagiairesRequested());
  }

  Future<void> _loadNom() async {
    final storage = const FlutterSecureStorage();
    final nom    = await storage.read(key: 'nom')    ?? '';
    final prenom = await storage.read(key: 'prenom') ?? '';
    if (mounted) setState(() => _nomComplet = '$nom $prenom'.trim());
  }

  String get _prenom {
    final p = _nomComplet.trim().split(' ');
    return p.isNotEmpty ? p.first : _nomComplet;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // ✅ gris très léger
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          AccueilTab(
              prenom: _prenom,
              onProfilTap: () => setState(() => _index = 6)),
          const StagiairesTab(),
          const TachesTab(),
          const CandidaturesTab(),
          const EvaluationPage(),
          const MessagesTab(),
          ProfilTab(nomComplet: _nomComplet),
        ],
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _bottomNav() {
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
              _navItem(0, Icons.home_outlined,
                  Icons.home_rounded, 'Accueil'),
              _navItem(1, Icons.badge_outlined,
                  Icons.badge_rounded, 'Stagiaires'),
              _navItem(2, Icons.checklist_outlined,
                  Icons.checklist_rounded, 'Tâches'),
              _navItem(3, Icons.people_outline_rounded,
                  Icons.people_rounded, 'Candidats'),
              _navItem(4, Icons.star_outline_rounded,
                  Icons.star_rounded, 'Éval.'),
              _navItem(5, Icons.chat_bubble_outline_rounded,
                  Icons.chat_bubble_rounded, 'Messages'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData icon, IconData activeIcon, String lbl) {
    final sel = _index == i;
    return GestureDetector(
      onTap: () => setState(() => _index = i),
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
                color: sel
                    ? AppTheme.primary
                    : const Color(0xFFCBD5E1),
                size: 19,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            lbl,
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