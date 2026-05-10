import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';
import '../../data/models/tache_encadrant_model.dart';
import 'tache_detail_card.dart';

class TachesTabView extends StatelessWidget {
  final StagiaireEncadrantModel stagiaire;
  final List<TacheEncadrantModel> taches;
  const TachesTabView({super.key, required this.stagiaire, required this.taches});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      children: taches.isEmpty
          ? [const _EmptyTaches()]
          : taches.map((t) => TacheDetailCard(
        tache: t,
        stagiaireId: stagiaire.id,  // ✅ int → int
      )).toList(),
    );
  }
}

class _EmptyTaches extends StatelessWidget {
  const _EmptyTaches();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(top: 30),
    child: Center(
      child: Text('Aucune tâche créée',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppTheme.textSecond)),
    ),
  );
}