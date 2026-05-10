class ApiEndpoints {
  // Base
  static const String baseUrl = "http://192.168.1.135:8085/api";

  // Auth
  static const String login    = "/auth/login";
  static const String register = "/auth/register";

  // Références
  static const String filieres = "/references/filieres";
  static const String cycles   = "/references/cycles";

  // Sujets
  static const String subjects           = "/sujets";
  static const String subjectsDisponibles = "/sujets/disponibles";
  static const String addSubject         = "/sujets/add";

  // Stages (ancien "stagiaires")
  static const String stages       = "/stages";
  static const String stageProfil  = "/stages/mon-dossier";
  static const String hasDossier   = "/stages/has-dossier";
  static const String postuler     = "/candidatures/postuler";

  // Tâches stagiaire
  static const String mesTaches = "/taches/mes-taches";
  static String tacheStatut(int id) => "/taches/$id/statut";

  // Rapport stagiaire
  static const String deposerRapport = "/rapports/deposer";
  static const String monRapport     = "/rapports/mon-rapport";

  // ── Encadrant ──────────────────────────────────────────
  static const String encadrantStagiaires = "/encadrants/mes-stagiaires";
  static const String encadrantDashboard  = "/encadrants/dashboard";
  static const String encadrantProfile    = "/encadrants/profile";

  static const String encadrantTaches = "/taches";
  static String encadrantTachesByStagiaire(int stagiaireId) =>
      "/taches/stagiaire/$stagiaireId";
  static String creerTachePourStagiaire(int stagiaireId) =>
      "/taches/stagiaire/$stagiaireId";
  static String encadrantTacheById(int tacheId) =>
      "/taches/$tacheId";
  static String encadrantTacheStatut(int tacheId) =>
      "/taches/$tacheId/statut";
  static String encadrantTacheCommentaires(int tacheId) =>
      "/taches/$tacheId/commentaires";

  // Évaluations
  static String encadrantEvaluations = "/evaluations";
  static String encadrantEvaluationByStagiaire(int stagiaireId) =>
      "/evaluations/stagiaire/$stagiaireId";

  // Rapports encadrant
  static String rapportByStagiaire(int stagiaireId) =>
      "/rapports/stagiaire/$stagiaireId";

  // Messages
  static String conversation(int stagiaireId) => "/messages/$stagiaireId";
  static const String envoyerMessage = "/messages";
}