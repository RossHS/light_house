// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_mode_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayModeController on _PlayModeControllerBase, Store {
  late final _$playModeAtom =
      Atom(name: '_PlayModeControllerBase.playMode', context: context);

  @override
  PlayModeBase get playMode {
    _$playModeAtom.reportRead();
    return super.playMode;
  }

  @override
  set playMode(PlayModeBase value) {
    _$playModeAtom.reportWrite(value, super.playMode, () {
      super.playMode = value;
    });
  }

  @override
  String toString() {
    return '''
playMode: ${playMode}
    ''';
  }
}
