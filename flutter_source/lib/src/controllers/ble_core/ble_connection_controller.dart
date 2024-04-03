import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide FlutterReactiveBle;
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/services/ble_react_wrapper_interface.dart';
import 'package:light_house/src/utils/logger.dart';
import 'package:mobx/mobx.dart';

part 'ble_connection_controller.g.dart';

// ignore: library_private_types_in_public_api
class BLEConnectionController = _BLEConnectionControllerBase with _$BLEConnectionController;

/// Контроллер состояния подключения и отключения от BLE
abstract class _BLEConnectionControllerBase with Store {
  final BleReactWrapperInterface ble = GetIt.I<BleReactWrapperInterface>();
  final _blePresetsController = GetIt.I<BLEDevicePresetsInitController>();

  /// Таймер на отключение неактивного соединения
  RestartableTimer? _timer;

  /// Слушатель состояний соединения с BLE
  StreamSubscription<ConnectionStateUpdate>? _connection;

  @observable
  DeviceConnectionState _connectionStates = DeviceConnectionState.disconnected;

  DeviceConnectionState get connectionStates => _connectionStates;

  /// Обновление статуса соединения
  /// Использую отдельный метод так как имею дело с потоком данных [_connection]
  @action
  void _updateState(DeviceConnectionState newState) {
    _connectionStates = newState;
    if (connectionStates == DeviceConnectionState.connected) {
      _timer = RestartableTimer(const Duration(minutes: 1), disconnect);
    } else if (_connectionStates == DeviceConnectionState.disconnected) {
      _timer?.cancel();
      _connection = null;
    }
  }

  /// Сброс таймера на авто-отключение
  void resetConnectionTimeout() => _timer?.reset();

  /// Метод подключения к BLE
  Future<void> connect() async {
    if (_blePresetsController.bleDeviceDataForConnection.value == null) {
      _blePresetsController.initBleSettings();
    }
    final bleReady = await _blePresetsController.bleDataInitedCompleter.future;
    if (_connection != null || !bleReady) return;
    logger.d('Start connection to device: ${_blePresetsController.bleDeviceDataForConnection.value?.deviceId}');
    _connection = ble
        .connectToDevice(
          id: _blePresetsController.bleDeviceDataForConnection.value!.deviceId,
          connectionTimeout: const Duration(seconds: 5),
        )
        .listen(
          (event) => _updateState(event.connectionState),
          onDone: () => logger.w('Не удалось подключиться к устройству!'),
        );
  }

  /// Метод разрыва соединения с BLE
  Future<void> disconnect() async {
    try {
      logger.d('disconnecting from device: ${_blePresetsController.bleDeviceDataForConnection.value?.deviceId}');
      await _connection?.cancel();
    } catch (e, s) {
      logger.e(
        'error disconnecting from device: ${_blePresetsController.bleDeviceDataForConnection.value?.deviceId}',
        error: e,
        stackTrace: s,
      );
    } finally {
      _updateState(DeviceConnectionState.disconnected);
    }
  }
}
