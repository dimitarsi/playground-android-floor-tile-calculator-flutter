import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.black;

    canvas.drawRect(
        Rect.fromCircle(center: Offset(200, 200), radius: 50), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
