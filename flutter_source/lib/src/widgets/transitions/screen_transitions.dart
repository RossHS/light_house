import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/settings_controller.dart';
import 'package:light_house/src/utils/utils.dart';

/// Варианты кастомных переходов, которые будут использоваться в [CustomClipTransition]
enum CustomClippers {
  triangle,
  fan,
  circle,
}

/// Виджет, который передает данные для нашей кастомной анимации перехода, внутри вызывает Clipper - [_TriangleClipper]
class CustomClipTransition extends AnimatedWidget {
  const CustomClipTransition({
    super.key,
    required Animation<double> animation,
    this.clipper,
    required this.child,
  }) : super(listenable: animation);

  final Widget child;
  final CustomClippers? clipper;

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    // Для задания типа перехода извне, либо явная передача данных,
    // но код был бы чище, если бы я использовал InheritedWidget,
    // но текущий вариант в разы проще и понятнее
    var clipper = this.clipper ?? GetIt.I<SettingsController>().currentClipper;
    return ClipPath(
      clipper: switch (clipper) {
        CustomClippers.triangle => _TriangleClipper(animation.value),
        CustomClippers.fan => _FanClipper(animation.value),
        CustomClippers.circle => _CircleClipper(animation.value),
      },
      child: child,
    );
  }
}

/// Верхнеуровневый класс для создания кастомных клипперов
abstract class _TransitionClipper extends CustomClipper<Path> {
  _TransitionClipper(this.progress);

  /// Прогресс анимации в диапазоне [0,1]
  final double progress;

  @override
  bool shouldReclip(_TransitionClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

/// То, чем мы будем резать экран, тем самым получаю "треугольник" перехода
class _TriangleClipper extends _TransitionClipper {
  _TriangleClipper(super.progress);

  @override
  Path getClip(Size size) {
    // Расчет угла прямоугольного треугольника
    final radians = math.atan(size.height / size.width);

    final path = Path();
    // Установка начальной точки для треугольника (левый нижний угол)
    path.moveTo(size.width, size.height);

    // Везде умножаем на два, так как наш треугольник должен описать размеры [size]
    // движение по оси x
    path.lineTo(size.width - (2 * size.width * progress), size.height);
    // движение по оси y
    path.lineTo(size.width, size.height - (math.tan(radians) * 2 * size.width * progress));
    path.close();
    return path;
  }
}

/// Веерный клиппер, т.е. появление нового экрана это по сути первая четверть
class _FanClipper extends _TransitionClipper {
  _FanClipper(super.progress);

  @override
  Path getClip(Size size) {
    // Расчет радиуса описанной окружности
    final radius = math.sqrt(math.pow(size.height, 2) + math.pow(size.width, 2));

    final path = Path();
    // Ставим начальную точку
    path.moveTo(0, size.height);
    path.arcTo(
      Rect.fromCircle(center: Offset(0, size.height), radius: radius),
      degreesToRadians(0),
      degreesToRadians(-90 * progress),
      false,
    );

    path.close();
    return path;
  }
}

/// Круговой клиппер, где отрисованная область создает описанную окружность над экраном
class _CircleClipper extends _TransitionClipper {
  _CircleClipper(super.progress);

  @override
  Path getClip(Size size) {
    // Расчет радиуса описанной окружности, где центр круга == центру экрана
    final center = size / 2;
    final radius = math.sqrt(math.pow(center.height, 2) + math.pow(center.width, 2));

    final path = Path();
    path.addOval(
      Rect.fromCircle(
        radius: radius * progress,
        center: Offset(center.width, center.height),
      ),
    );
    return path;
  }
}
