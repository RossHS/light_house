import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// Генерация темы по входному цвету и яркости, по сути имеем все то-же самое. то и под капотом в Flutter,
/// С той лишь разницей, что явно устанавливаем [background], дабы он был более "ярким"
ThemeData generateThemeData({required Color seedColor, required Brightness brightness}) {
  final palette = CorePalette.contentOf(seedColor.value);
  final background = Color(brightness == Brightness.light ? palette.primary.get(90) : palette.neutral.get(20));
  final cs = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
    error: Colors.redAccent,
    surface: background,
    inverseSurface: brightness == Brightness.light ? Colors.white : Colors.black,
  );
  return ThemeData(
    fontFamily: 'JetBrains Mono',
    colorScheme: cs,
    scaffoldBackgroundColor: background,
    iconTheme: IconThemeData(color: cs.onSurface),
  );
}
