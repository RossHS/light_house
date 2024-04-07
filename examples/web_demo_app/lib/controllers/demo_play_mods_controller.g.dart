// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_play_mods_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DemoPlayModeController on _DemoPlayModeControllerBase, Store {
  Computed<PlayModeBase>? _$currentModeComputed;

  @override
  PlayModeBase get currentMode =>
      (_$currentModeComputed ??= Computed<PlayModeBase>(() => super.currentMode,
              name: '_DemoPlayModeControllerBase.currentMode'))
          .value;

  @override
  String toString() {
    return '''
currentMode: ${currentMode}
    ''';
  }
}
