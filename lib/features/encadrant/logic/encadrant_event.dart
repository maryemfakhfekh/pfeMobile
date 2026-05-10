// lib/features/encadrant/logic/encadrant_event.dart

import '../data/models/tache_encadrant_model.dart';

abstract class EncadrantEvent {}

class EncadrantDashboardRequested extends EncadrantEvent {}
class EncadrantStagiairesRequested extends EncadrantEvent {}

class EncadrantTachesRequested extends EncadrantEvent {
  final int stagiaireId;
  EncadrantTachesRequested(this.stagiaireId);
}

class EncadrantTacheCreated extends EncadrantEvent {
  final int                  stagiaireId;
  final String               titre;
  final String               description;
  final DateTime             dateEcheance;
  final StatutTacheEncadrant statut;
  final PrioriteTache        priorite;

  EncadrantTacheCreated({
    required this.stagiaireId,
    required this.titre,
    required this.description,
    required this.dateEcheance,
    required this.statut,
    this.priorite = PrioriteTache.moyenne,
  });
}

class EncadrantTacheUpdated extends EncadrantEvent {
  final TacheEncadrantModel tache;
  EncadrantTacheUpdated(this.tache);
}

class EncadrantStatutTacheChanged extends EncadrantEvent {
  final int                  stagiaireId;
  final int                  tacheId;
  final StatutTacheEncadrant statut;

  EncadrantStatutTacheChanged({
    required this.stagiaireId,
    required this.tacheId,
    required this.statut,
  });
}

class EncadrantTacheDeleted extends EncadrantEvent {
  final int stagiaireId;
  final int tacheId;
  EncadrantTacheDeleted({
    required this.stagiaireId,
    required this.tacheId,
  });
}

class EncadrantCommentaireTacheAdded extends EncadrantEvent {
  final int    stagiaireId;
  final int    tacheId;
  final String commentaire;
  EncadrantCommentaireTacheAdded({
    required this.stagiaireId,
    required this.tacheId,
    required this.commentaire,
  });
}

class EncadrantEvaluationSubmitted extends EncadrantEvent {
  final int    stagiaireId;
  final double note;
  final String commentaire;
  EncadrantEvaluationSubmitted({
    required this.stagiaireId,
    required this.note,
    required this.commentaire,
  });
}

// ── Candidatures ─────────────────────────────────────────────
class EncadrantCandidaturesRequested extends EncadrantEvent {}

class EncadrantQuestionsIARequested extends EncadrantEvent {
  final int stagiaireId;
  EncadrantQuestionsIARequested(this.stagiaireId);
}

// ✅ Un seul event — marquer réalisé avec commentaire obligatoire
class EncadrantEntretienRealise extends EncadrantEvent {
  final int    stagiaireId;
  final String commentaire;
  EncadrantEntretienRealise({
    required this.stagiaireId,
    required this.commentaire,
  });
}
// ❌ EncadrantEntretienRefuse → SUPPRIMÉ