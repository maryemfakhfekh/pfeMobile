// lib/features/encadrant/widgets/accueil/accueil_progression_card.dart

import 'dart:math';
import 'package:flutter/material.dart';

class AccueilProgressionCard extends StatelessWidget {
  final int enBonneVoie;
  final int aSurveiller;
  final int enRetard;
  final int total;

  const AccueilProgressionCard({
    super.key,
    required this.enBonneVoie,
    required this.aSurveiller,
    required this.enRetard,
    required this.total,
  });

  int get _pct => total > 0
      ? ((enBonneVoie / total) * 100).round()
      : 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progression globale',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  '$total stagiaires',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          // Donut + légende
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Donut
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CustomPaint(
                    painter: _DonutPainter(
                      enBonneVoie: enBonneVoie,
                      aSurveiller: aSurveiller,
                      enRetard: enRetard,
                      total: total,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_pct%',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'moyenne',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Légende
                Expanded(
                  child: Column(
                    children: [
                      _LegendRow(
                        color: const Color(0xFF1D9E75),
                        label: 'En bonne voie',
                        count: enBonneVoie,
                      ),
                      const SizedBox(height: 10),
                      _LegendRow(
                        color: const Color(0xFFEF9F27),
                        label: 'À surveiller',
                        count: aSurveiller,
                      ),
                      const SizedBox(height: 10),
                      _LegendRow(
                        color: const Color(0xFFE24B4A),
                        label: 'En retard',
                        count: enRetard,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                      ),
                      _LegendRow(
                        color: const Color(0xFFCBD5E1),
                        label: 'Total',
                        count: total,
                        isMuted: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Légende row ─────────────────────────────────────────────────────────────
class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final bool isMuted;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.count,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: isMuted ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            ),
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isMuted ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

// ─── CustomPainter donut ──────────────────────────────────────────────────────
class _DonutPainter extends CustomPainter {
  final int enBonneVoie;
  final int aSurveiller;
  final int enRetard;
  final int total;

  static const _strokeWidth = 10.0;
  static const _gap = 0.03; // gap en radians entre segments

  static const _colorOk = Color(0xFF1D9E75);
  static const _colorWarn = Color(0xFFEF9F27);
  static const _colorRetard = Color(0xFFE24B4A);
  static const _colorBg = Color(0xFFF1F5F9);

  _DonutPainter({
    required this.enBonneVoie,
    required this.aSurveiller,
    required this.enRetard,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - _strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    if (total == 0) {
      paint.color = _colorBg;
      canvas.drawArc(rect, 0, 2 * pi, false, paint);
      return;
    }

    // Fond gris
    paint.color = _colorBg;
    canvas.drawArc(rect, 0, 2 * pi, false, paint);

    final segments = [
      _Segment(_colorOk, enBonneVoie / total),
      _Segment(_colorWarn, aSurveiller / total),
      _Segment(_colorRetard, enRetard / total),
    ];

    double startAngle = -pi / 2;
    for (final seg in segments) {
      if (seg.fraction <= 0) continue;
      final sweep = (seg.fraction * 2 * pi) - _gap;
      if (sweep <= 0) continue;
      paint.color = seg.color;
      canvas.drawArc(rect, startAngle + _gap / 2, sweep, false, paint);
      startAngle += seg.fraction * 2 * pi;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.enBonneVoie != enBonneVoie ||
          old.aSurveiller != aSurveiller ||
          old.enRetard != enRetard ||
          old.total != total;
}

class _Segment {
  final Color color;
  final double fraction;
  const _Segment(this.color, this.fraction);
}