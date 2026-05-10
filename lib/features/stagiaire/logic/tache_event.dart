// lib/features/stagiaire/logic/tache_event.dart

part of 'tache_bloc.dart';

abstract class TacheEvent {}

class LoadTaches extends TacheEvent {}

class UpdateStatutTache extends TacheEvent {
  final int         id;
  final TacheStatut statut;
  UpdateStatutTache(this.id, this.statut);
}