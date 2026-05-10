// lib/features/stagiaire/data/models/tache_model.dart

enum TacheStatut   { aFaire, enCours, terminee }
enum TachePriorite { basse, moyenne, haute, critique }

class TacheModel {
  final int id;
  final String issueKey;
  final String titre;
  final String? description;
  final TacheStatut statut;
  final TachePriorite priorite;
  final String dateEcheance;
  final String? dateCreation;

  const TacheModel({
    required this.id,
    required this.issueKey,
    required this.titre,
    this.description,
    required this.statut,
    required this.priorite,
    required this.dateEcheance,
    this.dateCreation,
  });

  factory TacheModel.fromJson(Map<String, dynamic> json) => TacheModel(
    id:           json['id'] as int,
    issueKey:     'GS-${json['id']}',
    titre:        json['titre']        as String? ?? '',
    description:  json['description'] as String?,
    statut:       _parseStatut(json['statut']   as String?),
    priorite:     _parsePriorite(json['priorite'] as String?),
    dateEcheance: json['dateEcheance'] as String? ?? '',
    dateCreation: json['dateCreation'] as String?,
  );

  TacheModel copyWith({TacheStatut? statut}) => TacheModel(
    id:           id,
    issueKey:     issueKey,
    titre:        titre,
    description:  description,
    statut:       statut ?? this.statut,
    priorite:     priorite,
    dateEcheance: dateEcheance,
    dateCreation: dateCreation,
  );

  // ── Parsing depuis le backend ──────────────────────────
  // IMPORTANT : le backend utilise 'TERMINEE' (avec E final)
  // Côté encadrant (tache_encadrant_model.dart) doit aussi
  // utiliser 'TERMINEE' pour rester cohérent.
  static TacheStatut _parseStatut(String? s) => switch (s?.toUpperCase()) {
    'EN_COURS'  => TacheStatut.enCours,
    'TERMINEE'  => TacheStatut.terminee,
    _           => TacheStatut.aFaire,
  };

  static TachePriorite _parsePriorite(String? p) => switch (p?.toUpperCase()) {
    'HAUTE'    => TachePriorite.haute,
    'CRITIQUE' => TachePriorite.critique,
    'BASSE'    => TachePriorite.basse,
    _          => TachePriorite.moyenne,
  };

  // ── Valeur envoyée au backend ──────────────────────────
  String get statutBackend => switch (statut) {
    TacheStatut.enCours  => 'EN_COURS',
    TacheStatut.terminee => 'TERMINEE',
    TacheStatut.aFaire   => 'A_FAIRE',
  };
}