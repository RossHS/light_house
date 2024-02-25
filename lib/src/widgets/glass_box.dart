import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GlassBox use case', type: GlassBox)
Widget glassBoxUseCase(BuildContext context) {
  return const ColoredBox(
    color: Colors.greenAccent,
    child: Center(
      child: GlassBox(
        child: SizedBox.square(dimension: 100),
      ),
    ),
  );
}

/// Матовый контейнер, основан на стиле Glassmorphism. В качестве основы взял код с
/// https://medium.com/@felipe_santos75/glassmorphism-in-flutter-56e9dc040c54 , который я чуть изменил -
/// Оптимизировал дерево, заменив излишний Container на обычный DecoratedBox
/// Задаю параметры радиуса для ClipRRect, дабы "подрезать" углы bloor эффекта
/// Добавил различные параметры для кастомизации
class GlassBox extends StatelessWidget {
  const GlassBox({
    super.key,
    this.glassColor = Colors.white,
    this.opacity = 0.1,
    this.borderColor,
    this.child,
  });

  /// Цвет "стекла"
  final Color glassColor;

  /// Начальное значение прозрачности для цвета [glassColor]
  final double opacity;

  /// Цвет обводки границы
  final Color? borderColor;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: glassColor.withOpacity(opacity),
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.onSurface,
                width: 0.5,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
