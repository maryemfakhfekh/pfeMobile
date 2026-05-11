// lib/features/stagiaire/data/repositories/stagiaire_repository.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/dio_client.dart';
import '../models/stagiaire_model.dart';

class StagiaireRepository {
  final DioClient _api;
  final _storage = const FlutterSecureStorage();

  StagiaireRepository(this._api);

  Future<Options> _opts() async {
    final token = await _storage.read(key: 'token') ?? '';
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<StagiaireModel> getMonDossier() async {
    final res = await _api.dio.get(
      '/stages/mon-dossier',
      options: await _opts(),
    );
    return StagiaireModel.fromJson(res.data);
  }

  Future<bool> hasDossier() async {
    final res = await _api.dio.get(
      '/stages/has-dossier',
      options: await _opts(),
    );
    return res.data as bool;
  }

  Future<StagiaireModel> updateProfil({
    required String nomComplet,
    required String email,
    required String telephone,
  }) async {
    final res = await _api.dio.put(
      '/utilisateurs/mon-profil',
      data: {
        'nomComplet': nomComplet,
        'email': email,
        'telephone': telephone,
      },
      options: await _opts(),
    );
    return StagiaireModel.fromJson(res.data);
  }
}