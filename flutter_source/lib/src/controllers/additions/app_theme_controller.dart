import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:light_house/src/utils/sp_keys.dart' as sp;
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_theme_controller.g.dart';

// ignore: library_private_types_in_public_api
class AppThemeController = _AppThemeControllerBase with _$AppThemeController;

/// Контроллер отвечающий за тему приложения. Меняя [themeMode] мы меняем тему - светлая/темная
abstract class _AppThemeControllerBase with Store {
  _AppThemeControllerBase(this._prefs) {
    _themeMode = _parseThemeMode();
  }

  final SharedPreferences _prefs;

  /// Тема приложения - темная, системная или светлая
  @observable
  ThemeModeExtension? _themeMode;

  ThemeModeExtension get themeMode => _themeMode!;

  @action
  void setThemeMode(ThemeModeExtension themeMode) {
    _themeMode = themeMode;
    _prefs.setString(sp.themeModeKey, themeMode.name);
  }

  @action
  void setNext() {
    const themeValues = ThemeModeExtension.values;
    final index = themeValues.indexOf(themeMode);
    setThemeMode(themeValues[(index + 1) % themeValues.length]);
  }

  ThemeModeExtension _parseThemeMode() {
    final themeModeValue = _prefs.getString(sp.themeModeKey);
    if (themeModeValue == null) return ThemeModeExtension.light;
    final savedThemeMode = ThemeModeExtension.values.firstWhereOrNull((theme) => theme.name == themeModeValue);
    return savedThemeMode ?? ThemeModeExtension.light;
  }
}

/// Расширение для стандартного [ThemeMode]
enum ThemeModeExtension {
  light(ThemeMode.light),
  dark(ThemeMode.dark);

  const ThemeModeExtension(this.rawMode);

  final ThemeMode rawMode;
}
