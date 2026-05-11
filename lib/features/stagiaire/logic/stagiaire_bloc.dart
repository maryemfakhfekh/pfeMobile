// lib/features/stagiaire/logic/stagiaire_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/stagiaire_repository.dart';
import '../data/models/stagiaire_model.dart';

part 'stagiaire_event.dart';
part 'stagiaire_state.dart';

class StagiaireBloc extends Bloc<StagiaireEvent, StagiaireState> {
  final StagiaireRepository repository;

  StagiaireBloc({required this.repository}) : super(StagiaireInitial()) {
    on<LoadDossier>(_onLoad);
    on<UpdateProfil>(_onUpdateProfil);
  }

  Future<void> _onLoad(
      LoadDossier event,
      Emitter<StagiaireState> emit,
      ) async {
    emit(StagiaireLoading());
    try {
      final dossier = await repository.getMonDossier();
      emit(StagiaireLoaded(dossier));
    } catch (e) {
      emit(StagiaireError(e.toString()));
    }
  }

  Future<void> _onUpdateProfil(
      UpdateProfil event,
      Emitter<StagiaireState> emit,
      ) async {
    // Garder le dossier actuel pour l'afficher pendant le chargement
    final current = state is StagiaireLoaded
        ? (state as StagiaireLoaded).dossier
        : state is ProfilUpdated
        ? (state as ProfilUpdated).dossier
        : null;

    if (current == null) return;

    emit(ProfilUpdating(current));
    try {
      final updated = await repository.updateProfil(
        nomComplet: event.nomComplet,
        email:      event.email,
        telephone:  event.telephone,
      );
      emit(ProfilUpdated(updated));
    } catch (e) {
      emit(ProfilUpdateError(current, e.toString()));
    }
  }
}