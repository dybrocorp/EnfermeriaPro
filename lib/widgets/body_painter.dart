import 'dart:math' as math;
import 'package:flutter/material.dart';

// --- System region definition ---
class BodySystemRegion {
  final String key;
  final String label;
  final String emoji;
  final Color color;
  // Hit boxes: normalized (0â€“1) fractions of canvas size, front view
  final List<Rect> frontRects;
  // Hit boxes for back view
  final List<Rect> backRects;
  // Paint centres for visual ellipses (normalized), front
  final List<Offset> frontCentres;
  final List<Size> frontSizes; // normalized radii * 2
  final List<Offset> backCentres;
  final List<Size> backSizes;

  const BodySystemRegion({
    required this.key,
    required this.label,
    required this.emoji,
    required this.color,
    required this.frontRects,
    required this.backRects,
    required this.frontCentres,
    required this.frontSizes,
    required this.backCentres,
    required this.backSizes,
  });
}

const List<BodySystemRegion> bodyRegions = [
  BodySystemRegion(
    key: 'nervioso',
    label: 'Nervioso',
    emoji: 'ðŸ§ ',
    color: Color(0xFF9C27B0),
    frontRects: [Rect.fromLTWH(0.36, 0.01, 0.28, 0.14)],
    backRects: [Rect.fromLTWH(0.36, 0.01, 0.28, 0.14), Rect.fromLTWH(0.44, 0.16, 0.12, 0.45)],
    frontCentres: [Offset(0.50, 0.075)],
    frontSizes: [Size(0.26, 0.12)],
    backCentres: [Offset(0.50, 0.075), Offset(0.50, 0.38)],
    backSizes: [Size(0.26, 0.12), Size(0.06, 0.40)],
  ),
  BodySystemRegion(
    key: 'endocrino',
    label: 'Endocrino',
    emoji: 'âš—ï¸',
    color: Color(0xFF00BCD4),
    frontRects: [Rect.fromLTWH(0.42, 0.155, 0.16, 0.055)],
    backRects: [],
    frontCentres: [Offset(0.50, 0.18)],
    frontSizes: [Size(0.14, 0.045)],
    backCentres: [],
    backSizes: [],
  ),
  BodySystemRegion(
    key: 'cardiovascular',
    label: 'Cardiovascular',
    emoji: 'â¤ï¸',
    color: Color(0xFFF44336),
    frontRects: [Rect.fromLTWH(0.35, 0.255, 0.18, 0.145)],
    backRects: [],
    frontCentres: [Offset(0.435, 0.33)],
    frontSizes: [Size(0.17, 0.13)],
    backCentres: [],
    backSizes: [],
  ),
  BodySystemRegion(
    key: 'respiratorio',
    label: 'Respiratorio',
    emoji: 'ðŸ«',
    color: Color(0xFF2196F3),
    frontRects: [Rect.fromLTWH(0.23, 0.215, 0.54, 0.23)],
    backRects: [Rect.fromLTWH(0.23, 0.215, 0.54, 0.23)],
    frontCentres: [Offset(0.305, 0.325), Offset(0.695, 0.325)],
    frontSizes: [Size(0.18, 0.20), Size(0.18, 0.20)],
    backCentres: [Offset(0.305, 0.325), Offset(0.695, 0.325)],
    backSizes: [Size(0.18, 0.20), Size(0.18, 0.20)],
  ),
  BodySystemRegion(
    key: 'digestivo',
    label: 'Digestivo',
    emoji: 'ðŸ«ƒ',
    color: Color(0xFFFF9800),
    frontRects: [Rect.fromLTWH(0.27, 0.40, 0.46, 0.18)],
    backRects: [],
    frontCentres: [Offset(0.50, 0.49)],
    frontSizes: [Size(0.40, 0.17)],
    backCentres: [],
    backSizes: [],
  ),
  BodySystemRegion(
    key: 'urinario',
    label: 'Urinario',
    emoji: 'ðŸ«˜',
    color: Color(0xFF4CAF50),
    frontRects: [Rect.fromLTWH(0.30, 0.535, 0.40, 0.105)],
    backRects: [Rect.fromLTWH(0.27, 0.395, 0.46, 0.14)],
    frontCentres: [Offset(0.50, 0.588)],
    frontSizes: [Size(0.36, 0.09)],
    backCentres: [Offset(0.34, 0.465), Offset(0.66, 0.465)],
    backSizes: [Size(0.11, 0.09), Size(0.11, 0.09)],
  ),
  BodySystemRegion(
    key: 'muscular',
    label: 'Muscular',
    emoji: 'ðŸ’ª',
    color: Color(0xFFFF5722),
    frontRects: [
      Rect.fromLTWH(0.06, 0.215, 0.155, 0.38),
      Rect.fromLTWH(0.785, 0.215, 0.155, 0.38),
    ],
    backRects: [
      Rect.fromLTWH(0.06, 0.215, 0.155, 0.38),
      Rect.fromLTWH(0.785, 0.215, 0.155, 0.38),
    ],
    frontCentres: [Offset(0.135, 0.405), Offset(0.865, 0.405)],
    frontSizes: [Size(0.13, 0.35), Size(0.13, 0.35)],
    backCentres: [Offset(0.135, 0.405), Offset(0.865, 0.405)],
    backSizes: [Size(0.13, 0.35), Size(0.13, 0.35)],
  ),
  BodySystemRegion(
    key: 'oseo',
    label: 'Ã“seo',
    emoji: 'ðŸ¦´',
    color: Color(0xFFCDDC39),
    frontRects: [
      Rect.fromLTWH(0.23, 0.63, 0.23, 0.36),
      Rect.fromLTWH(0.54, 0.63, 0.23, 0.36),
    ],
    backRects: [
      Rect.fromLTWH(0.23, 0.63, 0.23, 0.36),
      Rect.fromLTWH(0.54, 0.63, 0.23, 0.36),
    ],
    frontCentres: [Offset(0.345, 0.81), Offset(0.655, 0.81)],
    frontSizes: [Size(0.22, 0.34), Size(0.22, 0.34)],
    backCentres: [Offset(0.345, 0.81), Offset(0.655, 0.81)],
    backSizes: [Size(0.22, 0.34), Size(0.22, 0.34)],
  ),
];

