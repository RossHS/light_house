import 'dart:math' as math;

import 'package:flutter/material.dart';

class DeleteItemWidget extends StatefulWidget {
  const DeleteItemWidget({
    super.key,
    required this.child,
    this.delete = false,
    this.closeColor = Colors.black,
  });

  final Widget child;
  final bool delete;
  final Color closeColor;

  @override
  State<DeleteItemWidget> createState() => _DeleteItemWidgetState();
}

class _DeleteItemWidgetState extends State<DeleteItemWidget> with TickerProviderStateMixin {
  late final AnimationController _deleteController;
  late final Animation<double> _deleteAnimation;

  @override
  void initState() {
    super.initState();
    _deleteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _deleteAnimation = CurvedAnimation(
      parent: _deleteController,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeInCubic,
    );

    if (widget.delete) {
      _deleteController.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant DeleteItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.delete != widget.delete) {
      _animateToValue();
    }
  }

  @override
  void dispose() {
    _deleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        foregroundPainter: _ClosePainter(
          animation: _deleteAnimation,
          closeColor: widget.closeColor,
        ),
        child: widget.child,
      ),
    );
  }

  void _animateToValue() {
    if (widget.delete) {
      _deleteController.forward();
    } else {
      _deleteController.reverse();
    }
  }
}

/// Отрисовка индикации закрытия, красный круг с крестиком
class _ClosePainter extends CustomPainter {
  _ClosePainter({
    required this.animation,
    required this.closeColor,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color closeColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (animation.value == 0) return;
    final radius = (size.width / 3.5) * animation.value;
    final circle = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    final closePaint = Paint()
      ..color = closeColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(
        circle.center.dx + radius * math.cos(_degreesToRadians(40)),
        circle.center.dy + radius * math.sin(_degreesToRadians(40)),
      ),
      Offset(
        circle.center.dx - radius * math.cos(_degreesToRadians(40)),
        circle.center.dy - radius * math.sin(_degreesToRadians(40)),
      ),
      closePaint,
    );

    canvas.drawLine(
      Offset(
        circle.center.dx + radius * math.cos(_degreesToRadians(-40)),
        circle.center.dy + radius * math.sin(_degreesToRadians(-40)),
      ),
      Offset(
        circle.center.dx - radius * math.cos(_degreesToRadians(-40)),
        circle.center.dy - radius * math.sin(_degreesToRadians(-40)),
      ),
      closePaint,
    );
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }

  @override
  bool shouldRepaint(_ClosePainter oldDelegate) => oldDelegate.closeColor != closeColor;
}

// TODO дописать виджетбук