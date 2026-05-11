// lib/features/stagiaire/widgets/home/home_content.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/stagiaire_model.dart';
import '../../data/models/tache_model.dart';
import '../../logic/tache_bloc.dart';
import 'stage_card.dart';
import 'mini_stats_row.dart';
import 'weekly_activity_card.dart';
import 'recent_tasks_card.dart';
import 'encadrant_card.dart';

class HomeContent extends StatelessWidget {
  final StagiaireModel dossier;
  final VoidCallback?  onGoToTaches;
  final VoidCallback?  onGoToChat;

  const HomeContent({
    super.key,
    required this.dossier,
    this.onGoToTaches,
    this.onGoToChat,
  });

  List<int> _buildWeekActivity(List<TacheModel> taches) {
    final now    = DateTime.now();
    final counts = List<int>.filled(7, 0);
    for (final t in taches) {
      final due = DateTime.tryParse(t.dateEcheance);
      if (due == null) continue;
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek   = startOfWeek.add(const Duration(days: 6));
      if (due.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          due.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        final dayIndex = due.weekday - 1;
        if (dayIndex >= 0 && dayIndex < 7) counts[dayIndex]++;
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TacheBloc, TacheState>(
      builder: (context, state) {
        final taches = state is TacheLoaded ? state.taches : <TacheModel>[];

        final terminees    = taches.where((t) => t.statut == TacheStatut.terminee).length;
        final enCours      = taches.where((t) => t.statut == TacheStatut.enCours).length;
        final aFaire       = taches.where((t) => t.statut == TacheStatut.aFaire).length;
        final total        = taches.length;
        final progression  = total > 0 ? terminees / total : 0.0;
        final weekActivity = _buildWeekActivity(taches);
        final recentTaches = taches.length > 3 ? taches.sublist(taches.length - 3) : taches;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  StageCard(
                    dossier:     dossier,
                    progression: progression,
                    terminees:   terminees,
                    total:       total,
                  ),
                  const SizedBox(height: 10),

                  MiniStatsRow(
                    terminees: terminees,
                    enCours:   enCours,
                    aFaire:    aFaire,
                    total:     total,
                  ),
                  const SizedBox(height: 10),

                  WeeklyActivityCard(
                    values: weekActivity,
                    total:  total,
                  ),
                  const SizedBox(height: 10),

                  RecentTasksCard(
                    taches:     recentTaches,
                    onVoirTout: onGoToTaches,
                  ),
                  const SizedBox(height: 10),

                  EncadrantCard(
                    encadrant: dossier.encadrant,
                    onChatTap: onGoToChat,
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}