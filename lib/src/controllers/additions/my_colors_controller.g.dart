// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_colors_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MyColorsController on _MyColorsControllerBase, Store {
  late final _$myColorsAtom =
      Atom(name: '_MyColorsControllerBase.myColors', context: context);

  @override
  AsyncValue<List<Color>> get myColors {
    _$myColorsAtom.reportRead();
    return super.myColors;
  }

  @override
  set myColors(AsyncValue<List<Color>> value) {
    _$myColorsAtom.reportWrite(value, super.myColors, () {
      super.myColors = value;
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
myColors: ${myColors}
    ''';
  }
}
