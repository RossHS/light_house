import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:light_house/src/services/ble_react_wrapper_interface.dart';

typedef BleMockDataListener = Function(List<int> value);

class BleReactWrapperMock implements BleReactWrapperInterface {
  BleReactWrapperMock._();

  factory BleReactWrapperMock() => _instance;

  static final BleReactWrapperMock _instance = BleReactWrapperMock._();

  /// Состояние подключения
  DeviceConnectionState _connectionState = DeviceConnectionState.disconnected;

  /// Слушатель, куда будут передаваться данные через метод [writeCharacteristicWithoutResponse]
  BleMockDataListener? _dataListener;

  set dataListener(BleMockDataListener? listener) => _dataListener = listener;

  /// Подключение к несуществующему устройству
  @override
  Stream<ConnectionStateUpdate> connectToDevice({
    required String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) {
    final connection = Repeater.broadcast(
      onListenEmitFrom: () async* {
        _connectionState = DeviceConnectionState.connecting;
        yield ConnectionStateUpdate(deviceId: id, connectionState: _connectionState, failure: null);
        await Future.delayed(const Duration(milliseconds: 600));
        _connectionState = DeviceConnectionState.connected;
        yield ConnectionStateUpdate(deviceId: id, connectionState: _connectionState, failure: null);
        // Хитрость, таким образом мы вешаем стрим до конца времен, пока его не отменят,
        // в рамках mock подходящий вариант
        await Completer().future;
      },
      onCancel: () async {
        _connectionState = DeviceConnectionState.disconnected;
      },
    );
    return connection.stream;
  }

  @override
  Stream<DiscoveredDevice> scanForDevices({
    required List<Uuid> withServices,
    ScanMode scanMode = ScanMode.balanced,
    bool requireLocationServicesEnabled = true,
  }) async* {
    final devicesName = <String>['custom ble', 'choto-tam', 'HMSoft', 'kolonka JBL shkolnika'];
    for (final name in devicesName) {
      await Future.delayed(const Duration(milliseconds: 600));
      yield DiscoveredDevice(
        name: name,
        id: name,
        serviceData: const {},
        manufacturerData: Uint8List(0),
        rssi: 0,
        serviceUuids: [
          Uuid.parse('106075de-9780-4c53-999b-3ed907c7722e'),
        ],
      );
    }
  }

  @override
  Stream<BleStatus> get statusStream async* {
    yield BleStatus.ready;
  }

  @override
  Future<void> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  }) async {
    if (_connectionState != DeviceConnectionState.connected) {
      throw Exception('Incorrect connection state - $_connectionState');
    }
    _dataListener?.call(value);
  }
}
