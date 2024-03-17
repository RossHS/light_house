// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_connection_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BLEConnectionController on _BLEConnectionControllerBase, Store {
  late final _$_connectionStatesAtom = Atom(
      name: '_BLEConnectionControllerBase._connectionStates', context: context);

  @override
  DeviceConnectionState get _connectionStates {
    _$_connectionStatesAtom.reportRead();
    return super._connectionStates;
  }

  @override
  set _connectionStates(DeviceConnectionState value) {
    _$_connectionStatesAtom.reportWrite(value, super._connectionStates, () {
      super._connectionStates = value;
    });
  }

  late final _$_BLEConnectionControllerBaseActionController =
      ActionController(name: '_BLEConnectionControllerBase', context: context);

  @override
  void _updateState(DeviceConnectionState newState) {
    final _$actionInfo = _$_BLEConnectionControllerBaseActionController
        .startAction(name: '_BLEConnectionControllerBase._updateState');
    try {
      return super._updateState(newState);
    } finally {
      _$_BLEConnectionControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
