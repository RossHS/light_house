import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide FlutterReactiveBle;
import 'package:get_it/get_it.dart';
import 'package:light_house/src/services/ble_react_wrapper_interface.dart';
import 'package:light_house/src/utils/logger.dart';
import 'package:light_house/src/utils/mobx_async_value.dart';
import 'package:light_house/src/utils/sp_keys.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'ble_device_presets_init_controller.g.dart';

// ignore: library_private_types_in_public_api
class BLEDevicePresetsInitController = _BLEDevicePresetsInitControllerBase with _$BLEDevicePresetsInitController;

/// Контроллер поиска и установок настроек необходимых для подключения в BLE
abstract class _BLEDevicePresetsInitControllerBase with Store {
  _BLEDevicePresetsInitControllerBase() {
    _searchSPForData();
  }

  final _sp = GetIt.I<SharedPreferences>();

  /// Таймер на отключение поиска, т.к. в противном случае таймер будет висеть вечно
  RestartableTimer? _timer;

  /// Упрощенная схема, рассчитанная на то, что девайс при первом поиске всегда под рукой.
  /// т.е. он ждет исключительно того, есть ли данные для подключения, вот и все.
  /// п.с. На самом деле можно и объединить с [bleDeviceDataForConnection]
  var bleDataInitedCompleter = Completer<bool>();

  /// Слушатель устройств
  StreamSubscription<DiscoveredDevice>? _listener;

  /// Данные для установки связи
  @observable
  AsyncValue<({String deviceId, Uuid serviceId})> bleDeviceDataForConnection = const AsyncValue.value();

  /// Инициализация данных для подключения, данный метод ищет bluetooth с названием `HMSoft`,
  /// после его нахождения сохраняет все его параметры, дабы каждый раз не производить поиск
  Future<void> initBleSettings() async {
    if (bleDeviceDataForConnection.value != null) {
      logger.i('BLE was recorded - $bleDeviceDataForConnection');
      return;
    }
    if (bleDataInitedCompleter.isCompleted || _listener != null) throw Exception('Incorrect controller states');

    if (_searchSPForData()) return;
    bleDeviceDataForConnection = const AsyncValue.loading();
    _setTimer();
    _listener = GetIt.I<BleReactWrapperInterface>().scanForDevices(withServices: []).listen((event) {
      if (event.name == 'HMSoft') {
        logger.d('correct device found - $event');
        _timer?.cancel();
        _listener?.cancel();
        _listener = null;
        final deviceId = event.id;
        final serviceId = event.serviceUuids.first;
        bleDeviceDataForConnection = AsyncValue.value(
          value: (
            deviceId: deviceId,
            serviceId: serviceId,
          ),
        );
        _sp.setString(bleDeviceIdKey, deviceId);
        _sp.setString(bleServiceIdKey, serviceId.toString());
        bleDataInitedCompleter.complete(true);
      }
    });
  }

  void _setTimer() {
    // Отмена предыдущего таймера, если он есть
    _timer?.cancel();
    _timer = RestartableTimer(const Duration(seconds: 5), () {
      logger.w('Не удалось найти необходимое BLE Устройство. Возможно оно выключено! 💩');
      bleDeviceDataForConnection = const AsyncValue.error(
        error: AsyncError(errorMessage: 'Устройство не найдено'),
      );
      bleDataInitedCompleter.complete(false);
      bleDataInitedCompleter = Completer();
      _listener?.cancel();
      _listener = null;
    });
  }

  /// Проверка, есть ли данные для подключения в SP, если они есть, то заносим их в локальную переменную
  @action
  bool _searchSPForData() {
    if (_sp.containsKey(bleDeviceIdKey) && _sp.containsKey(bleServiceIdKey)) {
      bleDeviceDataForConnection = AsyncValue.value(
        value: (
          deviceId: _sp.getString(bleDeviceIdKey)!,
          serviceId: Uuid.parse(_sp.getString(bleServiceIdKey)!),
        ),
      );
      bleDataInitedCompleter.complete(true);
      return true;
    }
    return false;
  }
}
