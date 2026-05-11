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
    Color(0xFF1E293B),
    Color(0xFF0F6E56),
    Color(0xFF534AB7),
    Color(0xFF993556),
    Color(0xFF185FA5),
    Color(0xFF854F0B),
  ];

  Color _colorFor(int index) => _avatarColors[index % _avatarColors.length];

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

        // ── Label ────────────────────────────────────────
        const Text(
          'Stagiaire à évaluer',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),

        // ── Trigger ──────────────────────────────────────
        GestureDetector(
          onTap: () => setState(() => _open = !_open),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(_open ? 0 : 12),
                bottomRight: Radius.circular(_open ? 0 : 12),
              ),
              border: Border.all(
                color: _open ? AppTheme.primary : const Color(0xFFE2E8F0),
                width: _open ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                widget.selected != null
                    ? _Avatar(
                  initials: widget.selected!.initials,
                  color: _colorFor(
                      widget.stagiaires.indexOf(widget.selected!)),
                  size: 32,
                )
                    : Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: widget.selected != null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selected!.nomComplet,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.selected!.sujetTitre,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                      : const Text(
                    'Choisir un stagiaire...',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
                Icon(
                  _open
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF94A3B8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // ── Dropdown ─────────────────────────────────────
        if (_open)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: const Border(
                left: BorderSide(color: AppTheme.primary, width: 1.5),
                right: BorderSide(color: AppTheme.primary, width: 1.5),
                bottom: BorderSide(color: AppTheme.primary, width: 1.5),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ── Recherche ───────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFFE2E8F0), width: 0.5),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _search = v),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color(0xFF0F172A),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Rechercher...',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            size: 16,
                            color: Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),

                  const Divider(color: Color(0xFFE2E8F0), height: 1),

                  // ── Liste sans espace ────────────────────
                  if (_filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Aucun résultat',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    )
                  else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_filtered.length, (i) {
                        final s = _filtered[i];
                        final globalIndex = widget.stagiaires.indexOf(s);
                        final pct = (s.progressionGlobale * 100).toInt();
                        final isSelected = widget.selected?.id == s.id;
                        final isLast = i == _filtered.length - 1;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
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
                                    horizontal: 14, vertical: 10),
                                child: Row(
                                  children: [
                                    _Avatar(
                                      initials: s.initials,
                                      color: _colorFor(globalIndex),
                                      size: 38,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.nomComplet,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF0F172A),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Row(children: [
                                            Flexible(
                                              child: Text(
                                                s.sujetTitre,
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 10,
                                                  color: Color(0xFF94A3B8),
                                                ),
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Text(
                                              ' · ',
                                              style: TextStyle(
                                                color: Color(0xFF94A3B8),
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
                                          ]),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppTheme.primary,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (!isLast)
                              const Divider(
                                  color: Color(0xFFE2E8F0), height: 1),
                          ],
                        );
                      }),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────
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