// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_colors_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MyColorsController on _MyColorsControllerBase, Store {
  late final _$_myColorsAtom =
      Atom(name: '_MyColorsControllerBase._myColors', context: context);

  @override
  AsyncValue<Set<Color>> get _myColors {
    _$_myColorsAtom.reportRead();
    return super._myColors;
  }

  @override
  set _myColors(AsyncValue<Set<Color>> value) {
    _$_myColorsAtom.reportWrite(value, super._myColors, () {
      super._myColors = value;
    });
  }

  late final _$saveColorAsyncAction =
      AsyncAction('_MyColorsControllerBase.saveColor', context: context);

  @override
  Future<bool> saveColor(Color color) {
    return _$saveColorAsyncAction.run(() => super.saveColor(color));
  }

  late final _$deleteColorAsyncAction =
      AsyncAction('_MyColorsControllerBase.deleteColor', context: context);

  @override
  Future<bool> deleteColor(Color color) {
    return _$deleteColorAsyncAction.run(() => super.deleteColor(color));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
