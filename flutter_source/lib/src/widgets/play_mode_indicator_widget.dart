import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:light_house/src/models/play_mode_models.dart';
import 'package:light_house/src/utils/extensions.dart';
import 'package:light_house/src/widgets/animated_decorated_box.dart';
import 'package:light_house/src/widgets/widgetbook_def_frame.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Виджет с проигрыванием режимов свечения. Это один общий виджет на все режимы проигрывания,
/// дабы сделать плавный переход между состояниями проигрывания, логика проигрывания и стиля описывается в
/// вспомогательном объекте [_AbstractDecorationGenerator].
class PlayModeIndicatorWidget extends StatefulWidget {
  const PlayModeIndicatorWidget({
    super.key,
    required this.color,
    required this.playMode,
  });

  final Color color;
  final PlayModeBase playMode;

  @override
  State<PlayModeIndicatorWidget> createState() => _PlayModeIndicatorWidgetState();
}

class _PlayModeIndicatorWidgetState extends State<PlayModeIndicatorWidget> {
  final GlobalKey _decorationIndicatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final oppositeColor = widget.color.calcOppositeColor;

    const childBox = SizedBox.square(dimension: 34);
    final baseDecoration = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: theme.colorScheme.onSurface, width: 1.5),
    );

    // ТУТ switch с проигрыванием
    _AbstractDecorationGenerator playModeGenerator = switch (widget.playMode) {
      DisabledPlayMode() => _DisabledPlayModeGenerator(
          globalKey: _decorationIndicatorKey,
          baseDecoration: baseDecoration,
          color: widget.color,
          child: childBox,
        ),
      BrightnessPlayMode() => _BrightnessPlayModeGenerator(
          globalKey: _decorationIndicatorKey,
          baseDecoration: baseDecoration,
          color: widget.color,
          child: childBox,
        ),
      ChangeColorPlayMode() => _ChangeColorPlayModeGenerator(
          globalKey: _decorationIndicatorKey,
          baseDecoration: baseDecoration,
          color: widget.color,
          child: childBox,
        ),
    };

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: playModeGenerator,
          ),
          Center(
            child: Icon(
              Icons.lightbulb_outline,
              color: oppositeColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Базовый класс для генерации разных декораций для проигрывания в рамках одного виджета.
/// Ключевой момент это наличие [AnimatedDecoratedBox] и его связки с [globalKey] в дочерних классах.
/// Также важно учитывать [baseDecoration], именно его мы каждый раз кастомизируем.
abstract class _AbstractDecorationGenerator extends StatefulWidget {
  const _AbstractDecorationGenerator({
    required this.globalKey,
    required this.color,
    required this.baseDecoration,
    required this.child,
  });

  final GlobalKey globalKey;
  final Color color;
  final BoxDecoration baseDecoration;
  final Widget child;
}

abstract class _AbstractDecorationGeneratorState extends State<_AbstractDecorationGenerator> {}

/// Отключенный режим проигрывания.
class _DisabledPlayModeGenerator extends _AbstractDecorationGenerator {
  const _DisabledPlayModeGenerator({
    required super.globalKey,
    required super.baseDecoration,
    required super.color,
    required super.child,
  });

  @override
  State<_AbstractDecorationGenerator> createState() => _DisabledPlayModeGeneratorState();
}

class _DisabledPlayModeGeneratorState extends _AbstractDecorationGeneratorState {
  @override
  Widget build(BuildContext context) {
    return AnimatedDecoratedBox(
      key: widget.globalKey,
      decoration: widget.baseDecoration.copyWith(
        color: widget.color,
      ),
      child: widget.child,
    );
  }
}

/// Режим проигрывания с перетекающей яркостью
class _BrightnessPlayModeGenerator extends _AbstractDecorationGenerator {
  const _BrightnessPlayModeGenerator({
    required super.globalKey,
    required super.baseDecoration,
    required super.color,
    required super.child,
  });

  @override
  State<_AbstractDecorationGenerator> createState() => _BrightnessPlayModeGeneratorState();
}

class _BrightnessPlayModeGeneratorState extends _AbstractDecorationGeneratorState {
  Timer? _timer;
  final _duration = const Duration(milliseconds: 500);
  var _direction = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      _duration,
      (timer) {
        if (!mounted) return;
        setState(() {
          _direction = !_direction;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDecoratedBox(
      key: widget.globalKey,
      duration: _duration,
      decoration: widget.baseDecoration.copyWith(
        gradient: RadialGradient(
          colors: [widget.color, Colors.transparent],
          stops: [_direction ? 0.5 : 1.0, 1.0],
        ),
      ),
      child: widget.child,
    );
  }
}

/// Режим проигрывания при перетекающем цвете
class _ChangeColorPlayModeGenerator extends _AbstractDecorationGenerator {
  const _ChangeColorPlayModeGenerator({
    required super.globalKey,
    required super.baseDecoration,
    required super.color,
    required super.child,
  });

  @override
  State<_AbstractDecorationGenerator> createState() => _ChangeColorPlayModeGeneratorState();
}

class _ChangeColorPlayModeGeneratorState extends _AbstractDecorationGeneratorState with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.slowMiddle,
      ),
    );
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
      animation: _animation,
      builder: (_, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: child!,
        );
      },
      child: AnimatedDecoratedBox(
        key: widget.globalKey,
        decoration: widget.baseDecoration.copyWith(
          gradient: const SweepGradient(
            colors: [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.blue,
              Colors.indigo,
              Colors.red,
            ],
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

//----------------------------------Widgetbook------------------------------------//
@widgetbook.UseCase(name: 'PlayModeWidget use case', type: PlayModeIndicatorWidget)
Widget playModeWidgetUseCase(BuildContext context) {
  final color = context.knobs.color(label: 'Color', initialValue: Colors.greenAccent);
  return WidgetbookDefFrame(child: _PlayModeWidgetDemo(color));
}

class _PlayModeWidgetDemo extends StatefulWidget {
  const _PlayModeWidgetDemo(this.color);

  final Color color;

  @override
  State<_PlayModeWidgetDemo> createState() => _PlayModeWidgetDemoState();
}

class _PlayModeWidgetDemoState extends State<_PlayModeWidgetDemo> {
  PlayModeBase playMode = const DisabledPlayMode();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlayModeIndicatorWidget(
              color: widget.color,
              playMode: playMode,
            ),
            const SizedBox(width: 40),
            DropdownButton<PlayModeBase>(
              value: playMode,
              items: const [
                DropdownMenuItem<PlayModeBase>(
                  value: DisabledPlayMode(),
                  child: Text('disabled'),
                ),
                DropdownMenuItem<PlayModeBase>(
                  value: BrightnessPlayMode(),
                  child: Text('bright'),
                ),
                DropdownMenuItem<PlayModeBase>(
                  value: ChangeColorPlayMode(),
                  child: Text('change colors'),
                ),
              ],
              onChanged: (value) => setState(() => playMode = value!),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlayModeIndicatorWidget(
              color: widget.color,
              playMode: const DisabledPlayMode(),
            ),
            PlayModeIndicatorWidget(
              color: widget.color,
              playMode: const BrightnessPlayMode(),
            ),
            PlayModeIndicatorWidget(
              color: widget.color,
              playMode: const ChangeColorPlayMode(),
            ),
          ],
        ),
      ],
    );
  }
}
