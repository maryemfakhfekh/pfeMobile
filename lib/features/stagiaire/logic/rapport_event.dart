// lib/features/stagiaire/logic/rapport_event.dart

part of 'rapport_bloc.dart';

abstract class RapportEvent {}

class LoadRapport extends RapportEvent {}

class DeposerRapport extends RapportEvent {
  final String filePath;
  final String fileName;
  DeposerRapport(this.filePath, this.fileName);
}