// Returns the system key for a tap position (normalized 0â€“1 coords)
String? systemFromNormalizedTap(Offset normPos, bool isFrontView) {
  // Priority order: most specific first
  const order = [
    'nervioso', 'endocrino', 'cardiovascular',
    'respiratorio', 'digestivo', 'urinario', 'muscular', 'oseo'
  ];
  for (final key in order) {
    final region = bodyRegions.firstWhere((r) => r.key == key);
    final rects = isFrontView ? region.frontRects : region.backRects;
    for (final r in rects) {
      if (r.contains(normPos)) return key;
    }
  }
  return null;
}

// --- Body Painter ---
class BodyPainter extends CustomPainter {
  final String? selectedSystem;
  final double glowValue; // 0.0â€“1.0 animated
  final bool isFrontView;
  final bool nursingMode;

  const BodyPainter({
    required this.selectedSystem,
    required this.glowValue,
    required this.isFrontView,
    required this.nursingMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);
    _paintBodySilhouette(canvas, size);
    _paintSystemRegions(canvas, size);
    _paintGridLines(canvas, size);
  }

  void _paintBackground(Canvas canvas, Size size) {
    // Subtle radial glow in center
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          nursingMode ? const Color(0xFF1A0A30) : const Color(0xFF0A1628),
          const Color(0xFF0D1117),
        ],
        radius: 0.8,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  }

  void _paintGridLines(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;
    const step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _paintBodySilhouette(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPath = Path();
    // Head
    bodyPath.addOval(Rect.fromCenter(
      center: Offset(w * 0.50, h * 0.075),
      width: w * 0.26,
      height: h * 0.13,
    ));
    // Neck
    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.175), width: w * 0.12, height: h * 0.06),
      const Radius.circular(6),
    ));
    // Torso
    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.22, h * 0.21, w * 0.56, h * 0.41),
      const Radius.circular(18),
    ));
    // Left arm
    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.06, h * 0.21, w * 0.145, h * 0.41),
      const Radius.circular(10),
    ));
    // Right arm
    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.795, h * 0.21, w * 0.145, h * 0.41),
      const Radius.circular(10),
    ));
    // Left leg
    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.23, h * 0.625, w * 0.22, h * 0.36),
      const Radius.circular(12),
    ));
    // Right leg
    bodyPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.55, h * 0.625, w * 0.22, h * 0.36),
      const Radius.circular(12),
    ));

    // Body fill with gradient
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1E2A3A),
          Color(0xFF0F1923),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(bodyPath, fillPaint);

    // Outer glow / scan lines effect
    final outlinePaint = Paint()
      ..color = (nursingMode ? const Color(0xFF7B2FBE) : const Color(0xFF00BFA5)).withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6);
    canvas.drawPath(bodyPath, outlinePaint);

    // Highlight shine (top-left)
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(bodyPath, shinePaint);
  }

  void _paintSystemRegions(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    for (final region in bodyRegions) {
      final centres = isFrontView ? region.frontCentres : region.backCentres;
      final sizes = isFrontView ? region.frontSizes : region.backSizes;
      if (centres.isEmpty) continue;

      final isSelected = selectedSystem == region.key;
      final alpha = isSelected ? (0.55 + 0.3 * glowValue) : 0.28;
      final strokeAlpha = isSelected ? (0.9 + 0.1 * glowValue) : 0.5;

      for (int i = 0; i < centres.length; i++) {
        final centre = Offset(centres[i].dx * w, centres[i].dy * h);
        final ellipseW = sizes[i].width * w;
        final ellipseH = sizes[i].height * h;
        final rect = Rect.fromCenter(center: centre, width: ellipseW, height: ellipseH);

        // Glow when selected
        if (isSelected) {
          final glowPaint = Paint()
            ..color = region.color.withValues(alpha: 0.35 * glowValue)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18 * glowValue);
          canvas.drawOval(rect.inflate(10 * glowValue), glowPaint);
        }

        // Fill with radial gradient
        final fillPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              region.color.withValues(alpha: alpha),
              region.color.withValues(alpha: alpha * 0.4),
            ],
          ).createShader(rect);
        canvas.drawOval(rect, fillPaint);

        // Border
        final borderPaint = Paint()
          ..color = region.color.withValues(alpha: strokeAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 2.0 : 1.0;
        canvas.drawOval(rect, borderPaint);

        // Emoji + label text (only draw on first ellipse for multi-ellipse systems)
        if (i == 0) {
          _drawLabel(canvas, centre, region.emoji, region.label, region.color, isSelected, size);
        }
      }
    }
  }

  void _drawLabel(Canvas canvas, Offset centre, String emoji, String label,
      Color color, bool isSelected, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Emoji
    textPainter.text = TextSpan(
      text: emoji,
      style: TextStyle(fontSize: isSelected ? 16 : 12),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      centre.translate(-textPainter.width / 2, -textPainter.height / 2 - 6),
    );

    // Label text
    textPainter.text = TextSpan(
      text: label,
      style: TextStyle(
        color: isSelected ? Colors.white : color.withValues(alpha: 0.85),
        fontSize: isSelected ? 9.5 : 8.0,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        letterSpacing: 0.3,
      ),
    );
    textPainter.layout(maxWidth: size.width * 0.25);
    // Only show label when selected or region is big enough
    if (isSelected) {
      textPainter.paint(
        canvas,
        centre.translate(-textPainter.width / 2, 10),
      );
    }
  }

  @override
  bool shouldRepaint(BodyPainter oldDelegate) {
    return oldDelegate.selectedSystem != selectedSystem ||
        oldDelegate.glowValue != glowValue ||
        oldDelegate.isFrontView != isFrontView ||
        oldDelegate.nursingMode != nursingMode;
  }
}

// Scan-line painter for startup animation
class ScanLinePainter extends CustomPainter {
  final double progress; // 0â€“1
  const ScanLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) return;
    final y = size.height * progress;
    final scanPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Color(0x9900BFA5),
          Colors.transparent,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, y - 20, size.width, 40));
    canvas.drawRect(Rect.fromLTWH(0, y - 20, size.width, 40), scanPaint);

    // Horizontal scan line
    final linePaint = Paint()
      ..color = const Color(0xFF00BFA5).withValues(alpha: 0.8)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);

    // Circular crosshair at center column
    final cx = size.width / 2;
    final crossPaint = Paint()
      ..color = const Color(0xFF00BFA5).withValues(alpha: 0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final r = math.min(cx * 0.15, 12.0);
    canvas.drawCircle(Offset(cx, y), r, crossPaint);
    canvas.drawLine(Offset(cx - r * 1.8, y), Offset(cx - r * 0.5, y), linePaint);
    canvas.drawLine(Offset(cx + r * 0.5, y), Offset(cx + r * 1.8, y), linePaint);
  }

  @override
  bool shouldRepaint(ScanLinePainter old) => old.progress != progress;
}

