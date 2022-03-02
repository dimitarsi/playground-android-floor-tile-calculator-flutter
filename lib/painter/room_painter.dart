import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:path/path.dart';

class RoomOffset {
  double leftStart;
  double leftEnd;
  double topStart;
  double topEnd;
  double innerOffset;

  RoomOffset(
      {required this.leftEnd,
      required this.leftStart,
      required this.topEnd,
      required this.topStart,
      this.innerOffset = 5});

  Offset get topLeft {
    return Offset(leftStart, topStart);
  }

  Offset get topRight {
    return Offset(leftEnd, topStart);
  }

  Offset get bottomLeft {
    return Offset(leftStart, topEnd);
  }

  Offset get bottomRight {
    return Offset(leftEnd, topEnd);
  }

  double get leftInnerStart {
    return leftStart + innerOffset;
  }

  double get leftInnerEnd {
    return leftEnd - innerOffset;
  }

  double get topInnerStart {
    return topStart + innerOffset;
  }

  double get topInnerEnd {
    return topEnd - innerOffset;
  }

  Offset get topInnerLeft {
    return Offset(leftStart + innerOffset, topStart + innerOffset);
  }

  Offset get topInnerRight {
    return Offset(leftEnd - innerOffset, topStart + innerOffset);
  }

  Offset get bottomInnerLeft {
    return Offset(leftStart + innerOffset, topEnd - innerOffset);
  }

  Offset get bottomInnerRight {
    return Offset(leftEnd - innerOffset, topEnd - innerOffset);
  }
}

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

  double getDoorLength() {
    int maxSizeWidth = 250;
    double scaling = min(maxSizeWidth / sideB, maxSizeWidth / sideA);
    double doorLength = 80 * scaling;

    var scaledSideA = sideA * scaling;

    return min(doorLength, scaledSideA * .5);
  }

  double getScaledSideA() {
    int maxSizeWidth = 250;
    double scaling = min(maxSizeWidth / sideB, maxSizeWidth / sideA);
    double doorLength = 80 * scaling;

    return sideA * scaling;
  }

  double getScaledSideB() {
    int maxSizeWidth = 250;
    double scaling = min(maxSizeWidth / sideB, maxSizeWidth / sideA);
    double doorLength = 80 * scaling;

    return sideB * scaling;
  }

  RoomOffset getRoomOffset() {
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

    return RoomOffset(
        leftEnd: leftEnd,
        leftStart: leftStart,
        topEnd: topEnd,
        topStart: topStart);
  }

  void _drawOuterWalls(Canvas canvas, Paint paint) {
    var offset = getRoomOffset();
    canvas.drawLine(offset.topRight, offset.topLeft, paint);
    canvas.drawLine(offset.topLeft, offset.bottomLeft, paint);
    canvas.drawLine(offset.bottomLeft, offset.bottomRight, paint);
  }

  void _drawInnerWalls(Canvas canvas, Paint paint) {
    var offset = getRoomOffset();
    offset.innerOffset = 10;
    canvas.drawLine(offset.topInnerRight, offset.topInnerLeft, paint);
    canvas.drawLine(offset.topInnerLeft, offset.bottomInnerLeft, paint);
    canvas.drawLine(offset.bottomInnerLeft, offset.bottomInnerRight, paint);
  }

  void _drawRightWall(Canvas canvas, Paint paint) {
    var offset = getRoomOffset();
    var doorLength = getDoorLength();
    var scaledSideB = getScaledSideB();
    // Drawing 4 wall with space for the door
    canvas.drawLine(
        offset.topRight,
        Offset(
            offset.leftEnd, offset.topStart + (scaledSideB - doorLength) * .5),
        paint);
    canvas.drawLine(
        Offset(offset.leftEnd, offset.topEnd - (scaledSideB - doorLength) * .5),
        offset.bottomRight,
        paint);
  }

  void _drawRightInnerWall(Canvas canvas, Paint paint) {
    var offset = getRoomOffset();
    var doorLength = getDoorLength();
    var scaledSideB = getScaledSideB();
    offset.innerOffset = 10;
    // Drawing 4 wall with space for the door
    var doorTopStart = offset.topStart + (scaledSideB - doorLength) * .5;
    var doorTopEnd = offset.topEnd - (scaledSideB - doorLength) * .5;

    canvas.drawLine(
        offset.topInnerRight, Offset(offset.leftInnerEnd, doorTopStart), paint);
    canvas.drawLine(Offset(offset.leftInnerEnd, doorTopEnd),
        offset.bottomInnerRight, paint);
  }

  void _drawConnectInnerWalls(Canvas canvas, Paint paint) {
    var offset = getRoomOffset();
    var doorLength = getDoorLength();
    var scaledSideB = getScaledSideB();
    offset.innerOffset = 10;

    var doorTopStart = offset.topStart + (scaledSideB - doorLength) * .5;
    var doorTopEnd = offset.topEnd - (scaledSideB - doorLength) * .5;

    canvas.drawLine(Offset(offset.leftInnerEnd, doorTopStart),
        Offset(offset.leftEnd, doorTopStart), paint);

    canvas.drawLine(Offset(offset.leftInnerEnd, doorTopEnd),
        Offset(offset.leftEnd, doorTopEnd), paint);
  }

  void _drawDoort(Canvas canvas, Paint paint) {
    var offset = getRoomOffset();
    var doorLength = getDoorLength();
    var scaledSideB = getScaledSideB();
    offset.innerOffset = 10;

    var doorTopStart = offset.topStart + (scaledSideB - doorLength) * .5;
    var doorTopEnd = offset.topEnd - (scaledSideB - doorLength) * .5;

    // canvas.drawLine(Offset(offset.leftInnerEnd, doorTopStart),
    //     Offset(offset.leftEnd, doorTopStart), paint);

    // canvas.drawLine(Offset(offset.leftInnerEnd, doorTopEnd),
    //     Offset(offset.leftEnd, doorTopEnd), paint);

    var closedDoorPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    canvas.save();
    canvas.translate(offset.leftEnd, doorTopStart); // door pivot point
    canvas.drawLine(Offset(-offset.innerOffset, 0),
        Offset(-offset.innerOffset, doorLength), closedDoorPaint);
    canvas.rotate(pi * -.05); //9 deg,
    canvas.drawLine(Offset(0, 0), Offset(0, doorLength), paint);

    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

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

    _drawOuterWalls(canvas, paint);
    _drawInnerWalls(canvas, paint);
    _drawRightWall(canvas, paint);
    _drawRightInnerWall(canvas, paint);
    _drawConnectInnerWalls(canvas, paint);
    _drawDoort(canvas, paint);

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
