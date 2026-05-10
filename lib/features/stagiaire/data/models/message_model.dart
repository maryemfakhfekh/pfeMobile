// lib/features/stagiaire/data/models/message_model.dart

class MessageModel {
  final int    id;
  final int    expediteurId;
  final int    destinataireId;
  final String contenu;
  final String dateEnvoi;
  final bool   lu;
  final bool   isMine;

  const MessageModel({
    required this.id,
    required this.expediteurId,
    required this.destinataireId,
    required this.contenu,
    required this.dateEnvoi,
    required this.lu,
    required this.isMine,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, int myId) {
    return MessageModel(
      id:             json['id']             as int,
      expediteurId:   json['expediteurId']   as int,
      destinataireId: json['destinataireId'] as int,
      contenu:        json['contenu']        as String,
      dateEnvoi:      json['dateEnvoi']      as String,
      lu:             json['lu']             as bool? ?? false,
      isMine:         json['expediteurId']   == myId,
    );
  }

  Map<String, dynamic> toJson() => {
    'expediteurId':   expediteurId,
    'destinataireId': destinataireId,
    'contenu':        contenu,
  };
}