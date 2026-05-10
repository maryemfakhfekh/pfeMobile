import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_encadrant_model.dart';

@RoutePage()
class RapportDetailPage extends StatefulWidget {
  final StagiaireEncadrantModel stagiaire;
  const RapportDetailPage({super.key, required this.stagiaire});

  @override
  State<RapportDetailPage> createState() => _RapportDetailPageState();
}

class _RapportDetailPageState extends State<RapportDetailPage> {
  final _commentaireController = TextEditingController();
  bool _isLoading = false;

  // ✅ État du rapport
  bool _rapportLoading = true;
  Map<String, dynamic>? _rapport;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _chargerRapport();
  }

  @override
  void dispose() {
    _commentaireController.dispose();
    super.dispose();
  }

  // ✅ Charge le rapport depuis l'API
  Future<void> _chargerRapport() async {
    try {
      final dio = DioClient().dio;
      final res = await dio.get(
        '/rapports/stagiaire/${widget.stagiaire.id}',
      );
      setState(() {
        _rapport = res.data as Map<String, dynamic>;
        _rapportLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _erreur = e.response?.statusCode == 404
            ? 'Aucun rapport déposé pour ce stagiaire.'
            : 'Erreur lors du chargement du rapport.';
        _rapportLoading = false;
      });
    } catch (_) {
      setState(() {
        _erreur = 'Erreur inattendue.';
        _rapportLoading = false;
      });
    }
  }

  void _submitComment() {
    if (_commentaireController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Veuillez écrire un commentaire',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Commentaire envoyé',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ));
      _commentaireController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(children: [
          _buildHeader(context),
          Expanded(
            child: _rapportLoading
                ? const Center(child: CircularProgressIndicator(
                color: AppTheme.primary))
                : _erreur != null
                ? _buildErreur()
                : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRapportCard(),
                  const SizedBox(height: 24),
                  _buildActions(),
                  const SizedBox(height: 24),
                  _buildCommentaireSection(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // ✅ Affichage si pas de rapport
  Widget _buildErreur() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(AppTheme.radiusLG),
              ),
              child: const Icon(Icons.description_outlined,
                  size: 36, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),
            Text(_erreur!,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppTheme.textDark),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Le stagiaire n\'a pas encore soumis son rapport.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                setState(() {
                  _rapportLoading = true;
                  _erreur = null;
                });
                _chargerRapport();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius:
                  BorderRadius.circular(AppTheme.radiusMD),
                ),
                child: const Text('Réessayer',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
      child: Row(children: [
        GestureDetector(
          onTap: () => context.router.back(),
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: AppTheme.darkSoft,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 15, color: AppTheme.dark),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rapport de stage',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: AppTheme.textDark)),
            Text('Consulter et commenter',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ]),
    );
  }

  Widget _buildRapportCard() {
    final s = widget.stagiaire;
    // ✅ Données réelles du rapport
    final dateDepot = _rapport?['dateDepot'] as String?;
    final fichierPath = _rapport?['fichierPath'] as String?;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: AppTheme.successSoft,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
          child: const Icon(Icons.picture_as_pdf_rounded,
              color: AppTheme.success, size: 32),
        ),
        const SizedBox(height: 14),
        Text('Rapport de stage disponible',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: AppTheme.textDark)),
        const SizedBox(height: 4),
        Text('Déposé par ${s.nomComplet}',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Text('Sujet : ${s.sujetTitre}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center),
        // ✅ Date de dépôt réelle
        if (dateDepot != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.successSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 12, color: AppTheme.success),
                const SizedBox(width: 6),
                Text('Déposé le $dateDepot',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.success)),
              ],
            ),
          ),
        ],
        // ✅ Nom du fichier
        if (fichierPath != null) ...[
          const SizedBox(height: 6),
          Text(
            fichierPath.split('/').last,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: AppTheme.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ]),
    );
  }

  Widget _buildActions() {
    final fichierPath = _rapport?['fichierPath'] as String?;

    return Row(children: [
      Expanded(
        child: GestureDetector(
          onTap: () {
            // TODO: ouvrir le fichier PDF
            if (fichierPath != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Fichier : $fichierPath'),
                behavior: SnackBarBehavior.floating,
              ));
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility_rounded,
                    color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Consulter',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: GestureDetector(
          onTap: () {
            // TODO: télécharger le fichier
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: AppTheme.dark,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_rounded,
                    color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Télécharger',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildCommentaireSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Laisser un commentaire',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppTheme.textDark)),
          const SizedBox(height: 12),
          TextField(
            controller: _commentaireController,
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              hintText: 'Votre retour sur le rapport...',
              contentPadding: EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _isLoading ? null : _submitComment,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: _isLoading
                    ? AppTheme.primary.withOpacity(0.6)
                    : AppTheme.primary,
                borderRadius:
                BorderRadius.circular(AppTheme.radiusMD),
                boxShadow: _isLoading ? [] : AppTheme.shadowOrange,
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                    : const Text('Envoyer le commentaire',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}