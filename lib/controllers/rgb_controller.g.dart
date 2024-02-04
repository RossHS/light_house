// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rgb_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RGBController on _RGBControllerBase, Store {
  late final _$redAtom = Atom(name: '_RGBControllerBase.red', context: context);

  @override
  int get red {
    _$redAtom.reportRead();
    return super.red;
  }

  @override
  set red(int value) {
    _$redAtom.reportWrite(value, super.red, () {
      super.red = value;
    });
  }

  late final _$greenAtom =
      Atom(name: '_RGBControllerBase.green', context: context);

  @override
  int get green {
    _$greenAtom.reportRead();
    return super.green;
  }

  @override
  set green(int value) {
    _$greenAtom.reportWrite(value, super.green, () {
      super.green = value;
    });
  }

  late final _$blueAtom =
      Atom(name: '_RGBControllerBase.blue', context: context);

  @override
  int get blue {
    _$blueAtom.reportRead();
    return super.blue;
  }

  @override
  set blue(int value) {
    _$blueAtom.reportWrite(value, super.blue, () {
      super.blue = value;
    });
  }

  @override
  String toString() {
    return '''
red: ${red},
green: ${green},
blue: ${blue}
    ''';
  }
}
