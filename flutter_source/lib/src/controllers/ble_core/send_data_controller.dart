import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/models/data_headers.dart';
import 'package:light_house/src/utils/logger.dart';
import 'package:light_house/src/utils/mobx_async_value.dart';
import 'package:light_house/src/utils/utils.dart';
import 'package:mobx/mobx.dart';

part 'send_data_controller.g.dart';

// ignore: library_private_types_in_public_api
class SendDataController = _SendDataControllerBase with _$SendDataController;

/// Контроллер отвечает за отправку данных по BLE на специальный, заранее известный модуль
abstract class _SendDataControllerBase with Store {
  _SendDataControllerBase() {
    reaction(
      (_) => _bleConnectionController.connectionStates,
      (connectionState) {
        switch (connectionState) {
          case DeviceConnectionState.connected:
            _completer.complete(true);
            break;
          case DeviceConnectionState.disconnected:
            _completer.complete(false);
            break;
          default:
            break;
        }
      },
    );
  }

  /// Последний отправленный пакет, необходим для того, чтобы не отправлять дубли по bluetooth
  @observable
  AsyncValue<String> _lastSendData = const AsyncValue.value();

  AsyncValue<String> get lastSendData => _lastSendData;

  bool _isSending = false;

  final _bleConnectionController = GetIt.I<BLEConnectionController>();

  /// Completer для организации синхронизации этого контроллера с контроллером [BLEConnectionController],
  /// при помощи него мы можем автоматически подключаться к BLE и отправлять по нему данные
  Completer<bool> _completer = Completer();

  final _bleDevicePresetsInitController = GetIt.I<BLEDevicePresetsInitController>();

  /// Структура уходящего пакета
  ///
  /// \# (значение 35 (0x23)) - начало строки
  ///
  /// [data] - полезная нагрузка
  ///
  /// %hash_sum% - контрольная сумма пакета, отправляется в виде байта. Всегда идет предпоследним
  ///
  /// $ (значение 36 (0x24)) - символы окончания строки
  // TODO 17.03.2024 - Подумать как упростить метод, сейчас сильно он перегружен и запутан
  @action
  Future<void> writeData(DataHeader header, String data) async {
    if (_lastSendData.value == data || _isSending) return;
    _isSending = true;
    if (_bleConnectionController.connectionStates == DeviceConnectionState.disconnected) {
      _bleConnectionController.connect();
    }

    // Ждем подключения до BLE, если его не произошло, то можно смело скидывать Completer
    final connected = await _completer.future;
    if (!connected) {
      logger.w('BLE not connected');
      _completer = Completer();
      return;
    }

    // Непосредственно отправка данных
    try {
      _lastSendData = AsyncValue.value(value: data);
      await _bleConnectionController.ble.writeCharacteristicWithoutResponse(
        QualifiedCharacteristic(
          characteristicId: Uuid.parse('0000ffe1-0000-1000-8000-00805f9b34fb'),
          serviceId: _bleDevicePresetsInitController.bleDeviceDataForConnection.value!.serviceId,
          deviceId: _bleDevicePresetsInitController.bleDeviceDataForConnection.value!.deviceId,
        ),
        value: [
          0x23, // начало пакета
          header.codeUnit,
          ...data.codeUnits,
          calcHashSum('${header.name}$data'),
          0x24, // конец пакета
        ],
      );
      _bleConnectionController.resetConnectionTimeout();
    } catch (e, s) {
      logger.e('send bluetooth package error, header - $header, data - $data', error: e, stackTrace: s);
      _lastSendData = const AsyncValue.error(error: AsyncError(errorMessage: 'Не удалось передать данные!'));
    } finally {
      _isSending = false;
    }
  }
}
