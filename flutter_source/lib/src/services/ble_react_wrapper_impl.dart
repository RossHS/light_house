import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:light_house/src/services/ble_react_wrapper_interface.dart';

/// Реальная имплементация BLE сервиса. Просто передает все вызовы методов на [FlutterReactiveBle]
class BleReactWrapperImpl implements BleReactWrapperInterface {
  BleReactWrapperImpl._();

  factory BleReactWrapperImpl() => _instance;

  static final BleReactWrapperImpl _instance = BleReactWrapperImpl._();

  /// Либа для Bluetooth, через которую идет вся коммуникация
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  @override
  Stream<ConnectionStateUpdate> connectToDevice({
    required String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) =>
      _ble.connectToDevice(
        id: id,
        servicesWithCharacteristicsToDiscover: servicesWithCharacteristicsToDiscover,
        connectionTimeout: connectionTimeout,
      );

  @override
  Stream<DiscoveredDevice> scanForDevices({
    required List<Uuid> withServices,
    ScanMode scanMode = ScanMode.balanced,
    bool requireLocationServicesEnabled = true,
  }) =>
      _ble.scanForDevices(
        withServices: withServices,
        scanMode: scanMode,
        requireLocationServicesEnabled: requireLocationServicesEnabled,
      );

  @override
  Stream<BleStatus> get statusStream => _ble.statusStream;

  @override
  Future<void> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  }) =>
      _ble.writeCharacteristicWithoutResponse(
        characteristic,
        value: value,
      );
}
