import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';
import '../../stagiaire_ui_tokens.dart';

class TaskListCard extends StatelessWidget {
  final List<TacheModel> taches;
  const TaskListCard({super.key, required this.taches});

  @override
  Widget build(BuildContext context) {
    if (taches.isEmpty) {
      return Container(
        decoration: StagiaireUiTokens.cardDecoration(),
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: Text(
            'Aucune tâche pour le moment',
            style: TextStyle(color: AppTheme.textLight),
          ),
        ),
      );
    }

    return Container(
      decoration: StagiaireUiTokens.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Text(
              'Mes tâches',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const Divider(height: 20, thickness: 0.5, color: AppTheme.border),
          ...taches.take(3).map((tache) => _TaskItem(tache: tache)),
          if (taches.length > 3)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Voir toutes mes tâches'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final TacheModel tache;
  const _TaskItem({required this.tache});

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    if (tache.statut == TacheStatut.terminee) {
      progress = 1.0;
    } else if (tache.statut == TacheStatut.enCours) progress = 0.5;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  tache.titre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecond,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.border,
              color: AppTheme.primary,
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Statut: ${tache.statut.name}', // au lieu de sousTaches
            style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
          ),
        ],
      ),
    );
  }
}