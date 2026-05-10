// lib/features/stagiaire/logic/rapport_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/rapport_repository.dart';
import '../data/models/rapport_model.dart';

part 'rapport_event.dart';
part 'rapport_state.dart';

class RapportBloc extends Bloc<RapportEvent, RapportState> {
  final RapportRepository repository;

  RapportBloc({required this.repository}) : super(RapportInitial()) {
    on<LoadRapport>(_onLoad);
    on<DeposerRapport>(_onDeposer);
  }

  Future<void> _onLoad(LoadRapport event, Emitter<RapportState> emit) async {
    emit(RapportLoading());
    try {
      final rapport = await repository.getMonRapport();
      emit(RapportLoaded(rapport));
    } catch (e) {
      emit(RapportError(e.toString()));
    }
  }

  Future<void> _onDeposer(
      DeposerRapport event, Emitter<RapportState> emit) async {
    emit(RapportUploading());
    try {
      final rapport = await repository.deposerRapport(event.filePath, event.fileName);
      emit(RapportUploadSuccess(rapport));
    } catch (e) {
      emit(RapportError(e.toString()));
    }
  }
}