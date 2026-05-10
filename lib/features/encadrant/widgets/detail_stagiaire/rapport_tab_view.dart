import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/theme/app_theme.dart';

class RapportTabView extends StatefulWidget {
  final int stagiaireId;
  const RapportTabView({super.key, required this.stagiaireId});

  @override
  State<RapportTabView> createState() => _RapportTabViewState();
}

class _RapportTabViewState extends State<RapportTabView> {
  bool _loading = true;
  Map<String, dynamic>? _rapport;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _chargerRapport();
  }

  Future<void> _chargerRapport() async {
    setState(() {
      _loading = true;
      _erreur = null;
    });
    try {
      final res = await DioClient().dio.get(
        '/rapports/stagiaire/${widget.stagiaireId}',
      );
      setState(() {
        _rapport = res.data as Map<String, dynamic>;
        _loading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _erreur = e.response?.statusCode == 404 ? 'non_depose' : 'erreur';
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _erreur = 'erreur';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      );
    }
    if (_erreur != null) {
      return _RapportAbsent(onRetry: _chargerRapport);
    }
    return _RapportDisponible(rapport: _rapport!);
  }
}

// ── Rapport absent ─────────────────────────────────────────────
class _RapportAbsent extends StatelessWidget {
  final VoidCallback onRetry;
  const _RapportAbsent({required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: AppTheme.darkSoft,
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          ),
          child: const Icon(Icons.hourglass_empty_rounded,
              size: 32, color: AppTheme.dark),
        ),
        const SizedBox(height: 14),
        Text('Rapport non déposé',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: AppTheme.textDark)),
        const SizedBox(height: 6),
        Text(
          'Le stagiaire n\'a pas encore soumis\nson rapport de stage.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.3)),
            ),
            child: const Text('Actualiser',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary)),
          ),
        ),
      ]),
    ),
  );
}

// ── Rapport disponible ─────────────────────────────────────────
class _RapportDisponible extends StatefulWidget {
  final Map<String, dynamic> rapport;
  const _RapportDisponible({required this.rapport});

  @override
  State<_RapportDisponible> createState() => _RapportDisponibleState();
}

class _RapportDisponibleState extends State<_RapportDisponible> {
  // ✅ Mets ton IP réelle ici
  static const String _baseUrl = 'http://192.168.1.135:8085/api';
  bool _downloading = false;

  Future<void> _ouvrirFichier(String fichierPath,
      {bool telecharger = false}) async {
    final nomFichier = fichierPath.split('/').last;
    final url = '$_baseUrl/rapports/fichier/$nomFichier';

    setState(() => _downloading = true);

    try {
      // ✅ Afficher loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: const [
            SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Chargement du fichier...'),
          ]),
          duration: const Duration(seconds: 30),
          behavior: SnackBarBehavior.floating,
        ));
      }

      // ✅ Télécharger dans le dossier temporaire
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$nomFichier';

      await DioClient().dio.download(url, filePath);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // ✅ Ouvrir le fichier avec l'app native
      final result = await OpenFile.open(filePath);

      if (result.type != ResultType.done && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Impossible d\'ouvrir : ${result.message}'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateDepot = widget.rapport['dateDepot'] as String?;
    final fichierPath = widget.rapport['fichierPath'] as String?;
    final nomFichier = fichierPath?.split('/').last ?? 'rapport.pdf';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            boxShadow: AppTheme.shadowSM,
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: AppTheme.successSoft,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded,
                  color: AppTheme.success, size: 30),
            ),
            const SizedBox(height: 12),
            Text('Rapport disponible',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: AppTheme.textDark)),
            const SizedBox(height: 6),
            Text('Le stagiaire a soumis son rapport',
                style: Theme.of(context).textTheme.bodySmall),

            if (dateDepot != null) ...[
              const SizedBox(height: 10),
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

            if (fichierPath != null) ...[
              const SizedBox(height: 8),
              Text(nomFichier,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: AppTheme.textMuted),
                  textAlign: TextAlign.center),
            ],

            const SizedBox(height: 16),

            // ✅ Boutons
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: (!_downloading && fichierPath != null)
                      ? () => _ouvrirFichier(fichierPath)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: fichierPath != null
                          ? AppTheme.primary
                          : AppTheme.border,
                      borderRadius:
                      BorderRadius.circular(AppTheme.radiusMD),
                    ),
                    child: _downloading
                        ? const Center(
                      child: SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.visibility_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text('Consulter',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: (!_downloading && fichierPath != null)
                      ? () => _ouvrirFichier(fichierPath, telecharger: true)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: fichierPath != null
                          ? AppTheme.dark
                          : AppTheme.border,
                      borderRadius:
                      BorderRadius.circular(AppTheme.radiusMD),
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
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ],
    );
  }
}