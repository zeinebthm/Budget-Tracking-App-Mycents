// ignore_for_file: deprecated_member_use
import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart'; // Für radians()

class CustomArchPainter extends CustomPainter {

  final double start;
  final double end;
  final double width;
  final double blurWidth;

  CustomArchPainter({this.start = 0, this.end = 270, this.width = 15, this.blurWidth = 6});

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    var gradientColor = LinearGradient(
      colors: [TColor.secondary, TColor.secondary50, TColor.secondary0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    Paint activePaint = Paint()..shader = gradientColor.createShader(rect);
    activePaint.style = PaintingStyle.stroke;
    activePaint.strokeWidth = 15;
    activePaint.strokeCap = StrokeCap.round;

    Paint backgroundPaint = Paint();
    backgroundPaint.color = TColor.gray60.withOpacity(0.5);
    backgroundPaint.style = PaintingStyle.stroke;
    backgroundPaint.strokeWidth = width;
    backgroundPaint.strokeCap = StrokeCap.round;

    Paint shadowPaint = Paint()
         ..color = TColor.secondary.withOpacity(0.3)
         ..style = PaintingStyle.stroke
         ..strokeWidth = width + blurWidth
         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    var startVal = 135.0 + start;

    // Unten offener Kreis: 135° Start, 270° Sweep
    canvas.drawArc(rect, radians(startVal), radians(end), false, backgroundPaint);
 
    //Draw Shadow Arch
    Path path = Path();
    path.addArc(rect, radians(startVal), radians(end));

    canvas.drawPath(path, shadowPaint);
    // Aktiver Bogen: z. B. 200° Fortschritt
    canvas.drawArc(rect, radians(startVal), radians(end), false, activePaint);
  }

  @override
  bool shouldRepaint(CustomArchPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CustomArchPainter oldDelegate) => false;
}
