import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/models/play_mode_models.dart';
import 'package:light_house/src/widgets/animated_decorated_box.dart';
import 'package:light_house/src/widgets/custom_hero.dart';
import 'package:light_house/src/widgets/play_mode_indicator_widget.dart';

/// Модалка с выводом режимов проигрывания. Представляет собой 3 карточки,
/// которые демонстрируют представление о режиме проигрывания
class PlayModeModal extends StatelessWidget {
  const PlayModeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (context) {
          final rgbController = GetIt.I<RGBController>();
          // Скажу честно, верстка тут мне не очень нравится и больше походит на костыли,
          // правильно было бы написать свой RenderObject, но мне показалось,
          // что это выстрел из базуки по воробьям
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Expanded тут для того, чтобы верстка не выходила за рамки экрана
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _PlayModeIndicatorPreview(
                      const DisabledPlayMode(),
                      gradients: _linearGradients,
                      color: rgbController.color,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: _PlayModeIndicatorPreview(
                            const BrightnessPlayMode(),
                            gradients: _radialGradients,
                            color: rgbController.color,
                            heightFactor: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: _PlayModeIndicatorPreview(
                            const ChangeColorPlayMode(),
                            gradients: _sweepGradients,
                            color: rgbController.color,
                            heightFactor: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Плитка режима проигрывания. Где
/// [playMode] - режим проигрывания
/// [color] - цвет светильника
/// [gradients] - градиенты для карточки
/// [heightFactor] - множитель высоты карточки
class _PlayModeIndicatorPreview extends StatefulWidget {
  const _PlayModeIndicatorPreview(
    this.playMode, {
    required this.color,
    required this.gradients,
    this.heightFactor = 1,
  });

  final PlayModeBase playMode;
  final Color color;
  final List<Gradient?> gradients;
  final double heightFactor;

  @override
  State<_PlayModeIndicatorPreview> createState() => _PlayModeIndicatorPreviewState();
}

class _PlayModeIndicatorPreviewState extends State<_PlayModeIndicatorPreview> with SingleTickerProviderStateMixin {
  /// Анимация на расширение карточки фона
  late AnimationController _animationController;
  late Animation<double> _curvedAnimation;

  /// Оповещатель на новый градиент для фона
  final _gradient = ValueNotifier<Gradient?>(null);
  final _gradientDuration = const Duration(milliseconds: 2500);

  int index = 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _curvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic);
    // var counterStream = Stream<int>.periodic(const Duration(seconds: 1), (x) => x);
    // counterStream.;

    _gradient.value = widget.gradients[0];
    Timer.periodic(_gradientDuration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _gradient.value = widget.gradients[index % widget.gradients.length];
        index++;
      });
    });

    // Запуск анимации на расширения карточки
    Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _gradient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Крайне не универсальное решение, т.к. максимальная ширина
    // потенциально может быть [double.infinity]
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () {
            Navigator.pop(context);
            GetIt.I<PlayModeController>().playMode = widget.playMode;
          },
          child: Stack(
            alignment: Alignment.topLeft,
            clipBehavior: Clip.none,
            children: [
              ValueListenableBuilder<Gradient?>(
                valueListenable: _gradient,
                builder: (_, gradient, __) {
                  return AnimatedBuilder(
                    animation: _curvedAnimation,
                    builder: (_, __) {
                      return AnimatedDecoratedBox(
                        duration: _gradientDuration,
                        decoration: BoxDecoration(
                          border: _animationController.value < 0.2 ? null : Border.all(color: Colors.black, width: 2),
                          gradient: gradient,
                        ),
                        child: SizedBox(
                          width: constraints.maxWidth * _curvedAnimation.value,
                          height: 200 * widget.heightFactor * _curvedAnimation.value,
                        ),
                      );
                    },
                  );
                },
              ),
              CustomHero(
                tag: widget.playMode.modeName,
                child: PlayModeIndicatorWidget(
                  color: widget.color,
                  playMode: widget.playMode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//-----------------------------------Набор градиентов-------------------------------//

/// Набор круговых градиентов
const _sweepGradients = <SweepGradient?>[
  SweepGradient(
    colors: [
      Colors.black,
      Colors.white,
    ],
  ),
  SweepGradient(
    colors: [
      Colors.white,
      Colors.black,
    ],
  ),
  SweepGradient(
    endAngle: math.pi / 64,
    colors: [
      Colors.white,
      Colors.black,
    ],
  ),
  SweepGradient(
    startAngle: 0.0,
    endAngle: math.pi / 4,
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.black,
    ],
  ),
  SweepGradient(
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
  SweepGradient(
    colors: [
      Colors.red,
      Colors.black,
      Colors.orange,
      Colors.black,
      Colors.yellow,
      Colors.black,
      Colors.green,
      Colors.black,
      Colors.blue,
      Colors.black,
      Colors.indigo,
      Colors.black,
      Colors.red,
    ],
  ),
];

const _radialGradients = <RadialGradient?>[
  RadialGradient(
    colors: [
      Color(0xFF13D9D9),
      Color(0xFF6218CE),
      Color(0xFF1C0642),
      Color(0xFF000000),
    ],
    stops: [0.0, 0.25, 0.7, 1.0],
    focal: Alignment(0.0, 0.4),
  ),
  RadialGradient(
    colors: [
      Color(0xFFFF6FE6),
      Color(0xFFF11F0C),
      Color(0xFF2DA2F6),
      Color(0xFF000000),
    ],
    focal: Alignment(0.4, 0.0),
  ),
  RadialGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFF6FE6),
      Color(0xFF0057E2),
      Color(0x00000000),
      Color(0x00000000),
    ],
    radius: 2,
  ),
  RadialGradient(
    colors: [
      Color(0x0040B2E7),
      Color(0xFF40B2E7),
      Color(0xFF000000),
    ],
  ),
  RadialGradient(
    colors: [
      Color(0x00000000),
      Color(0xFF40B2E7),
      Color(0xFF000000),
      Color(0xFF000000),
    ],
  ),
];

const _linearGradients = <LinearGradient?>[
  LinearGradient(
    colors: [Colors.transparent, Colors.deepPurple, Colors.red],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    colors: [Colors.transparent, Colors.redAccent, Colors.pink, Colors.transparent],
    begin: Alignment.centerLeft,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.2, 0.8, 1.0],
  ),
  LinearGradient(
    colors: [Colors.transparent, Colors.red, Colors.deepPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    colors: [Colors.transparent, Colors.red, Colors.deepPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  LinearGradient(
    colors: [Colors.red, Colors.deepPurple, Colors.transparent],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
];
