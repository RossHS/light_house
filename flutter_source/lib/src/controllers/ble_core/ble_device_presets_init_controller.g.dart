// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_device_presets_init_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BLEDevicePresetsInitController
    on _BLEDevicePresetsInitControllerBase, Store {
  late final _$bleDeviceDataForConnectionAtom = Atom(
      name: '_BLEDevicePresetsInitControllerBase.bleDeviceDataForConnection',
      context: context);

  @override
  AsyncValue<({String deviceId, Uuid serviceId})>
      get bleDeviceDataForConnection {
    _$bleDeviceDataForConnectionAtom.reportRead();
    return super.bleDeviceDataForConnection;
  }

  @override
  set bleDeviceDataForConnection(
      AsyncValue<({String deviceId, Uuid serviceId})> value) {
    _$bleDeviceDataForConnectionAtom
        .reportWrite(value, super.bleDeviceDataForConnection, () {
      super.bleDeviceDataForConnection = value;
    });
  }

  late final _$_BLEDevicePresetsInitControllerBaseActionController =
      ActionController(
          name: '_BLEDevicePresetsInitControllerBase', context: context);

  @override
  bool _searchSPForData() {
    final _$actionInfo =
        _$_BLEDevicePresetsInitControllerBaseActionController.startAction(
            name: '_BLEDevicePresetsInitControllerBase._searchSPForData');
    try {
      return super._searchSPForData();
    } finally {
      _$_BLEDevicePresetsInitControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
bleDeviceDataForConnection: ${bleDeviceDataForConnection}
    ''';
  }
}
