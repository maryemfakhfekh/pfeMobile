// lib/features/chat/data/models/message_model.dart

class MessageModel {
  final int    id;
  final int    expediteurId;
  final int    destinataireId;
  final String contenu;
  final String dateEnvoi;
  final bool   isMine;

  const MessageModel({
    required this.id,
    required this.expediteurId,
    required this.destinataireId,
    required this.contenu,
    required this.dateEnvoi,
    required this.isMine,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, int myId) {
    final expediteurId =
    (json['expediteurId'] ?? json['expediteur']?['id'] ?? 0) as int;
    return MessageModel(
      id:             (json['id'] ?? 0) as int,
      expediteurId:   expediteurId,
      destinataireId: (json['destinataireId'] ??
          json['destinataire']?['id'] ?? 0) as int,
      contenu:   json['contenu']   as String? ?? '',
      dateEnvoi: json['dateEnvoi'] as String? ??
          DateTime.now().toIso8601String(),
      isMine:    expediteurId == myId,
    );
  }
}