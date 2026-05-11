// lib/features/stagiaire/pages/stagiaire_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../data/models/stagiaire_model.dart';
import '../data/models/tache_model.dart';
import '../logic/stagiaire_bloc.dart';
import '../logic/tache_bloc.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/dashboard_bottom_nav.dart';
import '../widgets/dashboard/notif_sheet.dart';
import '../widgets/home/home_content.dart';
import '../pages/taches_page.dart';
import '../pages/rapport_page.dart';
import '../pages/chat_page.dart';
import '../pages/profil_page.dart';

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

  bool get _showHeader => _currentIndex == 0 || _currentIndex == 4;

  StagiaireModel _resolveDossier(StagiaireState state) => switch (state) {
    StagiaireLoaded()   => state.dossier,
    ProfilUpdating()    => state.dossier,
    ProfilUpdated()     => state.dossier,
    ProfilUpdateError() => state.dossier,
    _                   => widget.dossier,
  };

  int _computeNotifCount(List<TacheModel> taches) {
    final now           = DateTime.now();
    final seuilNouvelle = now.subtract(const Duration(days: 3));
    final seen          = <int>{};
    int count           = 0;

    for (final t in taches) {
      if (t.statut != TacheStatut.terminee) {
        final due = DateTime.tryParse(t.dateEcheance);
        if (due != null && due.isBefore(now) && !seen.contains(t.id)) {
          seen.add(t.id);
          count++;
        }
      }
      if (t.dateCreation != null) {
        final created = DateTime.tryParse(t.dateCreation!);
        if (created != null &&
            created.isAfter(seuilNouvelle) &&
            !seen.contains(t.id)) {
          seen.add(t.id);
          count++;
        }
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TacheBloc>()..add(LoadTaches()),
      child: BlocBuilder<StagiaireBloc, StagiaireState>(
        builder: (context, stagiaireState) {
          final dossier = _resolveDossier(stagiaireState);

          return BlocBuilder<TacheBloc, TacheState>(
            builder: (context, tacheState) {
              final taches = tacheState is TacheLoaded
                  ? tacheState.taches
                  : <TacheModel>[];
              final notifCount = _computeNotifCount(taches);

              final List<Widget> pages = [
                HomeContent(
                  dossier:      dossier,
                  onGoToTaches: () => setState(() => _currentIndex = 1),
                  onGoToChat:   () => setState(() => _currentIndex = 3),
                ),
                const TachesPage(),
                const RapportPage(),
                ChatPage(dossier: dossier),
                ProfilPage(dossier: dossier),
              ];

              return Scaffold(
                backgroundColor: Colors.white,
                extendBody: false,
                body: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      if (_showHeader)
                        DashboardHeader(
                          dossier:     dossier,
                          onProfilTap: () => setState(() => _currentIndex = 4),
                          notifCount:  notifCount,
                          onNotifTap:  () => NotifSheet.show(context, taches),
                        ),
                      Expanded(
                        child: IndexedStack(
                          index: _currentIndex,
                          children: pages,
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: DashboardBottomNav(
                  currentIndex: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                ),
              );
            },
          );
        },
      ),
    );
  }
}