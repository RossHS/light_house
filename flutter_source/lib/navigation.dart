import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:light_house/src/screens/home/home_screen.dart';
import 'package:light_house/src/screens/logs/logs_screen.dart';
import 'package:light_house/src/widgets/transitions/screen_transitions.dart';

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
    transitionsBuilder: (_, animation, __, child) => CustomClipTransition(
      clipper: CustomClippers.fan,
      animation: CurvedAnimation(parent: animation, curve: Curves.easeInOutCirc),
      child: child,
    ),
    child: screen,
  );
}
