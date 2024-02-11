import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'LightBubble use case', type: LightBubble)
Widget lightBubbleUseCase(BuildContext context) {
  final color = context.knobs.color(
    label: 'Light color',
    initialValue: Colors.greenAccent,
  );
  final brightness = context.knobs.int.slider(label: 'brightness', initialValue: 100, min: 0, max: 255);
  return LightBubble(color: color, brightness: brightness);
}

/// Виджет индикатора цвета, просто круглая "лампочка"
class LightBubble extends StatelessWidget {
  const LightBubble({
    super.key,
    required this.color,
    required this.brightness,
    this.radius = 25,
    this.isPulsing = false,
  }) : assert(
          brightness >= 0 && brightness <= 255,
          'brightness value is out of range, current brightness - $brightness',
        );

  /// Тот самый индикатор цвета, который мы отображаем в круге
  final Color color;

  /// Свечение. Может быть в диапазоне одного байта (0-255), но переводится в диапазон (2-10)
  final int brightness;

  /// Радиус круга
  final int radius;

  /// Включена ли анимация пульсации свечения или нет, если нет, то картинка статична
  /// если включена, то
  final bool isPulsing;

  /// Перевод значения [brightness] из диапазона 0-255 в диапазон 2-10
  double get _calcSpreadRadius => (brightness / 255) * (7 - 1) + 1;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(255),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.7),
            spreadRadius: _calcSpreadRadius,
            blurRadius: 15,
          ),
        ],
      ),
      child: SizedBox.square(dimension: radius.toDouble()),
    );
  }
}
