// lib/features/encadrant/logic/encadrant_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/candidature_entretien_model.dart';
import '../data/models/evaluation_model.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../data/models/tache_encadrant_model.dart';
import '../repositories/encadrant_repository.dart';
import 'encadrant_event.dart';
import 'encadrant_state.dart';

class EncadrantBloc extends Bloc<EncadrantEvent, EncadrantState> {
  final EncadrantRepository repository;

  EncadrantBloc({required this.repository}) : super(const EncadrantState()) {
    on<EncadrantDashboardRequested>(_onDashboardRequested);
    on<EncadrantStagiairesRequested>(_onStagiairesRequested);
    on<EncadrantTachesRequested>(_onTachesRequested);
    on<EncadrantTacheCreated>(_onTacheCreated);
    on<EncadrantTacheUpdated>(_onTacheUpdated);
    on<EncadrantTacheDeleted>(_onTacheDeleted);
    on<EncadrantCommentaireTacheAdded>(_onCommentaireTacheAdded);
    on<EncadrantEvaluationSubmitted>(_onEvaluationSubmitted);
    on<EncadrantCandidaturesRequested>(_onCandidaturesRequested);
    on<EncadrantQuestionsIARequested>(_onQuestionsIARequested);
    on<EncadrantEntretienRealise>(_onEntretienRealise);
    // ❌ EncadrantEntretienRefuse → SUPPRIMÉ
  }

  Map<int, List<TacheEncadrantModel>> _withTaches({
    required int stagiaireId,
    required List<TacheEncadrantModel> taches,
  }) {
    final updated = Map<int, List<TacheEncadrantModel>>.from(
        state.tachesByStagiaire);
    updated[stagiaireId] = taches;
    return updated;
  }

  List<StagiaireEncadrantModel> _enrichStagiaires(
    List<StagiaireEncadrantModel> stagiaires,
    Map<int, List<TacheEncadrantModel>> tachesMap,
  ) {
    return stagiaires.map((s) {
      final taches  = tachesMap[s.id] ?? [];
      final total   = taches.length;
      final termine = taches
          .where((t) => t.statut == StatutTacheEncadrant.termine)
          .length;
      return StagiaireEncadrantModel(
        id:                 s.id,
        utilisateurId:      s.utilisateurId,
        nomComplet:         s.nomComplet,
        email:              s.email,
        sujetTitre:         s.sujetTitre,
        filiere:            s.filiere,
        dateDebut:          s.dateDebut,
        dateFin:            s.dateFin,
        tachesTerminees:    termine,
        tachesTotales:      total,
        rapportDepose:      s.rapportDepose,
        progressionGlobale: total > 0 ? termine / total : 0.0,
      );
    }).toList();
  }

