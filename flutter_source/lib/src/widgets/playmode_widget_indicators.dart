import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:light_house/src/utils/extensions.dart';
import 'package:light_house/src/widgets/animated_decorated_box.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _duration = Duration(milliseconds: 600);

/// Виджет с проигрыванием режимов свечения. Это один общий виджет на все режимы проигрывания,
/// дабы сделать плавный переход между состояниями проигрывания, логика проигрывания и стиля описывается в
/// вспомогательном объекте.
///
/// П.С. Да я понимаю, что было бы чище и понятнее использовать AnimationController, AnimatedWidget и т.п.,
/// но так как это МОЙ проект (а не гига-интерпрайз решение + я хочу проиграться и попробовать новые подходы),
/// то почему бы и нет 🐢
class PlayModeWidget extends StatefulWidget {
  const PlayModeWidget({
    super.key,
    required this.color,
    required this.playModeGenerator,
  });

  final Color color;
  final PlayModeGenerator playModeGenerator;

  @override
  State<PlayModeWidget> createState() => _PlayModeWidgetState();
}

class _PlayModeWidgetState extends State<PlayModeWidget> {
  late PlayModeGenerator _playModeGenerator;
  late BoxDecoration _decoration;

  @override
  void initState() {
    super.initState();
    _playModeGenerator = widget.playModeGenerator;
    _playModeGenerator._init(_callbackOnPlayMode);
    _decoration = _playModeGenerator._genDecoration(widget.color);
  }

  @override
  void didUpdateWidget(covariant PlayModeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playModeGenerator.runtimeType != oldWidget.playModeGenerator.runtimeType) {
      _playModeGenerator._dispose();
      _playModeGenerator = widget.playModeGenerator;
      _playModeGenerator._init(_callbackOnPlayMode);
      _decoration = _playModeGenerator._genDecoration(widget.color);
    }
    if (widget.color != oldWidget.color) {
      _decoration = _playModeGenerator._genDecoration(widget.color);
    }
  }

  @override
  void dispose() {
    _playModeGenerator._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final oppositeColor = widget.color.calcOppositeColor;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedDecoratedBox(
              duration: _duration,
              // Использование режимного [_decoration] + добавление типовых параметров
              decoration: _decoration.copyWith(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.onSurface, width: 1.5),
              ),
              child: const SizedBox.square(dimension: 34),
            ),
          ),
          Center(
            child: Icon(
              Icons.play_arrow,
              color: oppositeColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Обратный вызов, который отрабатывает по событию из [_playModeGenerator],
  ///
  void _callbackOnPlayMode() {
    if (!mounted) return;
    setState(() {
      _decoration = _playModeGenerator._genDecoration(widget.color);
    });
  }
}

/// Базовый класс для генерации разных декораций для проигрывания в рамках одного виджета
sealed class PlayModeGenerator {
  /// Прописывания обратного вызова и инициализации класса [PlayModeGenerator],
  /// важно, что он должен вызываться лишь раз
  @mustCallSuper
  void _init(VoidCallback callback) {}

  /// Освобождение ресурсов
  void _dispose() {}

  /// Создание уникальных для режима [BoxDecoration] на основании цвета [color]
  BoxDecoration _genDecoration(Color color);
}

/// Просто отображение цвета и не более того
class DisabledPlayModeGenerator extends PlayModeGenerator {
  @override
  void _dispose() {}

  @override
  BoxDecoration _genDecoration(Color color) => BoxDecoration(
        // Именно так, а не просто Colors, т.к. иначе будет кривой переход анимации 😭
        gradient: LinearGradient(
          colors: [color],
          stops: const [1],
        ),
      );
}

///Режим плавной яркости
class BrightnessPlayModeGenerator extends PlayModeGenerator {
  Timer? _timer;
  var _tick = false;

  @override
  void _init(VoidCallback callback) {
    super._init(callback);
    _timer = Timer.periodic(_duration, (timer) {
      _tick = !_tick;
      callback();
    });
  }

  @override
  void _dispose() {
    _timer?.cancel();
  }

  @override
  BoxDecoration _genDecoration(Color color) {
    return BoxDecoration(
      gradient: RadialGradient(
        colors: [color, Colors.transparent],
        stops: [_tick ? 1 : 0.5, 1],
      ),
    );
  }
}

/// Режим перетекания цвета
class ChaneColorPlayModeGenerator extends PlayModeGenerator {
  Timer? _timer;
  int _tick = 0;

  final _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.red,
  ];

  late final _reversedColors = _colors.reversed.toList();

  @override
  void _init(VoidCallback callback) {
    super._init(callback);
    _timer = Timer.periodic(_duration, (timer) {
      _tick ++;
      callback();
    });
  }

  @override
  void _dispose() {
    _timer?.cancel();
  }

  @override
  BoxDecoration _genDecoration(Color color) {
    return BoxDecoration(
      gradient: SweepGradient(
        colors: _colors,
        startAngle: 0,
        endAngle: 2 * math.pi,
      ),
    );
  }
}

//----------------------------------Widgetbook------------------------------------//
@widgetbook.UseCase(name: 'PlayModeWidget use case', type: PlayModeWidget)
Widget playModeWidgetUseCase(BuildContext context) {
  final color = context.knobs.color(label: 'Color', initialValue: Colors.greenAccent);
  return Center(
    child: _PlayModeWidgetDemo(color),
  );
}

class _PlayModeWidgetDemo extends StatefulWidget {
  const _PlayModeWidgetDemo(this.color);

  final Color color;

  @override
  State<_PlayModeWidgetDemo> createState() => _PlayModeWidgetDemoState();
}

class _PlayModeWidgetDemoState extends State<_PlayModeWidgetDemo> {
  PlayModeGenerator playModeGenerator = DisabledPlayModeGenerator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PlayModeWidget(
          color: widget.color,
          playModeGenerator: playModeGenerator,
        ),
        const SizedBox(width: 40),
        DropdownButton<PlayModeGenerator>(
          items: [
            DropdownMenuItem<PlayModeGenerator>(
              value: DisabledPlayModeGenerator(),
              child: const Text('disabled'),
            ),
            DropdownMenuItem<PlayModeGenerator>(
              value: BrightnessPlayModeGenerator(),
              child: const Text('bright'),
            ),
            DropdownMenuItem<PlayModeGenerator>(
              value: ChaneColorPlayModeGenerator(),
              child: const Text('Colors'),
            ),
          ],
          onChanged: (value) => setState(() => playModeGenerator = value!),
        ),
      ],
    );
  }
}
