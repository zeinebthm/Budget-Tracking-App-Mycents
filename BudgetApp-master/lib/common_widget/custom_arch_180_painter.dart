// ignore_for_file: deprecated_member_use
import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart'; // Für radians()

class ArcValueModel {
  final Color color;
  final double value;

  ArcValueModel({required this.color, required this.value});
}


class CustomArch180Painter extends CustomPainter {

  final double start;
  final double end;
  final double width;
  final double bgwidth;
  final double blurWidth;
  final double space;
  final List<ArcValueModel> drwArcs;

  CustomArch180Painter(
    {required this.drwArcs , this.start = 0, this.end = 180, this.space = 5, this.width = 15, this.bgwidth = 10, this.blurWidth = 6});

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height),
      radius: size.width / 2,
    );

    Paint backgroundPaint = Paint();
    backgroundPaint.color = TColor.gray60.withOpacity(0.5);
    backgroundPaint.style = PaintingStyle.stroke;
    backgroundPaint.strokeWidth = bgwidth;
    backgroundPaint.strokeCap = StrokeCap.round;

    var startVal = 180.0 + start;
    var drawStart = startVal;
    canvas.drawArc(
      rect, radians(startVal), radians(180), false, backgroundPaint);

    for(var arcObj in drwArcs){

    var endVal = drawStart + arcObj.value;

    Paint activePaint = Paint();
    activePaint.color = arcObj.color;
    activePaint.style = PaintingStyle.stroke;
    activePaint.strokeWidth = width;
    activePaint.strokeCap = StrokeCap.round;

    Paint shadowPaint = Paint()
         ..color = arcObj.color.withOpacity(0.3)
         ..style = PaintingStyle.stroke
         ..strokeWidth = width + blurWidth
         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
 
    Path path = Path();
    path.addArc(rect, radians(drawStart), radians(arcObj.value - space));
    canvas.drawPath(path, shadowPaint);

    canvas.drawArc(rect, radians(drawStart), radians(arcObj.value - space), false, activePaint);

    drawStart = endVal + space;

    }

  }

  @override
  bool shouldRepaint(CustomArch180Painter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CustomArch180Painter oldDelegate) => false;
}
