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
}