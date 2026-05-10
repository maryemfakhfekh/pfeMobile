// lib/features/stagiaire/data/models/rapport_model.dart

class RapportModel {
  final int id;
  final String? fichierPath;
  final String? dateDepot;

  RapportModel({required this.id, this.fichierPath, this.dateDepot});

  factory RapportModel.fromJson(Map<String, dynamic> json) => RapportModel(
    id:          json['id'],
    fichierPath: json['fichierPath'],
    dateDepot:   json['dateDepot'],
  );
}