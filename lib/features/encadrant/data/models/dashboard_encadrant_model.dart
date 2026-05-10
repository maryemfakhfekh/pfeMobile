class DashboardEncadrantModel {
  final int stagiairesCount;
  final int tachesCreees;
  final int tachesEnAttente;
  final int notificationsEnAttente;

  const DashboardEncadrantModel({
    required this.stagiairesCount,
    required this.tachesCreees,
    required this.tachesEnAttente,
    required this.notificationsEnAttente,
  });

  factory DashboardEncadrantModel.fromJson(Map<String, dynamic> json) {
    return DashboardEncadrantModel(
      stagiairesCount: json['stagiairesCount'] ?? 0,
      tachesCreees: json['tachesCreees'] ?? 0,
      tachesEnAttente: json['tachesEnAttente'] ?? 0,
      notificationsEnAttente: json['notificationsEnAttente'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stagiairesCount': stagiairesCount,
      'tachesCreees': tachesCreees,
      'tachesEnAttente': tachesEnAttente,
      'notificationsEnAttente': notificationsEnAttente,
    };
  }
}

