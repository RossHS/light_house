import 'dart:async';
import 'package:async/async.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/utils/sp_keys.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'ble_device_presets_init_controller.g.dart';

// ignore: library_private_types_in_public_api
class BLEDevicePresetsInitController = _BLEDevicePresetsInitControllerBase with _$BLEDevicePresetsInitController;

/// Контроллер поиска и установок настроек необходимых для подключения в BLE
abstract class _BLEDevicePresetsInitControllerBase with Store {
  _BLEDevicePresetsInitControllerBase() {
    _initBleSettings();
  }

  final _sp = GetIt.I<SharedPreferences>();

  /// Таймер на отключение поиска, т.к. в противном случае таймер будет висеть вечно
  RestartableTimer? _timer;

  /// Упрощенная схема, рассчитанная на то, что девайс при первом поиске всегда под рукой.
  /// т.е. он ждет исключительно того, есть ли данные для подключения, вот и все.
  /// п.с. На самом деле можно и объединить с [bleDeviceDataForConnection]
  final bleDataInitedCompleter = Completer<bool>();

  /// Слушатель устройств
  StreamSubscription<DiscoveredDevice>? _listener;

  /// Данные для установки связи
  @observable
  ({String deviceId, Uuid serviceId})? bleDeviceDataForConnection;

  /// Инициализация данных для подключения, данный метод ищет bluetooth с названием `HMSoft`,
  /// после его нахождения сохраняет все его параметры, дабы каждый раз не производить поиск
  /// да, я понимаю, что система имеет кучу пробелом, но я стремлюсь за минимумом кода и
  /// большим удобством пользователя
  /// где подключение осуществляется автоматически
  Future<void> _initBleSettings() async {
    if (bleDataInitedCompleter.isCompleted) throw Exception('Incorrect controller states');

    if (_sp.containsKey(bleDeviceIdKey) && _sp.containsKey(bleServiceIdKey)) {
      bleDeviceDataForConnection = (
        deviceId: _sp.getString(bleDeviceIdKey)!,
        serviceId: Uuid.parse(_sp.getString(bleServiceIdKey)!),
      );
      bleDataInitedCompleter.complete(true);
      return;
    }

    _setTimer();
    _listener = FlutterReactiveBle().scanForDevices(withServices: []).listen((event) {
      if (event.name == 'HMSoft') {
        _timer?.cancel();
        _listener?.cancel();
        final deviceId = event.id;
        final serviceId = event.serviceUuids.first;
        bleDeviceDataForConnection = (
          deviceId: deviceId,
          serviceId: serviceId,
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
    _timer = RestartableTimer(const Duration(seconds: 5), () => _listener?.cancel());
  }
}
