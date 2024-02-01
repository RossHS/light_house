import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:light_house/models/data_headers.dart';
import 'package:light_house/utils/logger.dart';
import 'package:light_house/utils/mobx_async_value.dart';
import 'package:light_house/utils/utils.dart';
import 'package:mobx/mobx.dart';

part 'send_data_controller.g.dart';

// ignore: library_private_types_in_public_api
class SendDataController = _SendDataControllerBase with _$SendDataController;

/// Контроллер отвечает за отправку данных по BLE на специальный, заранее известный модуль
abstract class _SendDataControllerBase with Store {
  /// Последний отправленный пакет, необходим для того, чтобы не отправлять дубли по bluetooth
  @observable
  AsyncValue<String> _lastSendData = const AsyncValue.value();

  AsyncValue<String> get lastSendData => _lastSendData;

  bool _isSending = false;

  /// Структура уходящего пакета
  /// # (значение 35 (0x23)) - начало строки
  /// [data] - полезная нагрузка
  /// %hash_sum% - контрольная сумма пакета, отправляется в виде байта. Всегда идет предпоследним
  /// $ (значение 36 (0x24)) - символы окончания строки
  // TODO 01.02.2024 - Сделать синхронизацию, чтобы пакеты не отправлялись в перемешку, до отправки предыдущего пакета
  @action
  Future<void> writeData(DataHeader header, String data) async {
    if (_lastSendData.value == data || _isSending) return;
    _lastSendData = AsyncValue.value(value: data);
    try {
      _isSending = true;
      await FlutterReactiveBle().writeCharacteristicWithoutResponse(
        QualifiedCharacteristic(
          characteristicId: Uuid.parse('0000ffe1-0000-1000-8000-00805f9b34fb'),
          serviceId: Uuid.parse('0000ffe0-0000-1000-8000-00805f9b34fb'),
          deviceId: 'F0:C7:7F:B0:9C:BE',
        ),
        value: [
          0x23, // начало пакета
          header.codeUnit,
          ...data.codeUnits,
          calcHashSum('${header.name}$data'),
          0x24, // конец пакета
        ],
      );
    } catch (e, s) {
      logger.e('send bluetooth package error, header - $header, data - $data', error: e, stackTrace: s);
      _lastSendData = const AsyncValue.error(error: AsyncError(errorMessage: 'Не удалось передать данные!'));
    } finally {
      _isSending = false;
    }
  }
}
