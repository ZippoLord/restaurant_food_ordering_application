import 'dart:math';

import 'package:flutter/material.dart';

class AttentionButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const AttentionButton({super.key, required this.child, required this.onTap});

  @override
  State<AttentionButton> createState() => _AttentionButtonState();
}

class _AttentionButtonState extends State<AttentionButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // folyamatos körbefutás
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _BorderPainter(_controller.value),
                child: SizedBox(
                  width: 80,
                  height: 80,
                ),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  final double progress;
  _BorderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi / 2;
    double sweepAngle = 2 * pi * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _BorderPainter oldDelegate) => oldDelegate.progress != progress;
}
