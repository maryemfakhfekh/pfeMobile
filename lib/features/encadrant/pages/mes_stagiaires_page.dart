// lib/features/encadrant/pages/mes_stagiaires_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../logic/encadrant_bloc.dart';
import '../logic/encadrant_event.dart';
import '../logic/encadrant_state.dart';
import '../widgets/mes_stagiaires/index.dart';

@RoutePage()
class MesStagiairesPage extends StatefulWidget {
  const MesStagiairesPage({super.key});

  @override
  State<MesStagiairesPage> createState() => _MesStagiairesPageState();
}

class _MesStagiairesPageState extends State<MesStagiairesPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<EncadrantBloc>().add(EncadrantStagiairesRequested());
  }

  List<StagiaireEncadrantModel> _filter(
      List<StagiaireEncadrantModel> stagiaires) {
    if (_searchQuery.isEmpty) return stagiaires;
    return stagiaires
        .where((s) =>
    s.nomComplet
        .toLowerCase()
        .contains(_searchQuery.toLowerCase()) ||
        s.sujetTitre
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocBuilder<EncadrantBloc, EncadrantState>(
          builder: (context, state) {
            final stagiaires = state.stagiaires;
            final filtered = _filter(stagiaires);

            // Stats calculées
            final avgProg = stagiaires.isEmpty
                ? 0
                : (stagiaires.fold(
                0.0, (s, x) => s + x.progressionGlobale) /
                stagiaires.length *
                100)
                .toInt();
            final terminees =
            stagiaires.fold(0, (s, x) => s + x.tachesTerminees);
            final aFaire = stagiaires.fold(
                0, (s, x) => s + (x.tachesTotales - x.tachesTerminees));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────
                StagiairesHeader(count: stagiaires.length),

                // ── Stats 3 cards ────────────────────
                StagiairesStatsRow(
                  avgProg: avgProg,
                  terminees: terminees,
                  aFaire: aFaire,
                ),

                // ── Recherche ────────────────────────
                StagiairesSearchBar(
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),

                // ── Liste ou état vide ────────────────
                Expanded(
                  child: filtered.isEmpty
                      ? const StagiairesEmpty()
                      : ListView.builder(
                    padding:
                    const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) =>
                        StagiaireCard(stagiaire: filtered[i]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}