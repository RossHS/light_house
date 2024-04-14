import 'package:flutter/material.dart';
import 'package:light_house/src/widgets/widgetbook_def_frame.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'LightBubble use case', type: LightBubble)
Widget lightBubbleUseCase(BuildContext context) {
  final color = context.knobs.color(
    label: 'Light color',
    initialValue: Colors.greenAccent,
  );
  final brightness = context.knobs.int.slider(label: 'brightness', initialValue: 100, min: 0, max: 255);
  return WidgetbookDefFrame(child: LightBubble(color: color, brightness: brightness));
}

/// Виджет индикатора цвета, просто круглая "лампочка"
class LightBubble extends ImplicitlyAnimatedWidget {
  const LightBubble({
    super.key,
    required this.color,
    required this.brightness,
    this.radius = 25,
    super.duration = const Duration(milliseconds: 300),
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

  @override
  AnimatedWidgetBaseState<LightBubble> createState() => _LightBubbleState();
}

class _LightBubbleState extends AnimatedWidgetBaseState<LightBubble> {
  ColorTween? _color;
  IntTween? _brightness;

  /// Перевод значения [widget.brightness] из диапазона 0-255 в диапазон 1-7
  double get _calcSpreadRadius => (_brightness!.evaluate(animation) / 255) * (7 - 1) + 1;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _color?.evaluate(animation),
        borderRadius: BorderRadius.circular(255),
        boxShadow: [
          BoxShadow(
            color: _color!.evaluate(animation)!,
            spreadRadius: _calcSpreadRadius,
            blurRadius: 15,
          ),
        ],
      ),
      child: SizedBox.square(dimension: widget.radius.toDouble()),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color = visitor(_color, widget.color, (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    _brightness = visitor(
      _brightness,
      widget.brightness,
      (dynamic value) => IntTween(begin: value as int),
    ) as IntTween?;
  }
}
