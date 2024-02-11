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

  @override
  void paint(Canvas canvas, Size size) {
    var textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    final textSpacer = calcSpacer(size.width, textPainter.width);
    for (var width = 0.0; width <= size.width; width += textSpacer + textPainter.width) {
      for (var height = -textPainter.height;
          height <= size.height + textPainter.height;
          height += textPainter.height.toInt()) {
        textPainter.paint(
          canvas,
          Offset(width.toDouble(), (textPainter.height) * animation.value - textPainter.height + height),
        );
      }
    }
  }

  /// Расчет пробела между строками текста, важно, чтобы текст был "прибит" к краям экрана
  double calcSpacer(double screenWidth, double textWidth) {
    final numberOfBlocs = (screenWidth + textWidth) ~/ (2 * textWidth);
    return (screenWidth - textWidth * numberOfBlocs) / (numberOfBlocs - 1);
  }

  @override
  bool shouldRepaint(RunningTextPainter oldDelegate) {
    return true;
  }
}
