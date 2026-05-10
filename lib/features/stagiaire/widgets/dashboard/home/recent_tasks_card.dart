import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';
import '../../stagiaire_ui_tokens.dart';

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
      decoration: StagiaireUiTokens.cardDecoration(),
      child: Column(
        children: [

          // ── Header ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.checklist_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tâches récentes',
                  style: StagiaireUiTokens.sectionTitle,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onVoirTout,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primarySoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                ),
              ],
            ),
          ),

          Container(height: 1, color: AppTheme.border),

          // ── Empty state ───────────────────────────────
          if (taches.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.checklist_rounded,
                      color: AppTheme.textLight,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Aucune tâche récente',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),

          // ── Liste tâches ──────────────────────────────
          ...taches.asMap().entries.map((e) {
            final i = e.key;
            final t = e.value;
            return Column(
              children: [
                _TaskRow(tache: t),
                if (i < taches.length - 1)
                  Container(
                    height: 1,
                    color: AppTheme.border,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
              ],
            );
          }),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ── Row tâche ──────────────────────────────────────────────────────

class _TaskRow extends StatelessWidget {
  final TacheModel tache;
  const _TaskRow({required this.tache});

  @override
  Widget build(BuildContext context) {
    final cfg    = _cfg(tache.statut);
    final isDone = tache.statut == TacheStatut.terminee;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [

          // ── Check circle ──────────────────────────────
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? AppTheme.primary : Colors.transparent,
              border: isDone
                  ? null
                  : Border.all(
                color: tache.statut == TacheStatut.enCours
                    ? AppTheme.primary
                    : AppTheme.border,
                width: 2,
              ),
            ),
            child: isDone
                ? const Icon(Icons.check_rounded,
                color: Colors.white, size: 13)
                : null,
          ),

          const SizedBox(width: 10),

          // ── Titre + description ───────────────────────
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
                    color: isDone
                        ? AppTheme.textLight
                        : AppTheme.textPrimary,
                    decoration: isDone
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: AppTheme.textLight,
                  ),
                ),
                if (tache.description != null &&
                    tache.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    tache.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: StagiaireUiTokens.cardSubtitle,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── Badge statut + date ───────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cfg.bg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  cfg.label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: cfg.color,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(tache.dateEcheance),
                style: StagiaireUiTokens.cardSubtitle.copyWith(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      const mois = [
        'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
        'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
      ];
      return '${d.day} ${mois[d.month - 1]}';
    } catch (_) {
      return dateStr;
    }
  }

  _Cfg _cfg(TacheStatut s) => switch (s) {
    TacheStatut.terminee => _Cfg(
        'Terminé', StagiaireUiTokens.done,
        StagiaireUiTokens.done.withOpacity(0.10)),
    TacheStatut.enCours  => const _Cfg(
        'En cours', AppTheme.primary, AppTheme.primarySoft),
    TacheStatut.aFaire   => _Cfg(
        'À faire', AppTheme.textSecond,
        AppTheme.textSecond.withOpacity(0.08)),
  };
}

class _Cfg {
  final String label;
  final Color  color, bg;
  const _Cfg(this.label, this.color, this.bg);
}