// lib/features/stagiaire/data/repositories/evaluation_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/dio_client.dart';
import '../models/evaluation_model.dart';

class EvaluationRepository {
  final DioClient _api;
  final _storage = const FlutterSecureStorage();

  EvaluationRepository(this._api);

  Future<Options> _opts() async {
    final token = await _storage.read(key: 'token') ?? '';
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<EvaluationModel?> getMonEvaluation(int stagiaireId) async {
    try {
      final res = await _api.dio.get(
        '/evaluations/stagiaire/$stagiaireId',
        options: await _opts(),
      );
      return EvaluationModel.fromJson(res.data);
    } catch (_) {
      return null;
    }
  }
}