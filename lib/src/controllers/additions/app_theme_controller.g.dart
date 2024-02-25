// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppThemeController on _AppThemeControllerBase, Store {
  late final _$_themeModeAtom =
      Atom(name: '_AppThemeControllerBase._themeMode', context: context);

  @override
  ThemeMode? get _themeMode {
    _$_themeModeAtom.reportRead();
    return super._themeMode;
  }

  @override
  set _themeMode(ThemeMode? value) {
    _$_themeModeAtom.reportWrite(value, super._themeMode, () {
      super._themeMode = value;
    });
  }

  late final _$_AppThemeControllerBaseActionController =
      ActionController(name: '_AppThemeControllerBase', context: context);

  @override
  void setThemeMode(ThemeMode themeMode) {
    final _$actionInfo = _$_AppThemeControllerBaseActionController.startAction(
        name: '_AppThemeControllerBase.setThemeMode');
    try {
      return super.setThemeMode(themeMode);
    } finally {
      _$_AppThemeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNext() {
    final _$actionInfo = _$_AppThemeControllerBaseActionController.startAction(
        name: '_AppThemeControllerBase.setNext');
    try {
      return super.setNext();
    } finally {
      _$_AppThemeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
