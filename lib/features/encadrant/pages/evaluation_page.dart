import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../logic/encadrant_bloc.dart';
import '../logic/encadrant_event.dart';
import '../logic/encadrant_state.dart';
import '../widgets/evaluation/index.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  StagiaireEncadrantModel? _selected;
  final _commentaireController = TextEditingController();
  bool _isLoading = false;

  final Map<String, _Critere> _criteres = {
    'Qualité du travail':
    _Critere('Précision et rigueur dans les livrables', 0),
    'Autonomie':
    _Critere('Capacité à travailler de manière indépendante', 0),
    'Communication':      _Critere('Clarté et fréquence des échanges', 0),
    'Ponctualité':        _Critere('Respect des délais et assiduité', 0),
    "Prise d'initiative": _Critere('Proactivité et propositions', 0),
    "Travail d'équipe":   _Critere("Collaboration et esprit d'équipe", 0),
  };

  double get _moyenne {
    final vals = _criteres.values.map((c) => c.note).toList();
    if (vals.every((v) => v == 0)) return 0;
    return vals.fold(0.0, (a, b) => a + b) / vals.length;
  }

  double get _noteFinale => _moyenne * 4;

  void _resetForm() {
    setState(() {
      _selected = null;
      _commentaireController.clear();
      for (final k in _criteres.keys) {
        _criteres[k] = _Critere(_criteres[k]!.sousTitre, 0);
      }
    });
  }

  Future<void> _soumettre() async {
    if (_selected == null) return;
    if (_criteres.values.any((c) => c.note == 0)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Veuillez noter tous les critères'),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _isLoading = true);
    final bloc = context.read<EncadrantBloc>();
    bloc.add(EncadrantEvaluationSubmitted(
      stagiaireId: _selected!.id,
      note:        _noteFinale,
      commentaire: _commentaireController.text.trim(),
    ));
    final result = await bloc.stream.firstWhere((s) => !s.isLoading);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (result.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Évaluation soumise avec succès !'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ));
      _resetForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.error!),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  void dispose() {
    _commentaireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return BlocBuilder<EncadrantBloc, EncadrantState>(
      builder: (ctx, state) {
        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
                20, top + 20, 20, bottomInset + 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Header ─────────────────────────────────
                const Text(
                  'Évaluations',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Évaluez la performance de vos stagiaires',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: 16),

                // ── Sélection stagiaire ─────────────────────
                if (state.stagiaires.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text('Aucun stagiaire affecté',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  )
                else
                  EvaluationStagiaireDropdown(
                    stagiaires: state.stagiaires,
                    selected:   _selected,
                    onSelected: (s) => setState(() => _selected = s),
                  ),

                // ── Formulaire ──────────────────────────────
                if (_selected != null) ...[
                  const SizedBox(height: 20),
                  const Text(
                    "Critères d'évaluation",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._criteres.entries.map((e) => EvaluationCritereCard(
                    titre:     e.key,
                    sousTitre: e.value.sousTitre,
                    note:      e.value.note,
                    onChanged: (v) => setState(() =>
                    _criteres[e.key] =
                        _Critere(e.value.sousTitre, v)),
                  )),
                  const SizedBox(height: 12),
                  EvaluationCommentaireCard(
                      controller: _commentaireController),
                  const SizedBox(height: 16),
                  EvaluationSubmitButton(
                    isLoading: _isLoading,
                    onTap:     _soumettre,
                  ),
                  const SizedBox(height: 24),
                ],

                // ── Historique ──────────────────────────────
                if (state.evaluationsByStagiaire.isNotEmpty) ...[
                  const Text(
                    'Historique des évaluations',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...state.evaluationsByStagiaire.entries.map((entry) {
                    final eval = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFE2E8F0), width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppTheme.primarySoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.star_rounded,
                              color: AppTheme.primary, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Stagiaire #${entry.key}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primarySoft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${eval.note.toStringAsFixed(1)}/5',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ]),
                    );
                  }),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Critere {
  final String sousTitre;
  final double note;
  const _Critere(this.sousTitre, this.note);
}