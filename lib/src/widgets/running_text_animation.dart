import 'package:flutter/material.dart';

/// Виджет бэкграунда с бегущим текстом
class RunningTextAnimation extends StatefulWidget {
  const RunningTextAnimation({
    super.key,
    required this.text,
    required this.textStyle,
    this.duration = const Duration(seconds: 4),
  });

  final String text;
  final TextStyle textStyle;
  final Duration duration;

  @override
  State<RunningTextAnimation> createState() => _RunningTextAnimationState();
}

class _RunningTextAnimationState extends State<RunningTextAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.slowMiddle));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RunningTextPainter(
        text: widget.text,
        textStyle: widget.textStyle,
        animation: _animation,
      ),
      // Размер на весь экран
      size: Size.infinite,
    );
  }
}

class RunningTextPainter extends CustomPainter {
  RunningTextPainter({
    required this.text,
    required this.textStyle,
    required this.animation,
  }) : super(repaint: animation);

  final String text;
  final TextStyle textStyle;
  final Animation<double> animation;
  final double space = 50;
  final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;

  @override
  void paint(Canvas canvas, Size size) {
    var textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textAlign: TextAlign.end,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    for (var height = -textPainter.height - space;
        height <= size.height + textPainter.height;
        height += textPainter.height.toInt() + space) {
      final paintHeight = (textPainter.height + space) * animation.value - textPainter.height + height;
      textPainter.paint(
        canvas,
        Offset(size.width - textPainter.width, paintHeight),
      );
      canvas.drawLine(Offset(0, paintHeight - space / 2), Offset(size.width, paintHeight - space / 2), linePaint);
    }
  }

  @override
  bool shouldRepaint(RunningTextPainter oldDelegate) {
    return false;
  }
}
