// lib/features/encadrant/data/models/candidature_entretien_model.dart

class CandidatureEntretienModel {
  final int id;           // id de la CANDIDATURE (utilisé pour les questions)
  final int stagiaireId;  // id du stagiaire
  final String nomComplet;
  final String email;
  final String sujetTitre;
  final String filiere;
  final String statut;
  final String? dateEntretien;

  const CandidatureEntretienModel({
    required this.id,
    required this.stagiaireId,
    required this.nomComplet,
    required this.email,
    required this.sujetTitre,
    required this.filiere,
    required this.statut,
    this.dateEntretien,
  });

  factory CandidatureEntretienModel.fromJson(Map<String, dynamic> json) {
    // ✅ Le JSON du backend : { id, stagiaire: {id, nom, prenom, email, filiere: {nom}}, sujet: {titre}, statut, dateEntretien }
    final stagiaire = json['stagiaire'] as Map<String, dynamic>?;
    final sujet     = json['sujet']     as Map<String, dynamic>?;
    final filiere   = stagiaire?['filiere'] as Map<String, dynamic>?;

    final prenom = stagiaire?['prenom'] as String? ?? '';
    final nom    = stagiaire?['nom']    as String? ?? '';
    final nomComplet = '$prenom $nom'.trim();

    return CandidatureEntretienModel(
      id:            json['id'] as int,                          // ← id candidature
      stagiaireId:   stagiaire?['id'] as int? ?? json['id'] as int,
      nomComplet:    nomComplet,
      email:         stagiaire?['email']    as String? ?? '',
      sujetTitre:    sujet?['titre']        as String? ?? '',
      filiere:       filiere?['nom']        as String? ?? '',
      statut:        json['statut']         as String? ?? 'EN_ENTRETIEN',
      dateEntretien: json['dateEntretien']  as String?,
    );
  }
}

class QuestionEntretienModel {
  final int id;
  final String question;
  final String type; // technique, comportementale, projet, motivation

  const QuestionEntretienModel({
    required this.id,
    required this.question,
    required this.type,
  });

  factory QuestionEntretienModel.fromJson(Map<String, dynamic> json) {
    // ✅ Le JSON du backend : { id, question, category, source }
    return QuestionEntretienModel(
      id:       json['id']       as int?    ?? 0,
      question: json['question'] as String? ?? '',
      type:     json['category'] as String? ?? // ← "category" dans le JSON du backend
          json['type']     as String? ?? 'technique',
    );
  }
}