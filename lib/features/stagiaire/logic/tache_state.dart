// lib/features/stagiaire/logic/tache_state.dart

part of 'tache_bloc.dart';

abstract class TacheState {}

class TacheInitial extends TacheState {}

class TacheLoading extends TacheState {}

class TacheLoaded extends TacheState {
  final List<TacheModel> taches;
  TacheLoaded(this.taches);
}

class TacheError extends TacheState {
  final String message;
  TacheError(this.message);
}