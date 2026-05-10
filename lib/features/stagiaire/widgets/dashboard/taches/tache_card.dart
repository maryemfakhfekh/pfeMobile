// lib/features/stagiaire/widgets/dashboard/taches/tache_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';

class TacheCard extends StatelessWidget {
  final TacheModel tache;
  final VoidCallback? onTap;
  final bool isDetailed;
  final void Function(TacheStatut)? onStatutChange;

  const TacheCard({
    super.key,
    required this.tache,
    this.onTap,
    this.isDetailed = true,
    this.onStatutChange,
  });

  // ── Priorité ──────────────────────────────────────────
  Color get _prioriteColor => switch (tache.priorite) {
    TachePriorite.basse    => AppTheme.success,
    TachePriorite.moyenne  => AppTheme.warning,
    TachePriorite.haute    => AppTheme.primary,
    TachePriorite.critique => AppTheme.error,
  };

  Color get _prioriteBg => switch (tache.priorite) {
    TachePriorite.basse    => AppTheme.successSoft,
    TachePriorite.moyenne  => const Color(0xFFFFFBEB),
    TachePriorite.haute    => AppTheme.primarySoft,
    TachePriorite.critique => const Color(0xFFFEF2F2),
  };

  String get _prioriteLabel => switch (tache.priorite) {
    TachePriorite.basse    => 'BASSE',
    TachePriorite.moyenne  => 'MOYENNE',
    TachePriorite.haute    => 'HAUTE',
    TachePriorite.critique => 'CRITIQUE',
  };

  IconData get _prioriteIcon => switch (tache.priorite) {
    TachePriorite.basse    => Icons.arrow_downward_rounded,
    TachePriorite.moyenne  => Icons.remove_rounded,
    TachePriorite.haute    => Icons.arrow_upward_rounded,
    TachePriorite.critique => Icons.priority_high_rounded,
  };

  // ── Statut ────────────────────────────────────────────
  ({String label, Color color, Color bg}) get _statutCfg =>
      switch (tache.statut) {
        TacheStatut.aFaire => (
        label: 'À FAIRE',
        color: AppTheme.textSecond,
        bg:    AppTheme.background,
        ),
        TacheStatut.enCours => (
        label: 'EN COURS',
        color: AppTheme.primary,
        bg:    AppTheme.primarySoft,
        ),
        TacheStatut.terminee => (
        label: 'DONE',
        color: AppTheme.success,
        bg:    AppTheme.successSoft,
        ),
      };

  bool get _isOverdue {
    if (tache.statut == TacheStatut.terminee) return false;
    final due = DateTime.tryParse(tache.dateEcheance);
    return due != null && due.isBefore(DateTime.now());
  }

  String get _dateLabel {
    final due = DateTime.tryParse(tache.dateEcheance);
    if (due == null) return tache.dateEcheance;
    final now = DateTime.now();
    if (due.year == now.year &&
        due.month == now.month &&
        due.day == now.day) {
      return "Aujourd'hui";
    }
    const mois = [
      'jan.', 'fév.', 'mar.', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sep.', 'oct.', 'nov.', 'déc.'
    ];
    return '${due.day} ${mois[due.month - 1]}';
  }

  @override
  Widget build(BuildContext context) =>
      isDetailed ? _buildDetailed(context) : _buildListRow(context);

  // ── VUE DÉTAILLÉE ─────────────────────────────────────
  Widget _buildDetailed(BuildContext context) {
    final isDone = tache.statut == TacheStatut.terminee;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Ligne 1 : check + issueKey + priorité + statut ──
            Row(
              children: [

                // Checkbox rond style Asana
                GestureDetector(
                  onTap: () => onStatutChange?.call(
                    isDone ? TacheStatut.aFaire : TacheStatut.terminee,
                  ),
                  child: Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? AppTheme.primary : Colors.transparent,
                      border: isDone
                          ? null
                          : Border.all(
                        color: tache.statut == TacheStatut.enCours
                            ? AppTheme.primary
                            : const Color(0xFFD1D5DB),
                        width: 2,
                      ),
                    ),
                    child: isDone
                        ? const Icon(Icons.check_rounded,
                        size: 13, color: Colors.white)
                        : null,
                  ),
                ),

                const SizedBox(width: 10),

                // Issue key
                Text(
                  tache.issueKey,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLight,
                  ),
                ),

