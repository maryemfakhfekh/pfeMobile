// lib/features/encadrant/data/models/tache_encadrant_model.dart

// ── Statut ────────────────────────────────────────────────
enum StatutTacheEncadrant { aFaire, enCours, termine }

extension StatutTacheEncadrantExt on StatutTacheEncadrant {
	String get uiLabel {
		switch (this) {
			case StatutTacheEncadrant.aFaire:  return 'À faire';
			case StatutTacheEncadrant.enCours: return 'En cours';
			case StatutTacheEncadrant.termine: return 'Terminé';
		}
	}

	String get apiValue {
		switch (this) {
			case StatutTacheEncadrant.aFaire:  return 'A_FAIRE';
			case StatutTacheEncadrant.enCours: return 'EN_COURS';
			case StatutTacheEncadrant.termine: return 'TERMINEE';
		}
	}

	static StatutTacheEncadrant fromApi(String v) {
		switch (v.toUpperCase()) {
			case 'EN_COURS':  return StatutTacheEncadrant.enCours;
			case 'TERMINEE':  return StatutTacheEncadrant.termine;
			case 'TERMINE':   return StatutTacheEncadrant.termine;
			default:          return StatutTacheEncadrant.aFaire;
		}
	}
}

// ── Priorité ──────────────────────────────────────────────
enum PrioriteTache { haute, moyenne, basse, critique }

extension PrioriteTacheExt on PrioriteTache {
	String get uiLabel {
		switch (this) {
			case PrioriteTache.haute:    return 'Haute';
			case PrioriteTache.moyenne:  return 'Moyenne';
			case PrioriteTache.basse:    return 'Basse';
			case PrioriteTache.critique: return 'Critique';
		}
	}

	String get apiValue {
		switch (this) {
			case PrioriteTache.haute:    return 'HAUTE';
			case PrioriteTache.moyenne:  return 'MOYENNE';
			case PrioriteTache.basse:    return 'BASSE';
			case PrioriteTache.critique: return 'CRITIQUE';
		}
	}

	static PrioriteTache fromApi(String v) {
		switch (v.toUpperCase()) {
			case 'HAUTE':    return PrioriteTache.haute;
			case 'BASSE':    return PrioriteTache.basse;
			case 'CRITIQUE': return PrioriteTache.critique;
			default:         return PrioriteTache.moyenne;
		}
	}
}

// ── Model ─────────────────────────────────────────────────
class TacheEncadrantModel {
	final int                  id;
	final int                  stagiaireId;
	final String               titre;
	final String               description;
	final StatutTacheEncadrant statut;
	final PrioriteTache        priorite;
	final DateTime?            dateEcheance;
	final List<String>         commentaires;

	const TacheEncadrantModel({
		required this.id,
		required this.stagiaireId,
		required this.titre,
		required this.description,
		required this.statut,
		this.priorite     = PrioriteTache.moyenne,
		this.dateEcheance,
		this.commentaires = const [],
	});

	factory TacheEncadrantModel.fromJson(Map<String, dynamic> j) {
		// ✅ Cherche stagiaireId direct OU dans l'objet stagiaire imbriqué
		final stagiaireId = j['stagiaireId'] as int?
				?? (j['stagiaire'] as Map<String, dynamic>?)?['id'] as int?
				?? 0;

		return TacheEncadrantModel(
			id:           j['id']          as int,
			stagiaireId:  stagiaireId,
			titre:        j['titre']       as String? ?? '',
			description:  j['description'] as String? ?? '',
			statut:       StatutTacheEncadrantExt.fromApi(
					j['statut'] as String? ?? 'A_FAIRE'),
			priorite:     j['priorite'] != null
					? PrioriteTacheExt.fromApi(j['priorite'] as String)
					: PrioriteTache.moyenne,
			dateEcheance: j['dateEcheance'] != null
					? DateTime.tryParse(j['dateEcheance'] as String)
					: null,
		);
	}

	Map<String, dynamic> toJson() => {
		'id':           id,
		'stagiaireId':  stagiaireId,
		'titre':        titre,
		'description':  description,
		'statut':       statut.apiValue,
		'priorite':     priorite.apiValue,
		'dateEcheance': dateEcheance?.toIso8601String().split('T')[0],
	};

	TacheEncadrantModel copyWith({
		List<String>?         commentaires,
		StatutTacheEncadrant? statut,
		PrioriteTache?        priorite,
	}) {
		return TacheEncadrantModel(
			id:           id,
			stagiaireId:  stagiaireId,
			titre:        titre,
			description:  description,
			statut:       statut       ?? this.statut,
			priorite:     priorite     ?? this.priorite,
			dateEcheance: dateEcheance,
			commentaires: commentaires ?? this.commentaires,
		);
	}
}