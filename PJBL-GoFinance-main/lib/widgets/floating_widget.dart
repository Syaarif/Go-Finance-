import 'dart:math' as math;
import 'package:flutter/material.dart';

class FloatingWidget extends StatefulWidget {
  final Widget child;
  final double distance;
  final Duration duration;

  const FloatingWidget({
    super.key,
    required this.child,
    this.distance = 6.0,
    this.duration = const Duration(milliseconds: 2200),
  });

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = math.sin(_controller.value * math.pi);
        return Transform.translate(
          offset: Offset(0, -value * widget.distance),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
