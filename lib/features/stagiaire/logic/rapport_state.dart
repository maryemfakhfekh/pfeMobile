// lib/features/stagiaire/logic/rapport_state.dart

part of 'rapport_bloc.dart';

abstract class RapportState {}

class RapportInitial extends RapportState {}

class RapportLoading extends RapportState {}

class RapportLoaded extends RapportState {
  final RapportModel? rapport;
  RapportLoaded(this.rapport);
}

class RapportUploading extends RapportState {}

class RapportUploadSuccess extends RapportState {
  final RapportModel rapport;
  RapportUploadSuccess(this.rapport);
}

class RapportError extends RapportState {
  final String message;
  RapportError(this.message);
}