  Future<void> _onDashboardRequested(
    EncadrantDashboardRequested event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final dashboard = await repository.getDashboard();
      emit(state.copyWith(isLoading: false, dashboard: dashboard));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onStagiairesRequested(
    EncadrantStagiairesRequested event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final stagiaires = await repository.getMesStagiaires();
      final tachesMap  = <int, List<TacheEncadrantModel>>{};
      await Future.wait(stagiaires.map((s) async {
        try {
          tachesMap[s.id] = await repository.getTachesByStagiaire(s.id);
        } catch (_) {
          tachesMap[s.id] = [];
        }
      }));
      final enriched = _enrichStagiaires(stagiaires, tachesMap);
      emit(state.copyWith(
        isLoading:         false,
        stagiaires:        enriched,
        tachesByStagiaire: tachesMap,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onTachesRequested(
    EncadrantTachesRequested event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final taches       = await repository.getTachesByStagiaire(event.stagiaireId);
      final newTachesMap = _withTaches(stagiaireId: event.stagiaireId, taches: taches);
      final enriched     = _enrichStagiaires(state.stagiaires, newTachesMap);
      emit(state.copyWith(
        isLoading:         false,
        tachesByStagiaire: newTachesMap,
        stagiaires:        enriched,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onTacheCreated(
    EncadrantTacheCreated event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      await repository.createTache(
        stagiaireId:  event.stagiaireId,
        titre:        event.titre,
        description:  event.description,
        dateEcheance: event.dateEcheance,
        statut:       event.statut,
        priorite:     event.priorite,
      );
      final taches       = await repository.getTachesByStagiaire(event.stagiaireId);
      final newTachesMap = _withTaches(stagiaireId: event.stagiaireId, taches: taches);
      final enriched     = _enrichStagiaires(state.stagiaires, newTachesMap);
      emit(state.copyWith(
        isLoading:         false,
        tachesByStagiaire: newTachesMap,
        stagiaires:        enriched,
        successMessage:    'Tâche créée avec succès',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onTacheUpdated(
    EncadrantTacheUpdated event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      await repository.updateTache(event.tache);
      final taches       = await repository.getTachesByStagiaire(event.tache.stagiaireId);
      final newTachesMap = _withTaches(stagiaireId: event.tache.stagiaireId, taches: taches);
      final enriched     = _enrichStagiaires(state.stagiaires, newTachesMap);
      emit(state.copyWith(
        isLoading:         false,
        tachesByStagiaire: newTachesMap,
        stagiaires:        enriched,
        successMessage:    'Tâche mise à jour',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onTacheDeleted(
    EncadrantTacheDeleted event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      await repository.deleteTache(
        stagiaireId: event.stagiaireId,
        tacheId:     event.tacheId,
      );
      final taches       = await repository.getTachesByStagiaire(event.stagiaireId);
      final newTachesMap = _withTaches(stagiaireId: event.stagiaireId, taches: taches);
      final enriched     = _enrichStagiaires(state.stagiaires, newTachesMap);
      emit(state.copyWith(
        isLoading:         false,
        tachesByStagiaire: newTachesMap,
        stagiaires:        enriched,
        successMessage:    'Tâche supprimée',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCommentaireTacheAdded(
    EncadrantCommentaireTacheAdded event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      await repository.addCommentaireTache(
        stagiaireId: event.stagiaireId,
        tacheId:     event.tacheId,
        commentaire: event.commentaire,
      );
      final taches       = await repository.getTachesByStagiaire(event.stagiaireId);
      final newTachesMap = _withTaches(stagiaireId: event.stagiaireId, taches: taches);
      final enriched     = _enrichStagiaires(state.stagiaires, newTachesMap);
      emit(state.copyWith(
        isLoading:         false,
        tachesByStagiaire: newTachesMap,
        stagiaires:        enriched,
        successMessage:    'Commentaire ajouté',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onEvaluationSubmitted(
    EncadrantEvaluationSubmitted event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final evaluation = await repository.submitEvaluation(
        stagiaireId: event.stagiaireId,
        note:        event.note,
        commentaire: event.commentaire,
      );
      final updated = Map<int, EvaluationModel>.from(
          state.evaluationsByStagiaire)..[event.stagiaireId] = evaluation;
      emit(state.copyWith(
        isLoading:              false,
        evaluationsByStagiaire: updated,
        successMessage:         'Évaluation soumise au RH',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCandidaturesRequested(
    EncadrantCandidaturesRequested event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoadingCandidatures: true, clearError: true));
    try {
      final candidatures = await repository.getCandidaturesAffectees();
      emit(state.copyWith(
        isLoadingCandidatures: false,
        candidatures:          candidatures,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingCandidatures: false,
        error:                 e.toString(),
      ));
    }
  }

  Future<void> _onQuestionsIARequested(
    EncadrantQuestionsIARequested event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoadingQuestions: true, clearError: true));
    try {
      final questions = await repository.getQuestionsIA(event.stagiaireId);
      final updated   = Map<int, List<QuestionEntretienModel>>.from(
          state.questionsByCandidat)..[event.stagiaireId] = questions;
      emit(state.copyWith(
        isLoadingQuestions:  false,
        questionsByCandidat: updated,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingQuestions: false,
        error:              e.toString(),
      ));
    }
  }

  Future<void> _onEntretienRealise(
    EncadrantEntretienRealise event,
    Emitter<EncadrantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      await repository.marquerEntretienRealise(
        stagiaireId: event.stagiaireId,
        commentaire: event.commentaire,
      );
      final updated = state.candidatures
          .where((c) => c.stagiaireId != event.stagiaireId)
          .toList();
      emit(state.copyWith(
        isLoading:               false,
        candidatures:            updated,
        entretienRealiseSuccess: true,
        successMessage:          'Entretien marqué comme réalisé',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}