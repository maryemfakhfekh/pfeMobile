class StagiaireEncadrantModel {
  final int id;
  final int utilisateurId;
  final String nomComplet;
  final String email;
  final String sujetTitre;
  final String filiere;
  final String dateDebut;
  final String? dateFin;
  final int tachesTerminees;
  final int tachesTotales;
  final bool rapportDepose;
  final double progressionGlobale;

  const StagiaireEncadrantModel({
    required this.id,
    required this.utilisateurId,
    required this.nomComplet,
    required this.email,
    required this.sujetTitre,
    required this.filiere,
    required this.dateDebut,
    required this.dateFin,
    required this.tachesTerminees,
    required this.tachesTotales,
    required this.rapportDepose,
    required this.progressionGlobale,
  });

  String get initials {
    final parts = nomComplet.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  factory StagiaireEncadrantModel.fromJson(Map<String, dynamic> json) {
    final utilisateur = json['utilisateur'] as Map<String, dynamic>? ?? {};
    final sujet = json['sujet'] as Map<String, dynamic>? ?? {};
    final total = (json['tachesTotales'] ?? 0) as int;
    final termine = (json['tachesTerminees'] ?? 0) as int;

    // Gérer nom + prenom ou nomComplet
    String nom = '';
    if (utilisateur.containsKey('nom') && utilisateur.containsKey('prenom')) {
      nom = '${utilisateur['nom'] ?? ''} ${utilisateur['prenom'] ?? ''}'.trim();
    } else {
      nom = utilisateur['nomComplet'] as String? ?? '';
    }

    // Gérer filiereCible comme objet ou string
    String filiere = '';
    final filiereCible = sujet['filiereCible'];
    if (filiereCible is Map) {
      filiere = filiereCible['nom'] ?? '';
    } else if (filiereCible is String) {
      filiere = filiereCible;
    }

    return StagiaireEncadrantModel(
      id: json['id'] as int,
      utilisateurId: utilisateur['id'] as int? ?? 0,
      nomComplet: nom,
      email: utilisateur['email'] as String? ?? '',
      sujetTitre: sujet['titre'] as String? ?? '',
      filiere: filiere,
      dateDebut: json['dateDebut'] as String? ?? '',
      dateFin: json['dateFin'] as String?,
      tachesTerminees: termine,
      tachesTotales: total,
      rapportDepose: json['rapportDepose'] as bool? ?? false,
      progressionGlobale: total > 0 ? termine / total : 0.0,
    );
  }
}