import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

/// Надо констант для подключения, которые зависят от платформы (Android или iOS)
@immutable
sealed class BLEDeviceDataForConnection {
  static BLEDeviceDataForConnection? _instance;

  static BLEDeviceDataForConnection get instance {
    if (_instance != null) return _instance!;
    _instance = kIsWeb
        ? _DumbBLEData()
        : switch (Platform.operatingSystem) {
            'ios' => _IosBLEData(),
            'android' => _AndroidBLEData(),
            _ => _DumbBLEData(),
          };
    return _instance!;
  }

  /// Id устройства для подключения
  String get deviceId;

  /// Сервис на который мы будем посылать данные
  Uuid get serviceId;
}

class _IosBLEData extends BLEDeviceDataForConnection {
  @override
  final String deviceId = '80866C62-E4A0-746F-D98A-DB32EFE2AC25';

  @override
  final Uuid serviceId = Uuid.parse('ffe0');
}

class _AndroidBLEData extends BLEDeviceDataForConnection {
  @override
  final String deviceId = 'F0:C7:7F:B0:9C:BE';

  @override
  final Uuid serviceId = Uuid.parse('0000ffe0-0000-1000-8000-00805f9b34fb');
}

/// Заглушка, если производим запуск на любой другой платформе
class _DumbBLEData extends BLEDeviceDataForConnection {
  @override
  final String deviceId = '';

  @override
  final Uuid serviceId = Uuid([]);
}
