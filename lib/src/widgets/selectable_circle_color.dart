import 'dart:math';

import 'package:flutter/material.dart';
import 'package:light_house/src/widgets/rotation_switch_widget.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Круг с индикацией выбранного цвета [color], нажатие по нему активирует callback [onTap],
/// параметр - выбран/не выбран круг определяется полем [isSelected]
class SelectableCircleColor extends StatefulWidget {
  const SelectableCircleColor({
    super.key,
    required this.color,
    this.radius = 35,
    this.isSelected = false,
    required this.onTap,
    this.onDoubleTap,
  });

  final Color color;
  final double radius;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  @override
  State<SelectableCircleColor> createState() => _SelectableCircleColorState();
}

class _SelectableCircleColorState extends State<SelectableCircleColor> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _circlePaintAnimation;
  final _duration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
      value: widget.isSelected ? 1 : 0,
    );
    _circlePaintAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SelectableCircleColor oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если состояние - выбран/не выбран цвет изменилось, то триггерим анимацию
    if (oldWidget.isSelected != widget.isSelected) {
      _runAnimation();
    }
  }

  /// Метод перезапуска анимации, по нему будет рисоваться окантовка круга
  void _runAnimation() {
    widget.isSelected ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        foregroundPainter: _CirclePainter(animation: _circlePaintAnimation),
        child: Material(
          color: widget.color,
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: widget.onTap,
            onDoubleTap: widget.onDoubleTap,
            child: SizedBox.square(
              dimension: widget.radius.toDouble(),
              child: RotationSwitchWidget(
                duration: _duration,
                child: widget.isSelected ? const Icon(Icons.check) : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Отрисовка границы выбранного круга
class _CirclePainter extends CustomPainter {
  _CirclePainter({required this.animation}) : super(repaint: animation);

  final Animation<double> animation;
  final _border = Paint()
    ..color = Colors.black
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    if (animation.value == 0.0) return;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -pi / 2,
      2 * pi * animation.value,
      false,
      _border,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

//------все для [Widgetbook]------//
@widgetbook.UseCase(name: 'SelectableCircleColor use case', type: SelectableCircleColor)
Widget selectableCircleColorUseCase(BuildContext context) {
  return const Center(
    child: _SelectableCircleColorTest(),
  );
}

/// Вспомогательный виджет для [Widgetbook], тут мы просто проверяем поведение [SelectableCircleColor]
class _SelectableCircleColorTest extends StatefulWidget {
  const _SelectableCircleColorTest();

  @override
  State<_SelectableCircleColorTest> createState() => _SelectableCircleColorTestState();
}

class _SelectableCircleColorTestState extends State<_SelectableCircleColorTest> {
  Color _currentColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.amber,
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: colors
          .map<Widget>(
            (e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableCircleColor(
                color: e,
                onTap: () {
                  setState(() {
                    _currentColor = e;
                  });
                },
                isSelected: _currentColor == e,
              ),
            ),
          )
          .toList(),
    );
  }
}
