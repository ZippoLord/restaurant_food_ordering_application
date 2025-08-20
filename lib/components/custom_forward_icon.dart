import 'package:flutter/material.dart';

class AnimatedArrowIcon extends StatefulWidget {
  final VoidCallback? onTap;

  const AnimatedArrowIcon({super.key, this.onTap});

  @override
  State<AnimatedArrowIcon> createState() => _AnimatedArrowIconState();
}

class _AnimatedArrowIconState extends State<AnimatedArrowIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _offsetAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
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
      child: AnimatedBuilder(
        animation: _offsetAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_offsetAnimation.value, 0),
            child: child,
          );
        },
        child: const Icon(
          Icons.arrow_forward_ios,
          size: 25,
          color: Colors.deepOrange,
        ),
      ),
    );
  }
}
