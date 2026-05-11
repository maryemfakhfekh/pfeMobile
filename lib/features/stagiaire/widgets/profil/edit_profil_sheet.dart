// lib/features/stagiaire/widgets/profil/edit_profil_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_model.dart';
import '../../logic/stagiaire_bloc.dart';

class EditProfilSheet extends StatefulWidget {
  final StagiaireModel dossier;

  const EditProfilSheet({super.key, required this.dossier});

  static Future<void> show(BuildContext context, StagiaireModel dossier) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<StagiaireBloc>(),
        child: EditProfilSheet(dossier: dossier),
      ),
    );
  }

  @override
  State<EditProfilSheet> createState() => _EditProfilSheetState();
}

class _EditProfilSheetState extends State<EditProfilSheet> {
  late final TextEditingController _nomCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _telCtrl;

  @override
  void initState() {
    super.initState();
    final u = widget.dossier.utilisateur;
    _nomCtrl   = TextEditingController(text: u.nomComplet);
    _emailCtrl = TextEditingController(text: u.email);
    _telCtrl   = TextEditingController(text: u.telephone ?? '');
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final nom   = _nomCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final tel   = _telCtrl.text.trim();

    if (nom.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nom et email sont requis',
              style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    context.read<StagiaireBloc>().add(UpdateProfil(
      nomComplet: nom,
      email:      email,
      telephone:  tel,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20, 20, 20,
        MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Titre + fermer ────────────────────────────
          Row(children: [
            const Text(
              'Modifier le profil',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close_rounded,
                    size: 16, color: AppTheme.textSecond),
              ),
            ),
          ]),

          const SizedBox(height: 20),

          _EditField(
            controller: _nomCtrl,
            label: 'Nom complet',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),

          _EditField(
            controller: _emailCtrl,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),

          _EditField(
            controller: _telCtrl,
            label: 'Téléphone',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          // ── Bouton Enregistrer ────────────────────────
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Enregistrer',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Champ de saisie ─────────────────────────────────────────────────

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String        label;
  final IconData      icon;
  final TextInputType keyboardType;

  const _EditField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        color: AppTheme.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: AppTheme.textSecond,
        ),
        prefixIcon: Icon(icon, size: 18, color: AppTheme.primary),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: AppTheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
      ),
    );
  }
}