// lib/core/models/user_model.dart

class UtilisateurModel {
  final int id;
  final String nomComplet;
  final String email;
  final String? telephone;
  final String? etablissement;
  final String role;

  UtilisateurModel({
    required this.id,
    required this.nomComplet,
    required this.email,
    this.telephone,
    this.etablissement,
    required this.role,
  });

  factory UtilisateurModel.fromJson(Map<String, dynamic> json) {
    return UtilisateurModel(
      id: json['id'] as int,
      nomComplet: json['nomComplet'] as String? ?? '',
      email: json['email'] as String? ?? '',
      telephone: json['telephone'] as String?,
      etablissement: json['etablissement'] as String?,
      role: json['role'] as String? ?? '',
    );
  }
}