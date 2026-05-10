import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/tache_encadrant_model.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_event.dart';

class TacheDetailCard extends StatelessWidget {
  final TacheEncadrantModel tache;
  final int stagiaireId;  // ✅ int
  const TacheDetailCard({
    super.key,
    required this.tache,
    required this.stagiaireId,
  });

  String get _dateStr {
    if (tache.dateEcheance == null) return '';
    final d = tache.dateEcheance!;
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String _label(StatutTacheEncadrant s) => switch (s) {
    StatutTacheEncadrant.termine => 'Terminé',
    StatutTacheEncadrant.enCours => 'En cours',
    StatutTacheEncadrant.aFaire  => 'À faire',
  };

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG)),
        title: const Text('Supprimer',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 16,
                fontWeight: FontWeight.w800, color: AppTheme.textDark)),
        content: Text('Supprimer "${tache.titre}" ?',
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler',
                  style: TextStyle(color: AppTheme.dark))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<EncadrantBloc>().add(EncadrantTacheDeleted(
                  stagiaireId: stagiaireId, tacheId: tache.id));  // ✅ int
            },
            child: const Text('Supprimer',
                style: TextStyle(
                    color: AppTheme.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        boxShadow: AppTheme.shadowSM,
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppTheme.darkSoft,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          child: const Icon(Icons.task_alt_rounded,
              color: AppTheme.dark, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tache.titre,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppTheme.textDark,
                      decoration: tache.statut == StatutTacheEncadrant.termine
                          ? TextDecoration.lineThrough : null)),
              if (_dateStr.isNotEmpty) ...[
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 10, color: AppTheme.textLight),
                  const SizedBox(width: 4),
                  Text(_dateStr,
                      style: Theme.of(context).textTheme.labelSmall),
                ]),
              ],
            ],
          ),
        ),
        _StatutBadge(label: _label(tache.statut)),
        const SizedBox(width: 6),
        _DeleteButton(onTap: () => _confirmDelete(context)),
      ]),
    );
  }
}

class _StatutBadge extends StatelessWidget {
  final String label;
  const _StatutBadge({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppTheme.darkSoft,
      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      border: Border.all(color: AppTheme.border),
    ),
    child: Text(label,
        style: const TextStyle(
            fontFamily: 'Poppins', fontSize: 10,
            fontWeight: FontWeight.w700, color: AppTheme.dark)),
  );
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DeleteButton({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      ),
      child: const Icon(Icons.delete_outline_rounded,
          color: AppTheme.error, size: 14),
    ),
  );
}