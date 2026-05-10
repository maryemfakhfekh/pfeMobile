// lib/features/stagiaire/logic/stagiaire_state.dart

part of 'stagiaire_bloc.dart';

abstract class StagiaireState {}

class StagiaireInitial extends StagiaireState {}

class StagiaireLoading extends StagiaireState {}

class StagiaireLoaded extends StagiaireState {
  final StagiaireModel dossier;
  StagiaireLoaded(this.dossier);
}

class StagiaireError extends StagiaireState {
  final String message;
  StagiaireError(this.message);
}