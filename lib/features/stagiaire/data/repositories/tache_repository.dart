// lib/features/stagiaire/data/repositories/tache_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/dio_client.dart';
import '../models/tache_model.dart';

class TacheRepository {
  final DioClient _api;
  final _storage = const FlutterSecureStorage();

  TacheRepository(this._api);

  Future<Options> _opts() async {
    final token = await _storage.read(key: 'token') ?? '';
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  // GET /taches/mes-taches — stagiaire voit ses tâches
  Future<List<TacheModel>> getMesTaches() async {
    final res = await _api.dio.get(
      '/taches/mes-taches',
      options: await _opts(),
    );
    return (res.data as List)
        .map((j) => TacheModel.fromJson(j))
        .toList();
  }

  // PUT /taches/{id}/statut — stagiaire met à jour le statut
  Future<TacheModel> updateStatut(int id, String statut) async {
    final res = await _api.dio.put(
      '/taches/$id/statut',
      data: {'statut': statut},
      options: await _opts(),
    );
    return TacheModel.fromJson(res.data);
  }
}