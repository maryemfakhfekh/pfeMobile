// lib/features/chat/data/repositories/message_repository.dart

import '../../../../core/api/dio_client.dart';
import '../models/message_model.dart';

class MessageRepository {
  final DioClient _api;
  MessageRepository(this._api);

  // GET /api/messages/{stagiaireId}
  Future<List<MessageModel>> getMessages(
      int stagiaireId, int myId) async {
    final res = await _api.dio.get('/messages/$stagiaireId');
    return (res.data as List)
        .map((e) => MessageModel.fromJson(
        e as Map<String, dynamic>, myId))
        .toList();
  }

  // POST /api/messages
  Future<MessageModel> sendMessage({
    required int    expediteurId,
    required int    destinataireId,
    required String contenu,
    required int    myId,
  }) async {
    final res = await _api.dio.post(
      '/messages',
      data: {
        'expediteurId':   expediteurId,
        'destinataireId': destinataireId,
        'contenu':        contenu,
      },
    );
    return MessageModel.fromJson(
        res.data as Map<String, dynamic>, myId);
  }
}