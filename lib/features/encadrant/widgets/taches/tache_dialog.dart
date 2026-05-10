// lib/features/encadrant/widgets/taches/tache_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';
import '../../data/models/tache_encadrant_model.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_event.dart';

class TacheDialog extends StatefulWidget {
  final StagiaireEncadrantModel       stagiaire;
  final List<StagiaireEncadrantModel> stagiaires;
  final VoidCallback                  onClose;

  const TacheDialog({
    super.key,
    required this.stagiaire,
    required this.stagiaires,
    required this.onClose,
  });

  @override
  State<TacheDialog> createState() => _TacheDialogState();
}

class _TacheDialogState extends State<TacheDialog> {
  final _titreCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  late StagiaireEncadrantModel _stag;
  DateTime?    _date;
  PrioriteTache _priorite = PrioriteTache.moyenne;
  bool          _loading  = false;

  @override
  void initState() {
    super.initState();
    _stag = widget.stagiaire;
  }

  @override
  void dispose() {
    _titreCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ✅ Cas 'critique' ajouté dans les 3 helpers
  Color _pColor(PrioriteTache p) => switch (p) {
    PrioriteTache.critique => const Color(0xFF7C3AED), // violet
    PrioriteTache.haute    => AppTheme.error,
    PrioriteTache.moyenne  => AppTheme.primary,
    PrioriteTache.basse    => AppTheme.success,
  };

  Color _pBg(PrioriteTache p) => switch (p) {
    PrioriteTache.critique => const Color(0xFFF5F3FF), // violet soft
    PrioriteTache.haute    => const Color(0xFFFEF2F2),
    PrioriteTache.moyenne  => AppTheme.primarySoft,
    PrioriteTache.basse    => AppTheme.successSoft,
  };

  IconData _pIcon(PrioriteTache p) => switch (p) {
    PrioriteTache.critique => Icons.priority_high_rounded,
    PrioriteTache.haute    => Icons.keyboard_double_arrow_up_rounded,
    PrioriteTache.moyenne  => Icons.drag_handle_rounded,
    PrioriteTache.basse    => Icons.keyboard_double_arrow_down_rounded,
  };

  Future<void> _submit() async {
    if (_titreCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Le titre est obligatoire',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD)),
      ));
      return;
    }
    setState(() => _loading = true);
    context.read<EncadrantBloc>().add(EncadrantTacheCreated(
      stagiaireId:  _stag.id,
      titre:        _titreCtrl.text.trim(),
      description:  _descCtrl.text.trim(),
      dateEcheance: _date ?? DateTime.now().add(const Duration(days: 7)),
      statut:       StatutTacheEncadrant.aFaire,
      priorite:     _priorite,
    ));
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _loading = false);
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nouvelle tâche',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: AppTheme.textDark)),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius:
                      BorderRadius.circular(AppTheme.radiusSM),
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: AppTheme.textSecond, size: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Bandeau info ─────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: AppTheme.darkSoft,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded,
                    size: 14, color: AppTheme.dark),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'La tâche démarre en "À faire". Le stagiaire gère sa progression.',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: AppTheme.dark),
                  ),
                ),
              ]),
            ),

            const SizedBox(height: 16),

            // ── Sélecteur stagiaire ──────────────────────────
            Text('Assigner à',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(color: AppTheme.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<StagiaireEncadrantModel>(
                  value: _stag,
                  isExpanded: true,
                  style: Theme.of(context).textTheme.bodyMedium,
                  items: widget.stagiaires
                      .map((s) => DropdownMenuItem(
                    value: s,
                    child: Row(children: [
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: AppTheme.textDark,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Center(
                          child: Text(
                            s.initials[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(s.nomComplet),
                    ]),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _stag = v ?? _stag),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Titre ────────────────────────────────────────
            Text('Titre *',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            _field(_titreCtrl, 'Titre de la tâche', Icons.title_rounded),

            const SizedBox(height: 12),

            // ── Description ──────────────────────────────────
            Text('Description',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            _field(_descCtrl, 'Description (optionnel)',
                Icons.notes_rounded,
                maxLines: 3),

            const SizedBox(height: 12),

            // ── Priorité ─────────────────────────────────────
            Text('Priorité',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            // ✅ PrioriteTache.values itère automatiquement les 4 valeurs
            // dont 'critique' — plus de switch manquant ici
            Row(
              children: PrioriteTache.values.map((p) {
                final sel   = _priorite == p;
                final color = _pColor(p);
                final bg    = _pBg(p);
                final icon  = _pIcon(p);
                final isLast = p == PrioriteTache.basse;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priorite = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.only(right: isLast ? 0 : 6),
                      padding:
                      const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: sel ? bg : AppTheme.background,
                        borderRadius:
                        BorderRadius.circular(AppTheme.radiusMD),
                        border: Border.all(
                          color: sel ? color : AppTheme.border,
                          width: sel ? 1.5 : 1,
                        ),
                      ),
                      child: Column(children: [
                        Icon(icon,
                            color:
                            sel ? color : AppTheme.textLight,
                            size: 18),
                        const SizedBox(height: 3),
                        Text(
                          p.uiLabel,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: sel
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color:
                            sel ? color : AppTheme.textSecond,
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // ── Date échéance ─────────────────────────────────
            Text("Date d'échéance",
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate:
                  DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2027),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppTheme.primary,
                        onPrimary: Colors.white,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (d != null) setState(() => _date = d);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 13),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius:
                  BorderRadius.circular(AppTheme.radiusMD),
                  border: Border.all(
                    color: _date != null
                        ? AppTheme.primary
                        : AppTheme.border,
                    width: _date != null ? 1.5 : 1,
                  ),
                ),
                child: Row(children: [
                  Icon(Icons.calendar_month_rounded,
                      size: 16,
                      color: _date != null
                          ? AppTheme.primary
                          : AppTheme.textLight),
                  const SizedBox(width: 8),
                  Text(
                    _date == null
                        ? 'Choisir une date'
                        : '${_date!.day}/${_date!.month}/${_date!.year}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                      color: _date != null
                          ? AppTheme.textPrimary
                          : AppTheme.textLight,
                    ),
                  ),
                ]),
              ),
            ),

            const SizedBox(height: 20),

            // ── Bouton créer ──────────────────────────────────
            GestureDetector(
              onTap: _loading ? null : _submit,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _loading
                      ? AppTheme.primary.withOpacity(0.6)
                      : AppTheme.primary,
                  borderRadius:
                  BorderRadius.circular(AppTheme.radiusMD),
                  boxShadow: _loading ? [] : AppTheme.shadowOrange,
                ),
                child: Center(
                  child: _loading
                      ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_task_rounded,
                          color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text('Créer la tâche',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
      TextEditingController c,
      String hint,
      IconData icon, {
        int maxLines = 1,
      }) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: maxLines == 1
            ? Icon(icon, size: 16, color: AppTheme.textLight)
            : null,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 12),
      ),
    );
  }
}