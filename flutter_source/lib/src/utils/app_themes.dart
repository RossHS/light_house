import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// Здесь собраны все темы приложения

const Color _lPrimary = Color(0xFFFFEC00);
const Color _lSecondary = Color(0xFFFF55c2);
const Color _lBackground = Color(0xFFFFF0F5);

final lightTheme = ThemeData(
  fontFamily: 'JetBrains Mono',
  colorScheme: const ColorScheme(
    primary: _lPrimary,
    primaryContainer: _lPrimary,
    secondary: _lSecondary,
    secondaryContainer: _lSecondary,
    surface: _lBackground,
    background: _lBackground,
    error: Colors.redAccent,
    // Цвет текста на основном цвете
    onPrimary: Colors.black,
    // Цвет текста на вторичном цвете
    onSecondary: Colors.black,
    // Цвет текста на поверхности
    onSurface: Colors.black,
    // Цвет текста на фоне
    onBackground: Colors.black,
    // Цвет текста ошибки
    onError: Colors.white,
    brightness: Brightness.light,
  ),
);

const Color _dPrimary = Color(0xFF976ED7);
const Color _dSecondary = Color(0xFFE67E22);
const Color _dBackground = Color(0xFF333333);

final dartTheme = ThemeData(
  fontFamily: 'JetBrains Mono',
  colorScheme: const ColorScheme(
    primary: _dPrimary,
    primaryContainer: _dPrimary,
    secondary: _dSecondary,
    secondaryContainer: _dSecondary,
    surface: _dBackground,
    background: _dBackground,
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
);


/// Генерация темы по входному цвету и яркости, по сути имеем все то-же самое. то и под капотом в Flutter,
/// С той лишь разницей, что явно устанавливаем [background], дабы он был более "ярким"
ThemeData generateThemeData({required Color seedColor, required Brightness brightness}) {
  final palette = CorePalette.contentOf(seedColor.value);
  return ThemeData(
    fontFamily: 'JetBrains Mono',
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      error: Colors.redAccent,
      background: Color(brightness == Brightness.light ? palette.primary.get(90) : palette.neutral.get(20)),
    ),
  );
}
