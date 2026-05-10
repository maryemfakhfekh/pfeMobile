// lib/features/stagiaire/logic/chat_state.dart

import '../data/models/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

// Messages chargés avec succès
class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  ChatLoaded(this.messages);
}

// En train d'envoyer (affiche les messages existants + message en cours)
class ChatSending extends ChatState {
  final List<MessageModel> messages;
  ChatSending(this.messages);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}