import 'package:flutter/material.dart';
import '../../controller/constants/constants.dart';

class ScratchPainter extends CustomPainter {
  final List<Offset> points;

  ScratchPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = greyColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ),
      basePaint,
    );

    final whitePaint = Paint()
      ..color = whiteColor
      ..style = PaintingStyle.fill;

    for (Offset point in points) {
      canvas.drawCircle(point, 20, whitePaint);
    }
  }

  @override
  bool shouldRepaint(covariant ScratchPainter oldDelegate) => true;
}
