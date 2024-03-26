// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsController on _SettingsControllerBase, Store {
  late final _$_glitchOnAtom =
      Atom(name: '_SettingsControllerBase._glitchOn', context: context);

  @override
  bool get _glitchOn {
    _$_glitchOnAtom.reportRead();
    return super._glitchOn;
  }

  @override
  set _glitchOn(bool value) {
    _$_glitchOnAtom.reportWrite(value, super._glitchOn, () {
      super._glitchOn = value;
    });
  }

  late final _$_SettingsControllerBaseActionController =
      ActionController(name: '_SettingsControllerBase', context: context);

  @override
  void _parseSPSettings() {
    final _$actionInfo = _$_SettingsControllerBaseActionController.startAction(
        name: '_SettingsControllerBase._parseSPSettings');
    try {
      return super._parseSPSettings();
    } finally {
      _$_SettingsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
