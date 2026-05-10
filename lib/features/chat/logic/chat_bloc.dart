// lib/features/chat/logic/chat_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/message_model.dart';
import '../data/repositories/message_repository.dart';

// ── EVENTS ────────────────────────────────────────────────
abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final int stagiaireId;
  final int myId;
  LoadMessages(this.stagiaireId, this.myId);
}

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

class RefreshMessages extends ChatEvent {
  final int stagiaireId;
  final int myId;
  RefreshMessages(this.stagiaireId, this.myId);
}

// ── STATES ────────────────────────────────────────────────
abstract class ChatState {}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  ChatLoaded(this.messages);
}

class ChatSending extends ChatState {
  final List<MessageModel> messages;
  ChatSending(this.messages);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

// ── BLOC ──────────────────────────────────────────────────
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepository _repo;
  Timer? _pollingTimer;

  ChatBloc(this._repo) : super(ChatInitial()) {
    on<LoadMessages>(_onLoad);
    on<SendMessage>(_onSend);
    on<RefreshMessages>(_onRefresh);
  }

  Future<void> _onLoad(
      LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final msgs = await _repo.getMessages(
          event.stagiaireId, event.myId);
      emit(ChatLoaded(msgs));

      // Polling toutes les 12 secondes
      _pollingTimer?.cancel();
      _pollingTimer = Timer.periodic(
        const Duration(seconds: 12),
            (_) => add(RefreshMessages(event.stagiaireId, event.myId)),
      );
    } catch (e) {
      emit(ChatError('Impossible de charger les messages'));
    }
  }

  Future<void> _onRefresh(
      RefreshMessages event, Emitter<ChatState> emit) async {
    try {
      final msgs = await _repo.getMessages(
          event.stagiaireId, event.myId);
      emit(ChatLoaded(msgs));
    } catch (_) {}
  }

  Future<void> _onSend(
      SendMessage event, Emitter<ChatState> emit) async {
    final current = state is ChatLoaded
        ? (state as ChatLoaded).messages
        : <MessageModel>[];

    emit(ChatSending(current));
    try {
      final newMsg = await _repo.sendMessage(
        expediteurId:   event.expediteurId,
        destinataireId: event.destinataireId,
        contenu:        event.contenu,
        myId:           event.myId,
      );
      emit(ChatLoaded([...current, newMsg]));
    } catch (e) {
      emit(ChatLoaded(current));
    }
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}