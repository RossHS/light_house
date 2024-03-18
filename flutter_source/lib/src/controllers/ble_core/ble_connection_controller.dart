import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/utils/logger.dart';
import 'package:mobx/mobx.dart';

part 'ble_connection_controller.g.dart';

// ignore: library_private_types_in_public_api
class BLEConnectionController = _BLEConnectionControllerBase with _$BLEConnectionController;

/// Контроллер состояния подключения и отключения от BLE
abstract class _BLEConnectionControllerBase with Store {
  final ble = FlutterReactiveBle();
  final _bleDevicePresetsInitController = GetIt.I<BLEDevicePresetsInitController>();

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
    if (!_bleDevicePresetsInitController.bleDataInitedCompleter.isCompleted) {
      _bleDevicePresetsInitController.initBleSettings();
    }
    final bleReady = await _bleDevicePresetsInitController.bleDataInitedCompleter.future;
    if (_connection != null || !bleReady) return;
    logger.d('Start connection to device: ${_bleDevicePresetsInitController.bleDeviceDataForConnection?.deviceId}');
    _connection = ble.connectToDevice(id: _bleDevicePresetsInitController.bleDeviceDataForConnection!.deviceId).listen(
          (event) => _updateState(event.connectionState),
        );
  }

  /// Метод разрыва соединения с BLE
  Future<void> disconnect() async {
    try {
      logger.d('disconnecting from device: ${_bleDevicePresetsInitController.bleDeviceDataForConnection?.deviceId}');
      await _connection?.cancel();
    } catch (e, s) {
      logger.e(
        'error disconnecting from device: ${_bleDevicePresetsInitController.bleDeviceDataForConnection?.deviceId}',
        error: e,
        stackTrace: s,
      );
    } finally {
      _updateState(DeviceConnectionState.disconnected);
    }
  }
}
