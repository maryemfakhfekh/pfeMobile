// lib/features/encadrant/repositories/encadrant_repository.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/dio_client.dart';
import '../data/models/candidature_entretien_model.dart';
import '../data/models/dashboard_encadrant_model.dart';
import '../data/models/encadrant_profile_model.dart';
import '../data/models/evaluation_model.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../data/models/tache_encadrant_model.dart';

class EncadrantRepository {
	final DioClient _api;
	final FlutterSecureStorage _storage;

	EncadrantRepository(this._api)
			: _storage = const FlutterSecureStorage();

	// ── Dashboard ─────────────────────────────────────────
	Future<DashboardEncadrantModel> getDashboard() async {
		final res = await _api.dio.get(ApiEndpoints.encadrantDashboard);
		return DashboardEncadrantModel.fromJson(
				res.data as Map<String, dynamic>);
	}

	// ── Mes Stagiaires ────────────────────────────────────
	Future<List<StagiaireEncadrantModel>> getMesStagiaires() async {
		final res = await _api.dio.get(ApiEndpoints.encadrantStagiaires);
		return (res.data as List)
				.map((e) =>
				StagiaireEncadrantModel.fromJson(e as Map<String, dynamic>))
				.toList();
	}

	// ── Tâches d'un stagiaire ─────────────────────────────
	Future<List<TacheEncadrantModel>> getTachesByStagiaire(
			int stagiaireId) async {
		final res = await _api.dio
				.get(ApiEndpoints.encadrantTachesByStagiaire(stagiaireId));
		return (res.data as List)
				.map((e) =>
				TacheEncadrantModel.fromJson(e as Map<String, dynamic>))
				.toList();
	}

	// ── Créer tâche ───────────────────────────────────────
	Future<TacheEncadrantModel> createTache({
		required int stagiaireId,
		required String titre,
		required String description,
		required DateTime dateEcheance,
		required StatutTacheEncadrant statut,
		PrioriteTache priorite = PrioriteTache.moyenne,
	}) async {
		final res = await _api.dio.post(
			ApiEndpoints.creerTachePourStagiaire(stagiaireId),
			data: {
				'titre':        titre,
				'description':  description,
				'dateEcheance': dateEcheance.toIso8601String().split('T')[0],
				'statut':       statut.apiValue,
				'priorite':     priorite.apiValue,
			},
		);
		return TacheEncadrantModel.fromJson(res.data as Map<String, dynamic>);
	}

	// ── Modifier tâche ────────────────────────────────────
	Future<TacheEncadrantModel> updateTache(TacheEncadrantModel tache) async {
		final res = await _api.dio.put(
			ApiEndpoints.encadrantTacheById(tache.id),
			data: tache.toJson(),
		);
		return TacheEncadrantModel.fromJson(res.data as Map<String, dynamic>);
	}

	// ── Changer statut tâche ──────────────────────────────
	Future<TacheEncadrantModel> updateStatutTache({
		required int tacheId,
		required StatutTacheEncadrant statut,
	}) async {
		final res = await _api.dio.put(
			ApiEndpoints.encadrantTacheStatut(tacheId),
			data: {'statut': statut.apiValue},
		);
		return TacheEncadrantModel.fromJson(res.data as Map<String, dynamic>);
	}

	// ── Supprimer tâche ───────────────────────────────────
	Future<void> deleteTache({
		required int stagiaireId,
		required int tacheId,
	}) async {
		await _api.dio.delete(ApiEndpoints.encadrantTacheById(tacheId));
	}

	// ── Commentaire tâche ─────────────────────────────────
	Future<void> addCommentaireTache({
		required int stagiaireId,
		required int tacheId,
		required String commentaire,
	}) async {
		await _api.dio.post(
			ApiEndpoints.encadrantTacheCommentaires(tacheId),
			data: {'contenu': commentaire},
		);
	}

	// ── Soumettre évaluation ──────────────────────────────
	Future<EvaluationModel> submitEvaluation({
		required int stagiaireId,
		required double note,
		required String commentaire,
	}) async {
		final res = await _api.dio.post(
			ApiEndpoints.encadrantEvaluationByStagiaire(stagiaireId),
			data: {
				'note':        note,
				'commentaire': commentaire,
			},
		);
		return EvaluationModel.fromJson(res.data as Map<String, dynamic>);
	}

	// ── Profil encadrant ──────────────────────────────────
	Future<EncadrantProfileModel> getProfile() async {
		try {
			final res = await _api.dio.get(ApiEndpoints.encadrantProfile);
			return EncadrantProfileModel.fromJson(
					res.data as Map<String, dynamic>);
		} catch (_) {
			final nom       = await _storage.read(key: 'nom')       ?? '';
			final prenom    = await _storage.read(key: 'prenom')    ?? '';
			final email     = await _storage.read(key: 'email')     ?? '';
			final telephone =
					await _storage.read(key: 'telephone') ?? 'Non disponible';
			return EncadrantProfileModel(
				id:             0,
				nomComplet:     '$nom $prenom'.trim(),
				email:          email,
				telephone:      telephone,
				dateNaissance:  'Non disponible',
				stagairesCount: 0,
				dateCreation:   DateTime.now(),
			);
		}
	}

	// ── Candidatures ──────────────────────────────────────

	Future<List<CandidatureEntretienModel>> getCandidaturesAffectees() async {
		final res = await _api.dio.get('/candidatures/mes-entretiens');
		return (res.data as List)
				.map((e) => CandidatureEntretienModel.fromJson(
				e as Map<String, dynamic>))
				.toList();
	}

	Future<List<QuestionEntretienModel>> getQuestionsIA(
			int candidatureId) async {
		final res = await _api.dio.get('/ia/questions/$candidatureId');
		return (res.data as List)
				.map((e) => QuestionEntretienModel.fromJson(
				e as Map<String, dynamic>))
				.toList();
	}

	// ✅ Marquer entretien réalisé avec commentaire obligatoire
	Future<void> marquerEntretienRealise({
		required int stagiaireId,
		required String commentaire,
	}) async {
		await _api.dio.put(
			'/candidatures/$stagiaireId/valider-encadrant',
			data: {'commentaire': commentaire},
		);
	}
// ❌ refuserEntretien → SUPPRIMÉ
// ── Rapports ──────────────────────────────────────────
	Future<Map<String, dynamic>?> getRapportByStagiaire(int stagiaireId) async {
		try {
			final res = await _api.dio.get('/rapports/stagiaire/$stagiaireId');
			return res.data as Map<String, dynamic>;
		} catch (_) {
			return null; // pas encore de rapport
		}
	}

	Future<List<Map<String, dynamic>>> getAllRapports() async {
		final res = await _api.dio.get('/rapports');
		return (res.data as List)
				.map((e) => e as Map<String, dynamic>)
				.toList();
	}
}
