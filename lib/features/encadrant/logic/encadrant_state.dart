// lib/features/encadrant/logic/encadrant_state.dart

import '../data/models/candidature_entretien_model.dart';
import '../data/models/dashboard_encadrant_model.dart';
import '../data/models/evaluation_model.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../data/models/tache_encadrant_model.dart';

class EncadrantState {
	final bool isLoading;
	final String? error;
	final String? successMessage;
	final DashboardEncadrantModel? dashboard;
	final List<StagiaireEncadrantModel> stagiaires;
	final Map<int, List<TacheEncadrantModel>> tachesByStagiaire;
	final Map<int, EvaluationModel> evaluationsByStagiaire;

	// ── NOUVEAUX champs Candidatures ────────────────────────
	final List<CandidatureEntretienModel> candidatures;
	final bool isLoadingCandidatures;
	final Map<int, List<QuestionEntretienModel>> questionsByCandidat;
	final bool isLoadingQuestions;
	final bool entretienRealiseSuccess;

	const EncadrantState({
		this.isLoading                = false,
		this.error,
		this.successMessage,
		this.dashboard,
		this.stagiaires               = const [],
		this.tachesByStagiaire        = const {},
		this.evaluationsByStagiaire   = const {},
		this.candidatures             = const [],
		this.isLoadingCandidatures    = false,
		this.questionsByCandidat      = const {},
		this.isLoadingQuestions       = false,
		this.entretienRealiseSuccess  = false,
	});

	EncadrantState copyWith({
		bool? isLoading,
		String? error,
		bool clearError = false,
		String? successMessage,
		bool clearSuccess = false,
		DashboardEncadrantModel? dashboard,
		List<StagiaireEncadrantModel>? stagiaires,
		Map<int, List<TacheEncadrantModel>>? tachesByStagiaire,
		Map<int, EvaluationModel>? evaluationsByStagiaire,
		// candidatures
		List<CandidatureEntretienModel>? candidatures,
		bool? isLoadingCandidatures,
		Map<int, List<QuestionEntretienModel>>? questionsByCandidat,
		bool? isLoadingQuestions,
		bool? entretienRealiseSuccess,
	}) {
		return EncadrantState(
			isLoading:               isLoading ?? this.isLoading,
			error:                   clearError ? null : (error ?? this.error),
			successMessage:          clearSuccess ? null : (successMessage ?? this.successMessage),
			dashboard:               dashboard ?? this.dashboard,
			stagiaires:              stagiaires ?? this.stagiaires,
			tachesByStagiaire:       tachesByStagiaire ?? this.tachesByStagiaire,
			evaluationsByStagiaire:  evaluationsByStagiaire ?? this.evaluationsByStagiaire,
			candidatures:            candidatures ?? this.candidatures,
			isLoadingCandidatures:   isLoadingCandidatures ?? this.isLoadingCandidatures,
			questionsByCandidat:     questionsByCandidat ?? this.questionsByCandidat,
			isLoadingQuestions:      isLoadingQuestions ?? this.isLoadingQuestions,
			entretienRealiseSuccess: entretienRealiseSuccess ?? this.entretienRealiseSuccess,
		);
	}
}