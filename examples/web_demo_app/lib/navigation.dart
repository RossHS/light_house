// ignore: depend_on_referenced_packages
import 'package:go_router/go_router.dart';
import 'package:light_house/widgetbook.dart';
import 'package:light_house_web_demo_app/screens/home_screen.dart';

/// Конфигурация всей навигации приложения через go_router.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'widgetbook',
          builder: (context, state) => const WidgetbookApp(),
        ),
      ],
    ),
  ],
);
