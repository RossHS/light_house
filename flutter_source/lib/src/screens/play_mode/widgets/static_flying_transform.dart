import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Статичный виджет, который добавляет статичное вращение дочернего виджета [child],
/// попытался сделать аналог анимации из игры Balatro
class StaticFlyingTransform extends StatefulWidget {
  const StaticFlyingTransform({super.key, required this.child});

  final Widget child;

  @override
  State<StaticFlyingTransform> createState() => _StaticFlyingTransformState();
}

class _StaticFlyingTransformState extends State<StaticFlyingTransform> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
      lowerBound: 0,
      upperBound: 2 * math.pi,
    );
    // Сбиваем начало проигрывания анимации. Дабы [widget.child] начинали с разных этапов анимации
    _controller.value = math.Random().nextDouble() * 2 * math.pi;
    _controller.repeat();
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
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(math.sin(_controller.value) / 9)
            ..rotateX(math.cos(_controller.value) / 9)
            ..rotateZ(math.sin(_controller.value) / 100),
          alignment: FractionalOffset.center,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
