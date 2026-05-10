// lib/features/stagiaire/widgets/dashboard/taches/add_task_dialog.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(TacheModel) onTaskCreated;
  const AddTaskDialog({super.key, required this.onTaskCreated});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  TachePriorite _priorite   = TachePriorite.moyenne;
  String _dateEcheance = DateTime.now()
      .add(const Duration(days: 7))
      .toIso8601String()
      .split('T')[0];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le titre est requis'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    final id = DateTime.now().millisecondsSinceEpoch;
    widget.onTaskCreated(TacheModel(
      id:           id,
      issueKey:     'GS-${id % 1000}',
      titre:        _titleCtrl.text.trim(),
      description:  _descCtrl.text.isEmpty ? null : _descCtrl.text,
      statut:       TacheStatut.aFaire,
      priorite:     _priorite,
      dateEcheance: _dateEcheance,
      dateCreation: DateTime.now().toIso8601String().split('T')[0],
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Nouvelle tâche',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: AppTheme.textLight, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Titre
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Titre de la tâche...',
                hintStyle: const TextStyle(color: AppTheme.textLight),
                filled: true,
                fillColor: AppTheme.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            // Description
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Description (optionnel)...',
                hintStyle: const TextStyle(color: AppTheme.textLight),
                filled: true,
                fillColor: AppTheme.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),
            // Priorité
            const Text('Priorité',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecond)),
            const SizedBox(height: 8),
            Row(
              children: TachePriorite.values.map((p) {
                final isSelected = _priorite == p;
                final label = switch (p) {
                  TachePriorite.basse    => 'Basse',
                  TachePriorite.moyenne  => 'Moyenne',
                  TachePriorite.haute    => 'Haute',
                  TachePriorite.critique => 'Critique',
                };
                final color = switch (p) {
                  TachePriorite.basse    => const Color(0xFF166534),
                  TachePriorite.moyenne  => const Color(0xFFED6C02),
                  TachePriorite.haute    => const Color(0xFFD32F2F),
                  TachePriorite.critique => const Color(0xFF9C27B0),
                };
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priorite = p),
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withOpacity(0.1) : AppTheme.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: isSelected ? color : AppTheme.border),
                      ),
                      child: Text(label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? color : AppTheme.textLight)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            // Date
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: AppTheme.textSecond),
                    const SizedBox(width: 10),
                    Text(_dateEcheance,
                        style: const TextStyle(
                            fontSize: 13, color: AppTheme.textPrimary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Créer la tâche',
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final initial = DateTime.tryParse(_dateEcheance) ??
        DateTime.now().add(const Duration(days: 7));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primary)),
        child: child!,
      ),
    );
    if (date != null) {
      setState(() =>
      _dateEcheance = date.toIso8601String().split('T')[0]);
    }
  }
}