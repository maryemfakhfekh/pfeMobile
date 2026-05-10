import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../logic/encadrant_bloc.dart';
import '../logic/encadrant_event.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../data/models/tache_encadrant_model.dart';
import '../widgets/creer_tache/index.dart';  // ← un seul import

@RoutePage()
class CreerTachePage extends StatefulWidget {
  final StagiaireEncadrantModel stagiaire;
  const CreerTachePage({super.key, required this.stagiaire});

  @override
  State<CreerTachePage> createState() => _CreerTachePageState();
}

class _CreerTachePageState extends State<CreerTachePage> {
  final _formKey   = GlobalKey<FormState>();
  final _titreCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  DateTime?     _dateEcheance;
  PrioriteTache _priorite  = PrioriteTache.moyenne;
  bool          _isLoading = false;

  @override
  void dispose() {
    _titreCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027, 12, 31),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primary,
            onPrimary: Colors.white,
            surface: AppTheme.surface,
            onSurface: AppTheme.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dateEcheance = picked);
  }

  Future<void> _soumettre() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateEcheance == null) {
      _snack("Veuillez choisir une date d'échéance.", AppTheme.error);
      return;
    }
    setState(() => _isLoading = true);
    final bloc = context.read<EncadrantBloc>();
    bloc.add(EncadrantTacheCreated(
      stagiaireId:  widget.stagiaire.id,
      titre:        _titreCtrl.text.trim(),
      description:  _descCtrl.text.trim(),
      dateEcheance: _dateEcheance!,
      statut:       StatutTacheEncadrant.aFaire,
      priorite:     _priorite,
    ));
    final result = await bloc.stream.firstWhere((s) => !s.isLoading);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (result.error != null) { _snack(result.error!, AppTheme.error); return; }
    _snack('Tâche créée avec succès !', AppTheme.success);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) context.router.back();
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins')),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMD)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(children: [
        const TacheHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StagiaireAssigneCard(stagiaire: widget.stagiaire),
                  const SizedBox(height: 16),
                  _InfoBanner(),
                  const SizedBox(height: 16),
                  const TacheLabel(title: 'Titre de la tâche', required: true),
                  const SizedBox(height: 8),
                  TacheTextField(
                    controller: _titreCtrl,
                    hint: 'Ex : Implémenter le module login',
                    icon: Icons.task_alt_rounded,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Le titre est obligatoire' : null,
                  ),
                  const SizedBox(height: 16),
                  const TacheLabel(title: 'Description'),
                  const SizedBox(height: 8),
                  TacheTextField(
                    controller: _descCtrl,
                    hint: 'Décrivez la tâche en détail...',
                    icon: Icons.notes_rounded,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  const TacheLabel(title: 'Priorité', required: true),
                  const SizedBox(height: 8),
                  PrioriteSelector(
                    value: _priorite,
                    onChanged: (p) => setState(() => _priorite = p),
                  ),
                  const SizedBox(height: 16),
                  const TacheLabel(title: "Date d'échéance", required: true),
                  const SizedBox(height: 8),
                  DateEcheancePicker(
                    value: _dateEcheance,
                    onTap: _pickDate,
                    onClear: () => setState(() => _dateEcheance = null),
                  ),
                  const SizedBox(height: 28),
                  TacheSubmitButton(
                    isLoading: _isLoading,
                    onTap: _soumettre,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppTheme.darkSoft,
      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      border: Border.all(color: AppTheme.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline_rounded, size: 15, color: AppTheme.dark),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'La tâche démarre en "À faire". Le stagiaire gère sa progression.',
            style: Theme.of(context).textTheme.labelSmall!
                .copyWith(color: AppTheme.dark, height: 1.5),
          ),
        ),
      ],
    ),
  );
}