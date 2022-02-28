import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:path/path.dart';

class RoomPainter extends CustomPainter {
  int sideA;
  int sideB;
  // int shortSideA;
  // int shortSideB;

  int canvasHeight = 300;
  int canvasWidth;
  TextStyle style;

  RoomPainter(
      {required this.sideA,
      required this.sideB,
      required this.style,
      required this.canvasWidth});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3;

    var guideLines = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    int maxSizeWidth = 250;
    double scaling = min(maxSizeWidth / sideB, maxSizeWidth / sideA);
    double doorLength = 80 * scaling;

    var scaledSideA = sideA * scaling;
    var scaledSideB = sideB * scaling;

    doorLength = min(doorLength, scaledSideA * .5);

    var leftStart = (canvasWidth - scaledSideA) * .5;
    var leftEnd = leftStart + scaledSideA;

    var topStart = (canvasHeight - scaledSideB) * .5;
    var topEnd = topStart + scaledSideB;

    // Drawing 3 complete walls
    canvas.drawLine(
        Offset(leftStart, topStart), Offset(leftStart, topEnd), paint);
    canvas.drawLine(
        Offset(leftStart, topStart), Offset(leftEnd, topStart), paint);
    canvas.drawLine(Offset(leftStart, topEnd), Offset(leftEnd, topEnd), paint);

    // Drawing 4 wall with space for the door
    canvas.drawLine(Offset(leftEnd, topStart),
        Offset(leftEnd, topStart + (scaledSideB - doorLength) * .5), paint);
    canvas.drawLine(Offset(leftEnd, topEnd - (scaledSideB - doorLength) * .5),
        Offset(leftEnd, topEnd), paint);

    // Guidelines
    canvas.drawLine(Offset(leftStart, topEnd + 10),
        Offset(leftStart, topEnd + 50), guideLines);
    canvas.drawLine(
        Offset(leftEnd, topEnd + 10), Offset(leftEnd, topEnd + 50), guideLines);

    canvas.drawLine(Offset(leftStart - 10, topStart),
        Offset(leftStart - 50, topStart), guideLines);

    canvas.drawLine(Offset(leftStart - 10, topEnd),
        Offset(leftStart - 50, topEnd), guideLines);

    // Diagonal (small) decoration guidelines

    canvas.drawLine(Offset(leftStart - 35, topStart - 5),
        Offset(leftStart - 45, topStart + 5), guideLines);

    canvas.drawLine(Offset(leftStart - 35, topEnd - 5),
        Offset(leftStart - 45, topEnd + 5), guideLines);

    canvas.drawLine(Offset(leftStart + 5, topEnd + 35),
        Offset(leftStart - 5, topEnd + 45), guideLines);

    canvas.drawLine(Offset(leftEnd + 5, topEnd + 35),
        Offset(leftEnd - 5, topEnd + 45), guideLines);

    // Connecting guidelines - vertical
    canvas.drawLine(Offset(leftStart - 40, topStart - 15),
        Offset(leftStart - 40, topEnd + 15), guideLines);

    // Connecting guidelines - horizontal
    canvas.drawLine(Offset(leftStart - 15, topEnd + 40),
        Offset(leftEnd + 15, topEnd + 40), guideLines);

    var pcVertical = ParagraphConstraints(width: canvasHeight.toDouble());
    var pcHorizontal = ParagraphConstraints(width: canvasWidth.toDouble());
    var pb =
        ParagraphBuilder(style.getParagraphStyle(textAlign: TextAlign.center));
    // Draw labels - vertical
    pb.pushStyle(style.getTextStyle());
    pb.addText("$sideB mm");
    var text = pb.build();
    text.layout(pcVertical);

    canvas.save();
    canvas.translate(leftStart - 35, canvasHeight.toDouble());
    canvas.rotate(pi * -0.5); // 90deg
    canvas.drawParagraph(text, Offset(0, 0));

    canvas.restore();

    var pb2 =
        ParagraphBuilder(style.getParagraphStyle(textAlign: TextAlign.center));

    pb2.pushStyle(style.getTextStyle());
    pb2.addText("$sideA mm");

    text = pb2.build();
    text.layout(pcHorizontal);

    // Draw labels - horizontal
    canvas.drawParagraph(text, Offset(0, topEnd + 45));
  }

  @override
  bool shouldRepaint(RoomPainter oldDelegate) {
    return oldDelegate.sideA != sideA || oldDelegate.sideB != sideB;
  }
}
