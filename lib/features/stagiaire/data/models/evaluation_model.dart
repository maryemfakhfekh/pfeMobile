// lib/features/stagiaire/data/models/evaluation_model.dart

class EvaluationModel {
  final int id;
  final double note;
  final String? commentaire;
  final String? dateEvaluation;

  EvaluationModel({required this.id, required this.note, this.commentaire, this.dateEvaluation});

  factory EvaluationModel.fromJson(Map<String, dynamic> json) => EvaluationModel(
    id:             json['id'],
    note:           (json['note'] as num).toDouble(),
    commentaire:    json['commentaire'],
    dateEvaluation: json['dateEvaluation'],
  );
}