                const SizedBox(width: 8),

                // Badge priorité
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: _prioriteBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_prioriteIcon, size: 10, color: _prioriteColor),
                      const SizedBox(width: 3),
                      Text(
                        _prioriteLabel,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: _prioriteColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Badge statut cliquable
                GestureDetector(
                  onTap: () => _showStatutMenu(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statutCfg.bg,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      _statutCfg.label,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: _statutCfg.color,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Ligne 2 : titre ───────────────────────────
            Text(
              tache.titre,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isDone ? AppTheme.textLight : AppTheme.textPrimary,
                decoration: isDone ? TextDecoration.lineThrough : null,
                decorationColor: AppTheme.textLight,
              ),
            ),

            // Description
            if (tache.description != null) ...[
              const SizedBox(height: 4),
              Text(
                tache.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppTheme.textSecond,
                  height: 1.5,
                ),
              ),
            ],

            const SizedBox(height: 10),

            // ── Ligne 3 : date échéance ────────────────────
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 11,
                  color: _isOverdue ? AppTheme.error : AppTheme.textLight,
                ),
                const SizedBox(width: 4),
                Text(
                  _dateLabel,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: _isOverdue ? AppTheme.error : AppTheme.textLight,
                    fontWeight: _isOverdue
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                if (_isOverdue) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'En retard',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── VUE LISTE ─────────────────────────────────────────
  Widget _buildListRow(BuildContext context) {
    final isDone = tache.statut == TacheStatut.terminee;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [

            // Checkbox
            GestureDetector(
              onTap: () => onStatutChange?.call(
                isDone ? TacheStatut.aFaire : TacheStatut.terminee,
              ),
              child: Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppTheme.primary : Colors.transparent,
                  border: isDone
                      ? null
                      : Border.all(
                    color: tache.statut == TacheStatut.enCours
                        ? AppTheme.primary
                        : const Color(0xFFD1D5DB),
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check_rounded,
                    size: 12, color: Colors.white)
                    : null,
              ),
            ),

            const SizedBox(width: 10),

            // Titre
            Expanded(
              flex: 5,
              child: Text(
                tache.titre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDone ? AppTheme.textLight : AppTheme.textPrimary,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  decorationColor: AppTheme.textLight,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Priorité icône
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: _prioriteBg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(_prioriteIcon, size: 14, color: _prioriteColor),
            ),

            const SizedBox(width: 8),

            // Badge statut
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: _statutCfg.bg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                _statutCfg.label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: _statutCfg.color,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom sheet statut ───────────────────────────────
  void _showStatutMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(22))),
      // ✅ CORRIGÉ : 'sheetCtx' au lieu de '_' pour pouvoir
      // appeler Navigator.pop(sheetCtx) et fermer le bon widget
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Changer le statut',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _statBtn(sheetCtx, TacheStatut.aFaire,   'À faire'),
                const SizedBox(width: 8),
                _statBtn(sheetCtx, TacheStatut.enCours,  'En cours'),
                const SizedBox(width: 8),
                _statBtn(sheetCtx, TacheStatut.terminee, 'Terminée'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ CORRIGÉ : reçoit 'sheetCtx' pour fermer le bon contexte
  Widget _statBtn(BuildContext sheetCtx, TacheStatut statut, String label) {
    final isActive = tache.statut == statut;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onStatutChange?.call(statut);
          Navigator.pop(sheetCtx); // ✅ ferme le bottom sheet correctement
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.textPrimary : AppTheme.background,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: isActive ? Colors.white : AppTheme.textSecond,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}