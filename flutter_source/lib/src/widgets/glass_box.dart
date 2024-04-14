import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:light_house/src/widgets/widgetbook_def_frame.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GlassBox use case', type: GlassBox)
Widget glassBoxUseCase(BuildContext context) {
  return const WidgetbookDefFrame(
    child: GlassBox(
      child: SizedBox.square(dimension: 100),
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
    this.boxBorderSides = const BoxBorderSides.all(),
    this.child,
  });

  /// Цвет "стекла"
  final Color glassColor;

  /// Начальное значение прозрачности для цвета [glassColor]
  final double opacity;

  /// Границы, на которых рисуем контур
  final BoxBorderSides boxBorderSides;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final borderSide = BorderSide(
      color: theme.colorScheme.onSurface,
      width: 0.5,
    );

    Widget finalWidget = DecoratedBox(
      decoration: BoxDecoration(
        color: glassColor.withOpacity(opacity),
        border: Border(
          top: boxBorderSides.top ? borderSide : BorderSide.none,
          left: boxBorderSides.left ? borderSide : BorderSide.none,
          right: boxBorderSides.right ? borderSide : BorderSide.none,
          bottom: boxBorderSides.bottom ? borderSide : BorderSide.none,
        ),
      ),
      child: child,
    );

    // Если нет прозрачности, то нет смысла перегружать дерево тяжелым виджетом [BackdropFilter]
    if (opacity < 1) {
      finalWidget = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: finalWidget,
      );
    }

    return ClipRect(
      child: finalWidget,
    );
  }
}

/// Грани, на которых мы будем рисовать контур [GlassBox]
@immutable
class BoxBorderSides {
  const BoxBorderSides({
    this.top = false,
    this.left = false,
    this.right = false,
    this.bottom = false,
  });

  const BoxBorderSides.all()
      : top = true,
        left = true,
        right = true,
        bottom = true;

  final bool top;
  final bool left;
  final bool right;
  final bool bottom;
}
