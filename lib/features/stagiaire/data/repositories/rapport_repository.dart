// lib/features/stagiaire/data/repositories/rapport_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/dio_client.dart';
import '../models/rapport_model.dart';

class RapportRepository {
  final DioClient _api;
  final _storage = const FlutterSecureStorage();

  RapportRepository(this._api);

  Future<Options> _opts() async {
    final token = await _storage.read(key: 'token') ?? '';
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<RapportModel?> getMonRapport() async {
    try {
      final res = await _api.dio.get('/rapports/mon-rapport', options: await _opts());
      return RapportModel.fromJson(res.data);
    } catch (_) {
      return null;
    }
  }

  Future<RapportModel> deposerRapport(String filePath, String fileName) async {
    final token = await _storage.read(key: 'token') ?? '';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    final res = await _api.dio.post(
      '/rapports/deposer',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return RapportModel.fromJson(res.data);
  }
}