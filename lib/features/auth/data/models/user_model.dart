class UserModel {
  final String nom;
  final String prenom;
  final String email;
  final String password;
  final String telephone;
  final String dateNaissance;
  final String role;
  final String? etablissement;
  final int? cycleId;
  final int? filiereId;

  UserModel({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.telephone,
    required this.dateNaissance,
    required this.role,
    this.etablissement,
    this.cycleId,
    this.filiereId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "password": password,
      "telephone": telephone,
      "dateNaissance": dateNaissance,
      "role": role.toUpperCase().startsWith('ROLE_')
          ? role.toUpperCase()
          : 'ROLE_${role.toUpperCase()}',
    };
    if (etablissement != null) data['etablissement'] = etablissement;
    if (filiereId != null)     data['filiere'] = {"id": filiereId};
    if (cycleId != null)       data['cycle']   = {"id": cycleId};
    return data;
  }
}