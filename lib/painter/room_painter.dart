import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RoomPainter extends CustomPainter {
  int sideA;
  int sideB;
  // int shortSideA;
  // int shortSideB;

  int canvasSize = 300;

  RoomPainter({required this.sideA, required this.sideB});

  @override
  void paint(Canvas canvas, Size size) {
    // // var rect = Rect.fromCenter(center: Offset.zero, width: 10, height: 10);
    // var rect = Rect.fromCenter(
    //     center: Offset.fromDirection(pi / 180 * 45, sqrt(300 * 300 / 2)),
    //     width: 10,
    //     height: 10);

    // var paint = Paint()
    //   ..color = Colors.teal
    //   ..strokeWidth = 15;

    // canvas.drawRect(rect, paint);
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;

    int maxSizeWidth = 250;
    double scaling = min(maxSizeWidth / sideB, maxSizeWidth / sideA);
    double doorLength = 80 * scaling;

    var scaledSideA = sideA * scaling;
    var scaledSideB = sideB * scaling;

    var leftStart = (canvasSize - scaledSideA) * .5;
    var leftEnd = leftStart + scaledSideA;

    var topStart = (canvasSize - scaledSideB) * .5;
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
  }

  @override
  bool shouldRepaint(RoomPainter oldDelegate) {
    return oldDelegate.sideA != sideA || oldDelegate.sideB != sideB;
  }
}
