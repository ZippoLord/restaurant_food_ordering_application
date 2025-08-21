import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_drawer_tile.dart';

class AttentionOrder extends StatefulWidget {
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  const AttentionOrder({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  State<AttentionOrder> createState() => _AttentionOrderState();
}

class _AttentionOrderState extends State<AttentionOrder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            // Animated border
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _BorderPainter(_controller.value),
                  );
                },
              ),
            ),
            // Tile content
            CustomDrawerTile(
              text: widget.text,
              icon: widget.icon,
              onTap: widget.onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  final double progress;

  _BorderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final rect = Offset.zero & size;
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(8)));

    // Total path length approximation
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final extract = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(extract, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BorderPainter oldDelegate) => oldDelegate.progress != progress;
}
