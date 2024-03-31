import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:light_house/src/screens/home/home_screen.dart';
import 'package:light_house/src/screens/logs/logs_screen.dart';

/// Конфигурация всей навигации приложения через go_router.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _buildDefaultTransition(context, state, const HomeScreen()),
      routes: <RouteBase>[
        GoRoute(
          path: 'logs_screen',
          pageBuilder: (context, state) => _buildDefaultTransition(context, state, const LogsScreen()),
        ),
      ],
    ),
  ],
);

/// Так как в go_router пока нельзя задать единый стиль перехода по экранам, то приходится писать вот такое вот 🤡
CustomTransitionPage _buildDefaultTransition<T>(BuildContext context, GoRouterState state, Widget screen) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 700),
    reverseTransitionDuration: const Duration(milliseconds: 700),
    transitionsBuilder: (_, animation, __, child) => ClipTriangleTransition(
      animation: CurvedAnimation(parent: animation, curve: Curves.easeInOutCirc),
      child: child,
    ),
    child: screen,
  );
}

/// Виджет, который передает данные для нашей кастомной анимации перехода, внутри вызывает Clipper - [TriangleClipper]
class ClipTriangleTransition extends AnimatedWidget {
  const ClipTriangleTransition({
    super.key,
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  final Widget child;

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TriangleClipper(
        progress: animation.value,
      ),
      child: child,
    );
  }
}

/// То, чем мы будем резать экран, тем самым получаю "треугольник" перехода
class TriangleClipper extends CustomClipper<Path> {
  TriangleClipper({
    required this.progress,
  }) : super();

  final double progress;

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

  @override
  bool shouldReclip(TriangleClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
