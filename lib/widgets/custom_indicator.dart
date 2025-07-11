import 'package:flutter/material.dart';

class DotIndicator extends Decoration {
  final Color color;
  final double radius;

  const DotIndicator({this.color = Colors.red, this.radius = 4});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(color: color, radius: radius);
  }
}

class _DotPainter extends BoxPainter {
  final Color color;
  final double radius;

  _DotPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Offset circleOffset = Offset(
      offset.dx + configuration.size!.width / 2,
      offset.dy + configuration.size!.height - radius,
    );

    final Paint paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    canvas.drawCircle(circleOffset, radius, paint);
  }
}
