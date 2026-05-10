// lib/features/encadrant/widgets/candidatures/entretien_questions_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/candidature_entretien_model.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_event.dart';
import '../../logic/encadrant_state.dart';

class EntretienQuestionsPage extends StatefulWidget {
  final CandidatureEntretienModel candidat;

  const EntretienQuestionsPage({super.key, required this.candidat});

  @override
  State<EntretienQuestionsPage> createState() => _EntretienQuestionsPageState();
}

class _EntretienQuestionsPageState extends State<EntretienQuestionsPage> {
  final _commentaireController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<EncadrantBloc>().state;
    if (!state.questionsByCandidat.containsKey(widget.candidat.id)) {
      context
          .read<EncadrantBloc>()
          .add(EncadrantQuestionsIARequested(widget.candidat.id));
    }
  }

  @override
  void dispose() {
    _commentaireController.dispose();
    super.dispose();
  }

  void _marquerRealise() {
    _commentaireController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => BlocProvider.value(
        value: context.read<EncadrantBloc>(),
        child: _EntretienRealiseSheet(
          candidat: widget.candidat,
          controller: _commentaireController,
          onConfirmer: () {
            // ✅ Commentaire obligatoire
            if (_commentaireController.text.trim().isEmpty) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: const Text('Le commentaire est obligatoire'),
                  backgroundColor: AppTheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            context.read<EncadrantBloc>().add(
              EncadrantEntretienRealise(
                stagiaireId: widget.candidat.id,
                commentaire: _commentaireController.text.trim(),
              ),
            );
            Navigator.of(ctx).pop();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EncadrantBloc, EncadrantState>(
      listener: (context, state) {
        if (state.successMessage != null &&
            state.successMessage!.contains('réalisé')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Entretien marqué comme réalisé ✓'),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM)),
            ),
          );
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: AppTheme.textDark),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.candidat.nomComplet,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                widget.candidat.sujetTitre,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textLight,
                  fontFamily: 'Poppins',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        body: BlocBuilder<EncadrantBloc, EncadrantState>(
          builder: (context, state) {
            final questions = state.questionsByCandidat[widget.candidat.id];
            final isLoading = state.isLoadingQuestions;

            return Column(
              children: [
                // ── Bandeau info IA ──────────────────────
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppTheme.primary.withOpacity(0.2), width: 1),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded,
                          size: 18, color: AppTheme.primary),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Questions générées par l\'IA selon le profil du candidat',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primary,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Liste des questions ──────────────────
                Expanded(
                  child: isLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.primary),
                  )
                      : questions == null || questions.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.quiz_outlined,
                            size: 48, color: AppTheme.textLight),
                        const SizedBox(height: 12),
                        const Text(
                          'Questions non disponibles',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textLight,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => context
                              .read<EncadrantBloc>()
                              .add(EncadrantQuestionsIARequested(
                              widget.candidat.id)),
                          child: const Text('Réessayer',
                              style: TextStyle(
                                  color: AppTheme.primary)),
                        ),
                      ],
                    ),
                  )
                      : ListView.separated(
                    padding:
                    const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: questions.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      return _QuestionCard(
                        numero: i + 1,
                        question: questions[i],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),

        // ── Un seul bouton ───────────────────────────────
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: BlocBuilder<EncadrantBloc, EncadrantState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : _marquerRealise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Marquer entretien comme réalisé',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Card question
// ─────────────────────────────────────────────────────────────

class _QuestionCard extends StatelessWidget {
  final int numero;
  final QuestionEntretienModel question;

  const _QuestionCard({required this.numero, required this.question});

  Color get _typeColor {
    switch (question.type.toLowerCase()) {
      case 'technique':       return const Color(0xFF3B82F6);
      case 'comportementale': return const Color(0xFF8B5CF6);
      case 'projet':          return const Color(0xFF059669);
      case 'academique':      return const Color(0xFFF59E0B);
      case 'motivation':      return const Color(0xFFEC4899);
      default:                return AppTheme.primary;
    }
  }

  String get _typeLabel {
    switch (question.type.toLowerCase()) {
      case 'technique':       return 'Technique';
      case 'comportementale': return 'Comportemental';
      case 'projet':          return 'Projet';
      case 'academique':      return 'Académique';
      case 'motivation':      return 'Motivation';
      default:                return question.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 0.5),
        boxShadow: AppTheme.shadowLight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.darkSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$numero',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _typeLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _typeColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textPrimary,
                    fontFamily: 'Poppins',
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Bottom sheet — commentaire obligatoire
// ─────────────────────────────────────────────────────────────

class _EntretienRealiseSheet extends StatelessWidget {
  final CandidatureEntretienModel candidat;
  final TextEditingController controller;
  final VoidCallback onConfirmer;

  const _EntretienRealiseSheet({
    required this.candidat,
    required this.controller,
    required this.onConfirmer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Titre
          const Text(
            'Marquer l\'entretien comme réalisé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Entretien avec ${candidat.nomComplet}',
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textLight,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 20),

          // ✅ Commentaire obligatoire
          Row(
            children: const [
              Text(
                'Commentaire pour le RH',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecond,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.error,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Donnez votre avis sur le candidat pour aider le RH à décider',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textLight,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: controller,
            maxLines: 4,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Poppins',
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Ex: Le candidat maîtrise bien Flutter et a de bonnes bases en Dart. Je recommande de l\'accepter...',
              hintStyle: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
              filled: true,
              fillColor: AppTheme.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: AppTheme.border, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: AppTheme.border, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: AppTheme.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onConfirmer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Confirmer',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}