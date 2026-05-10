// lib/features/encadrant/data/models/sujet_model.dart

class SujetStageModel {
  final int id;
  final String titre;
  final String description;
  final String? filiereCible;
  final List<String> competencesCibles;

  SujetStageModel({
    required this.id,
    required this.titre,
    required this.description,
    this.filiereCible,
    required this.competencesCibles,
  });

  factory SujetStageModel.fromJson(Map<String, dynamic> json) {
    return SujetStageModel(
      id: json['id'] as int,
      titre: json['titre'] as String? ?? '',
      description: json['description'] as String? ?? '',
      filiereCible: json['filiereCible'] as String?,
      competencesCibles: (json['competencesCibles'] as List?)?.cast<String>() ?? [],
    );
  }
}