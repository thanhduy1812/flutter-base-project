import 'package:cctv_stream_app/core/common_color/common_color.dart';
import 'package:flutter/material.dart';

class MasterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = Paint();
    paint1.strokeWidth = 2;
    paint1.color = gradientColor3;
    paint1.maskFilter = const MaskFilter.blur(BlurStyle.normal, 92);

    canvas.drawCircle(const Offset(140, 550), 180, paint1);

    Paint paint2 = Paint();
    paint2.strokeWidth = 2;
    paint2.color = gradientColor2;
    paint2.maskFilter = const MaskFilter.blur(BlurStyle.normal, 150);

    canvas.drawCircle(Offset(size.width / 1.8, 470), 230, paint2);

    Paint paint3 = Paint();
    paint3.strokeWidth = 2;
    paint3.color = gradientColor2;
    paint3.maskFilter = const MaskFilter.blur(BlurStyle.normal, 92);

    canvas.drawCircle(Offset(size.width / 1.2, 750), 180, paint3);

    Paint paint4 = Paint();
    paint4.strokeWidth = 2;
    paint4.color = gradientColor3;
    paint4.maskFilter = const MaskFilter.blur(BlurStyle.normal, 92);

    canvas.drawCircle(const Offset(0, 750), 220, paint4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
