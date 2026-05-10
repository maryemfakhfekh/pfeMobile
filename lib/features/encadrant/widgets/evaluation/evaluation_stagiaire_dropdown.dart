// lib/features/encadrant/widgets/evaluation/evaluation_stagiaire_dropdown.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

class EvaluationStagiaireDropdown extends StatefulWidget {
  final List<StagiaireEncadrantModel> stagiaires;
  final StagiaireEncadrantModel? selected;
  final ValueChanged<StagiaireEncadrantModel> onSelected;

  const EvaluationStagiaireDropdown({
    super.key,
    required this.stagiaires,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<EvaluationStagiaireDropdown> createState() =>
      _EvaluationStagiaireDropdownState();
}

class _EvaluationStagiaireDropdownState
    extends State<EvaluationStagiaireDropdown> {
  bool _open = false;
  String _search = '';
  final _searchController = TextEditingController();

  static const List<Color> _avatarColors = [
    Color(0xFF5C6BC0),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
    Color(0xFFAB47BC),
    Color(0xFF42A5F5),
    Color(0xFFFF7043),
    Color(0xFF66BB6A),
    Color(0xFFEC407A),
  ];

  Color _colorFor(String initials) =>
      _avatarColors[initials.codeUnitAt(0) % _avatarColors.length];

  List<StagiaireEncadrantModel> get _filtered {
    if (_search.isEmpty) return widget.stagiaires;
    return widget.stagiaires
        .where((s) =>
    s.nomComplet.toLowerCase().contains(_search.toLowerCase()) ||
        s.sujetTitre.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ────────────────────────────────────
        Row(
          children: [
            const Icon(Icons.person_outline_rounded,
                size: 16, color: AppTheme.primary),
            const SizedBox(width: 6),
            Text(
              'Stagiaire à évaluer',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: AppTheme.textDark),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ── Trigger ──────────────────────────────────
        GestureDetector(
          onTap: () => setState(() => _open = !_open),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusLG),
              border: Border.all(
                color: _open ? AppTheme.primary : AppTheme.border,
                width: _open ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Avatar ou icône placeholder
                widget.selected != null
                    ? _Avatar(
                  initials: widget.selected!.initials,
                  color: _colorFor(widget.selected!.initials),
                  size: 32,
                )
                    : Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Icon(Icons.person_outline_rounded,
                      size: 18, color: AppTheme.textLight),
                ),
                const SizedBox(width: 12),

                // Nom ou placeholder
                Expanded(
                  child: widget.selected != null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selected!.nomComplet,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppTheme.textDark),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        widget.selected!.sujetTitre,
                        style:
                        Theme.of(context).textTheme.labelSmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  )
                      : Text(
                    'Choisir un stagiaire...',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppTheme.textLight),
                  ),
                ),

                Icon(
                  _open
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.textLight,
                  size: 22,
                ),
              ],
            ),
          ),
        ),

        // ── Dropdown ─────────────────────────────────
        if (_open) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusLG),
              border: Border.all(color: AppTheme.border),
              boxShadow: AppTheme.shadowMD,
            ),
            child: Column(
              children: [
                // ── Recherche ───────────────────────
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _search = v),
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: const Icon(Icons.search_rounded,
                          size: 18, color: AppTheme.textLight),
                      filled: true,
                      fillColor: AppTheme.background,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(AppTheme.radiusMD),
                        borderSide: BorderSide(color: AppTheme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(AppTheme.radiusMD),
                        borderSide: BorderSide(color: AppTheme.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(AppTheme.radiusMD),
                        borderSide: const BorderSide(
                            color: AppTheme.primary, width: 1.5),
                      ),
                    ),
                  ),
                ),

                // ── Liste ───────────────────────────
                if (_filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Aucun résultat',
                        style: Theme.of(context).textTheme.bodySmall),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => Divider(
                        height: 1, color: AppTheme.borderLight),
                    itemBuilder: (_, i) {
                      final s = _filtered[i];
                      final pct =
                      (s.progressionGlobale * 100).toInt();
                      final isSelected = widget.selected?.id == s.id;

                      return GestureDetector(
                        onTap: () {
                          widget.onSelected(s);
                          setState(() {
                            _open = false;
                            _search = '';
                            _searchController.clear();
                          });
                        },
                        child: Container(
                          color: isSelected
                              ? AppTheme.primarySoft
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              _Avatar(
                                initials: s.initials,
                                color: _colorFor(s.initials),
                                size: 40,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.nomComplet,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                        color: AppTheme.textDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 2),
                                    // ← Fix overflow ici
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            s.sujetTitre,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                            overflow:
                                            TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const Text(
                                          ' • ',
                                          style: TextStyle(
                                            color: AppTheme.textLight,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          '$pct%',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppTheme.primary,
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;

  const _Avatar({
    required this.initials,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: size * 0.35,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}