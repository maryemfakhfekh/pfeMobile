// lib/features/stagiaire/widgets/rapport/rapport_upload_zone.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../stagiaire_ui_tokens.dart';

class RapportUploadZone extends StatefulWidget {
  final void Function(String path, String name) onUpload;
  const RapportUploadZone({super.key, required this.onUpload});

  @override
  State<RapportUploadZone> createState() => _RapportUploadZoneState();
}

class _RapportUploadZoneState extends State<RapportUploadZone> {
  String? _fileName;
  String? _filePath;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // ── Fichier sélectionné ───────────────────────────
    if (_fileName != null && _filePath != null) {
      return Column(
        children: [

          Container(
            padding: const EdgeInsets.all(14),
            decoration: StagiaireUiTokens.cardDecoration(),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppTheme.error,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fileName!,
                        style: StagiaireUiTokens.cardTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Prêt à être soumis',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: StagiaireUiTokens.done,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _fileName = null;
                    _filePath = null;
                  }),
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppTheme.textLight,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => widget.onUpload(_filePath!, _fileName!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 18),
                  SizedBox(width: 10),
                  Text(
                    'Soumettre le rapport',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // ── Zone vide ─────────────────────────────────────
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.border,
            style: BorderStyle.solid,
            width: 1.5,
          ),
          boxShadow: AppTheme.shadowLight,
        ),
        child: Column(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                color: AppTheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Appuyez pour sélectionner',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Format PDF uniquement · Max 20 MB',
              style: StagiaireUiTokens.cardSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}