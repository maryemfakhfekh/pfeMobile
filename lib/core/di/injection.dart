// lib/core/di/injection.dart

import 'package:get_it/get_it.dart';
import '../api/dio_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/logic/auth_bloc.dart';
import '../../features/internship/data/repositories/internship_repository.dart';
import '../../features/internship/logic/internship_bloc.dart';
import '../../features/encadrant/repositories/encadrant_repository.dart';
import '../../features/encadrant/logic/encadrant_bloc.dart';
import '../../features/stagiaire/data/repositories/stagiaire_repository.dart';
import '../../features/stagiaire/data/repositories/tache_repository.dart';
import '../../features/stagiaire/data/repositories/rapport_repository.dart';
import '../../features/stagiaire/data/repositories/evaluation_repository.dart';
import '../../features/stagiaire/logic/stagiaire_bloc.dart';
import '../../features/stagiaire/logic/tache_bloc.dart';
import '../../features/stagiaire/logic/rapport_bloc.dart';
import '../../features/chat/data/repositories/message_repository.dart';
import '../../features/chat/logic/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // ── Core ──────────────────────────────────────────────
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // ── Auth ──────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepository(sl<DioClient>()));
  sl.registerFactory<AuthBloc>(
          () => AuthBloc(authRepository: sl<AuthRepository>()));

  // ── Internship ────────────────────────────────────────
  sl.registerLazySingleton<InternshipRepository>(
          () => InternshipRepositoryImpl(sl<DioClient>()));
  sl.registerFactory<InternshipBloc>(
          () => InternshipBloc(repository: sl<InternshipRepository>()));

  // ── Encadrant ─────────────────────────────────────────
  sl.registerLazySingleton<EncadrantRepository>(
          () => EncadrantRepository(sl<DioClient>()));
  sl.registerFactory<EncadrantBloc>(
          () => EncadrantBloc(repository: sl<EncadrantRepository>()));

  // ── Stagiaire — repositories ──────────────────────────
  sl.registerLazySingleton<StagiaireRepository>(
          () => StagiaireRepository(sl<DioClient>()));
  sl.registerLazySingleton<TacheRepository>(
          () => TacheRepository(sl<DioClient>()));
  sl.registerLazySingleton<RapportRepository>(
          () => RapportRepository(sl<DioClient>()));
  sl.registerLazySingleton<EvaluationRepository>(
          () => EvaluationRepository(sl<DioClient>()));

  // ── Chat (partagé encadrant + stagiaire) ──────────────
  sl.registerLazySingleton<MessageRepository>(
          () => MessageRepository(sl<DioClient>()));
  sl.registerFactory<ChatBloc>(
          () => ChatBloc(sl<MessageRepository>()));

  // ── Stagiaire — blocs ─────────────────────────────────
  sl.registerFactory<StagiaireBloc>(
          () => StagiaireBloc(repository: sl<StagiaireRepository>()));
  sl.registerFactory<TacheBloc>(
          () => TacheBloc(repository: sl<TacheRepository>()));
  sl.registerFactory<RapportBloc>(
          () => RapportBloc(repository: sl<RapportRepository>()));
}