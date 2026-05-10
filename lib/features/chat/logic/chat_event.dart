// lib/features/stagiaire/logic/chat_event.dart

abstract class ChatEvent {}

// Charger la conversation avec un utilisateur
class LoadMessages extends ChatEvent {
  final int otherUserId; // stagiaireId selon le backend
  final int myId;
  LoadMessages(this.otherUserId, this.myId);
}

// Envoyer un message
class SendMessage extends ChatEvent {
  final int    expediteurId;
  final int    destinataireId;
  final String contenu;
  final int    myId;
  SendMessage({
    required this.expediteurId,
    required this.destinataireId,
    required this.contenu,
    required this.myId,
  });
}

// Rafraîchir les messages (polling)
class RefreshMessages extends ChatEvent {
  final int otherUserId;
  final int myId;
  RefreshMessages(this.otherUserId, this.myId);
}