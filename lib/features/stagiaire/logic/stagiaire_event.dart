// lib/features/stagiaire/logic/stagiaire_event.dart

part of 'stagiaire_bloc.dart';

abstract class StagiaireEvent {}

class LoadDossier extends StagiaireEvent {}

class UpdateProfil extends StagiaireEvent {
  final String nomComplet;
  final String email;
  final String telephone;

  UpdateProfil({
    required this.nomComplet,
    required this.email,
    required this.telephone,
  });
}