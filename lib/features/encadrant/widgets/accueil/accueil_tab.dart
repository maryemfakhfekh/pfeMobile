// lib/features/encadrant/widgets/accueil/accueil_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_state.dart';
import '../../data/models/stagiaire_encadrant_model.dart';
import 'accueil_header.dart';
import 'accueil_kpi_grid.dart';
import 'accueil_progression_card.dart';
import 'accueil_retard_card.dart';
import 'accueil_activite_card.dart';

class AccueilTab extends StatelessWidget {
  final String prenom;
  final VoidCallback? onProfilTap;

  const AccueilTab({super.key, required this.prenom, this.onProfilTap});

  // ── Classifie les stagiaires selon leur progression ───────────────────
  static _Classification _classify(List<StagiaireEncadrantModel> list) {
    int ok = 0, warn = 0, retard = 0;
    final retardList = <StagiaireEncadrantModel>[];

    for (final s in list) {
      final pct = s.progressionGlobale;
      final hasRetard = s.tachesTotales > 0 &&
          (s.tachesTotales - s.tachesTerminees) > 0 &&
          pct < 0.35;

      if (hasRetard) {
        retard++;
        retardList.add(s);
      } else if (pct >= 0.6) {
        ok++;
      } else {
        warn++;
      }
    }

    return _Classification(
      enBonneVoie: ok,
      aSurveiller: warn,
      enRetard: retard,
      retardList: retardList,
    );
  }

  // ── Activités mockées — remplace par ton BLoC quand dispo ─────────────
  static List<ActiviteItem> _mockActivites() => const [
    ActiviteItem(
      icon: Icons.task_alt_rounded,
      iconColor: Color(0xFF0F6E56),
      iconBg: Color(0xFFE1F5EE),
      message: 'Rania Meddeb a soumis une tâche',
      sousTitre: 'Module Flutter encadrant',
      temps: 'Il y a 14 min',
    ),
    ActiviteItem(
      icon: Icons.upload_file_rounded,
      iconColor: Color(0xFF185FA5),
      iconBg: Color(0xFFE6F1FB),
      message: 'Samy Ben Salah a uploadé son rapport',
      sousTitre: 'Semaine 18',
      temps: 'Il y a 2h',
    ),
    ActiviteItem(
      icon: Icons.trending_up_rounded,
      iconColor: Color(0xFF3C3489),
      iconBg: Color(0xFFEEEDFE),
      message: 'Amine Khelil a atteint 95% de progression',
      sousTitre: 'Fin de stage dans 12 jours',
      temps: 'Il y a 5h',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const jours = ['Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];
    const mois  = ['Jan','Fév','Mar','Avr','Mai','Jun','Jul','Aoû','Sep','Oct','Nov','Déc'];
    final todayFormatted = '${jours[now.weekday - 1]} ${now.day} ${mois[now.month - 1]} ${now.year}';

    return BlocBuilder<EncadrantBloc, EncadrantState>(
      builder: (ctx, state) {
        final list  = state.stagiaires;
        final dash  = state.dashboard;
        final clsf  = _classify(list);

        final tachesActives  = list.fold(0, (s, x) => s + x.tachesTotales);
        final tachesTerminees = list.fold(0, (s, x) => s + x.tachesTerminees);
        final tachesEnRetard  = dash?.tachesEnAttente ?? 0;
        final notifCount      = clsf.retardList.length + tachesEnRetard;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // ── HEADER ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: AccueilHeader(
                prenom: prenom,
                date: todayFormatted,
                onProfilTap: onProfilTap,
                notifCount: notifCount,
              ),
            ),

            // ── KPI GRID ──────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              sliver: SliverToBoxAdapter(
                child: AccueilKpiGrid(
                  stagiairesActifs: list.length,
                  tachesActives: tachesActives - tachesTerminees,
                  tachesEnRetard: tachesEnRetard,
                  entretiensAVenir: 0,
                  evaluationsEnAttente: dash?.notificationsEnAttente ?? 0,
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 14)),

            // ── PROGRESSION GLOBALE ───────────────────────────────────
            if (list.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: AccueilProgressionCard(
                    enBonneVoie: clsf.enBonneVoie,
                    aSurveiller: clsf.aSurveiller,
                    enRetard: clsf.enRetard,
                    total: list.length,
                  ),
                ),
              ),

            const SliverPadding(padding: EdgeInsets.only(top: 14)),

            // ── STAGIAIRES EN RETARD ──────────────────────────────────
            if (clsf.retardList.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: AccueilRetardCard(stagiaires: clsf.retardList),
                ),
              ),

            if (clsf.retardList.isNotEmpty)
              const SliverPadding(padding: EdgeInsets.only(top: 14)),

            // ── ACTIVITÉ RÉCENTE ──────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: AccueilActiviteCard(activites: _mockActivites()),
              ),
            ),

            // ── Espace bottom nav ──────────────────────────────────────
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _Classification {
  final int enBonneVoie;
  final int aSurveiller;
  final int enRetard;
  final List<StagiaireEncadrantModel> retardList;

  const _Classification({
    required this.enBonneVoie,
    required this.aSurveiller,
    required this.enRetard,
    required this.retardList,
  });
}