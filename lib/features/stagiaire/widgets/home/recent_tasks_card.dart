// lib/features/stagiaire/widgets/home/recent_tasks_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/tache_model.dart';

class RecentTasksCard extends StatelessWidget {
  final List<TacheModel> taches;
  final VoidCallback?    onVoirTout;

  const RecentTasksCard({
    super.key,
    required this.taches,
    this.onVoirTout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primarySoft,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(Icons.checklist_rounded, size: 15, color: AppTheme.primary),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tâches récentes',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onVoirTout,
                  child: const Text(
                    'Voir tout →',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFFE2E8F0), height: 1),

          if (taches.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.checklist_rounded, color: Color(0xFF94A3B8), size: 22),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Aucune tâche récente',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            )
          else
            ...taches.asMap().entries.map((e) {
              final isLast = e.key == taches.length - 1;
              return Column(
                children: [
                  _TaskRow(tache: e.value),
                  if (!isLast)
                    const Divider(
                      color: Color(0xFFE2E8F0),
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final TacheModel tache;
  const _TaskRow({required this.tache});

  Color get _statutColor => switch (tache.statut) {
    TacheStatut.terminee => const Color(0xFF16A34A),
    TacheStatut.enCours  => AppTheme.primary,
    TacheStatut.aFaire   => const Color(0xFF94A3B8),
  };

  Color get _statutBg => switch (tache.statut) {
    TacheStatut.terminee => const Color(0xFFEAFAF0),
    TacheStatut.enCours  => AppTheme.primarySoft,
    TacheStatut.aFaire   => const Color(0xFFF1F5F9),
  };

  String get _statutLabel => switch (tache.statut) {
    TacheStatut.terminee => 'Terminé',
    TacheStatut.enCours  => 'En cours',
    TacheStatut.aFaire   => 'À faire',
  };

  String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      const mois = ['Jan','Fév','Mar','Avr','Mai','Juin','Juil','Août','Sep','Oct','Nov','Déc'];
      return '${d.day} ${mois[d.month - 1]}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = tache.statut == TacheStatut.terminee;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [

          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? AppTheme.primary : Colors.transparent,
              border: isDone
                  ? null
                  : Border.all(
                color: tache.statut == TacheStatut.enCours
                    ? AppTheme.primary
                    : const Color(0xFFCBD5E1),
                width: 2,
              ),
            ),
            child: isDone
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 13)
                : null,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tache.titre,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDone ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    decorationColor: const Color(0xFF94A3B8),
                  ),
                ),
                if (tache.description != null && tache.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    tache.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statutBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statutLabel,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: _statutColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(tache.dateEcheance),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}