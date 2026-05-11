// lib/features/encadrant/widgets/accueil/accueil_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_event.dart';
import '../../logic/encadrant_state.dart';
import '../../data/models/stagiaire_encadrant_model.dart';
import '../../data/models/tache_encadrant_model.dart';
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

  // ── Construit les activités réelles depuis le state ───────────────────
  static List<ActiviteItem> _buildActivites(EncadrantState state) {
    final items = <_ActiviteRaw>[];

    // ── Tâches terminées / en cours ────────────────────────────────────
    for (final entry in state.tachesByStagiaire.entries) {
      final stagiaireId = entry.key;
      final stagiaire = state.stagiaires.firstWhere(
            (s) => s.id == stagiaireId,
        orElse: () => state.stagiaires.isNotEmpty
            ? state.stagiaires.first
            : null as StagiaireEncadrantModel,
      );
      if (stagiaire == null) continue;

      for (final tache in entry.value) {
        if (tache.statut == StatutTacheEncadrant.termine) {
          items.add(_ActiviteRaw(
            icon: Icons.task_alt_rounded,
            iconColor: const Color(0xFF0F6E56),
            iconBg: const Color(0xFFE1F5EE),
            message: '${stagiaire.nomComplet} a terminé une tâche',
            sousTitre: tache.titre,
            dateRef: tache.dateEcheance,
          ));
        } else if (tache.statut == StatutTacheEncadrant.enCours) {
          items.add(_ActiviteRaw(
            icon: Icons.timelapse_rounded,
            iconColor: const Color(0xFF3C3489),
            iconBg: const Color(0xFFEEEDFE),
            message: '${stagiaire.nomComplet} a démarré une tâche',
            sousTitre: tache.titre,
            dateRef: tache.dateEcheance,
          ));
        }
      }
    }

    // ── Candidatures EN_ENTRETIEN ──────────────────────────────────────
    for (final c in state.candidatures) {
      if (c.statut == 'EN_ENTRETIEN') {
        final dateRef = c.dateEntretien != null
            ? DateTime.tryParse(c.dateEntretien!)
            : null;
        items.add(_ActiviteRaw(
          icon: Icons.check_circle_outline_rounded,
          iconColor: const Color(0xFF854F0B),
          iconBg: const Color(0xFFFAEEDA),
          message: 'Entretien à marquer réalisé',
          sousTitre: '${c.nomComplet} · ${c.sujetTitre}',
          dateRef: dateRef,
        ));
      }
    }

    // ── Stagiaires à fort taux de progression ──────────────────────────
    for (final s in state.stagiaires) {
      if (s.progressionGlobale >= 0.9) {
        items.add(_ActiviteRaw(
          icon: Icons.trending_up_rounded,
          iconColor: const Color(0xFF185FA5),
          iconBg: const Color(0xFFE6F1FB),
          message:
          '${s.nomComplet} a atteint ${(s.progressionGlobale * 100).round()}%',
          sousTitre: s.sujetTitre,
          dateRef: null,
        ));
      }
    }

    if (items.isEmpty) return const [];

    items.sort((a, b) {
      if (a.dateRef == null && b.dateRef == null) return 0;
      if (a.dateRef == null) return 1;
      if (b.dateRef == null) return -1;
      return b.dateRef!.compareTo(a.dateRef!);
    });

    return items.take(5).map((r) => ActiviteItem(
      icon: r.icon,
      iconColor: r.iconColor,
      iconBg: r.iconBg,
      message: r.message,
      sousTitre: r.sousTitre,
      temps: r.dateRef != null ? _formatTemps(r.dateRef!) : 'Récemment',
    )).toList();
  }

  static String _formatTemps(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays == 1) return 'Il y a 1 jour';
    return 'Il y a ${diff.inDays} jours';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const jours = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi',
      'Vendredi', 'Samedi', 'Dimanche'
    ];
    const mois = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
      'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    final todayFormatted =
        '${jours[now.weekday - 1]} ${now.day} ${mois[now.month - 1]} ${now.year}';

    return BlocConsumer<EncadrantBloc, EncadrantState>(
      listenWhen: (prev, curr) =>
      prev.stagiaires.isEmpty && curr.stagiaires.isNotEmpty,
      listener: (ctx, state) {
        for (final s in state.stagiaires) {
          ctx.read<EncadrantBloc>().add(EncadrantTachesRequested(s.id));
        }
      },
      builder: (ctx, state) {
        final list  = state.stagiaires;
        final dash  = state.dashboard;
        final clsf  = _classify(list);

        final tachesActives   = list.fold(0, (s, x) => s + x.tachesTotales);
        final tachesTerminees = list.fold(0, (s, x) => s + x.tachesTerminees);
        final tachesEnRetard  = dash?.tachesEnAttente ?? 0;

        final entretiensAVenir = state.candidatures
            .where((c) => c.statut == 'EN_ENTRETIEN')
            .length;

        final activites = _buildActivites(state);

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            // ── HEADER ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: AccueilHeader(
                prenom: prenom,
                date: todayFormatted,
                onProfilTap: onProfilTap,
              ),
            ),

            // ── LOADING INDICATOR ─────────────────────────────────────
            if (state.isLoading)
              const SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 12),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFD4650A),
                      ),
                    ),
                  ),
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
                  entretiensAVenir: entretiensAVenir,
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

            if (list.isNotEmpty)
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
            if (activites.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: AccueilActiviteCard(activites: activites),
                ),
              ),

            // ── État vide ─────────────────────────────────────────────
            if (!state.isLoading && list.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFE2E8F0), width: 0.8),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.people_outline_rounded,
                            size: 36, color: Color(0xFFCBD5E1)),
                        SizedBox(height: 10),
                        Text(
                          'Aucun stagiaire assigné',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Vos stagiaires apparaîtront ici\nune fois assignés par le RH.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
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

// ─────────────────────────────────────────────────────────────────────────────
class _ActiviteRaw {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String message;
  final String sousTitre;
  final DateTime? dateRef;

  const _ActiviteRaw({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.message,
    required this.sousTitre,
    this.dateRef,
  });
}