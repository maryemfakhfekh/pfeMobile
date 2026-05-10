class EncadrantProfileModel {
  final int id;
  final String nomComplet;
  final String email;
  final String telephone;
  final String dateNaissance;
  final String? etablissement;
  final int stagairesCount;
  final DateTime dateCreation;

  EncadrantProfileModel({
    required this.id,
    required this.nomComplet,
    required this.email,
    required this.telephone,
    required this.dateNaissance,
    this.etablissement,
    required this.stagairesCount,
    required this.dateCreation,
  });

  factory EncadrantProfileModel.fromJson(Map<String, dynamic> json) {
    return EncadrantProfileModel(
      id: json['id'] ?? 0,
      nomComplet: json['nomComplet'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      dateNaissance: json['dateNaissance'] ?? '',
      etablissement: json['etablissement'],
      stagairesCount: json['stagairesCount'] ?? 0,
      dateCreation: json['dateCreation'] != null
          ? DateTime.parse(json['dateCreation'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomComplet': nomComplet,
      'email': email,
      'telephone': telephone,
      'dateNaissance': dateNaissance,
      'etablissement': etablissement,
      'stagairesCount': stagairesCount,
      'dateCreation': dateCreation.toIso8601String(),
    };
  }
}

