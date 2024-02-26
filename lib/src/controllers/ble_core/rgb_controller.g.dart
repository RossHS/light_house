// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rgb_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RGBController on _RGBControllerBase, Store {
  late final _$colorAtom =
      Atom(name: '_RGBControllerBase.color', context: context);

  @override
  Color get color {
    _$colorAtom.reportRead();
    return super.color;
  }

  @override
  set color(Color value) {
    _$colorAtom.reportWrite(value, super.color, () {
      super.color = value;
    });
  }

  late final _$_RGBControllerBaseActionController =
      ActionController(name: '_RGBControllerBase', context: context);

  @override
  Color withRed(int red) {
    final _$actionInfo = _$_RGBControllerBaseActionController.startAction(
        name: '_RGBControllerBase.withRed');
    try {
      return super.withRed(red);
    } finally {
      _$_RGBControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Color withGreen(int green) {
    final _$actionInfo = _$_RGBControllerBaseActionController.startAction(
        name: '_RGBControllerBase.withGreen');
    try {
      return super.withGreen(green);
    } finally {
      _$_RGBControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Color withBlue(int blue) {
    final _$actionInfo = _$_RGBControllerBaseActionController.startAction(
        name: '_RGBControllerBase.withBlue');
    try {
      return super.withBlue(blue);
    } finally {
      _$_RGBControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
color: ${color}
    ''';
  }
}
