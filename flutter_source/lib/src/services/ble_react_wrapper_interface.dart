import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:light_house/src/services/ble_react_wrapper_impl.dart';

/// Абстрактный класс оболочка над [FlutterReactiveBle], в чем его смысл?
/// Предоставить удобный интерфейс для работы, который я могу мокать
/// и передавать нужные мне данные при необходимости
abstract interface class BleReactWrapperInterface {
  factory BleReactWrapperInterface() => _instance;

  static final BleReactWrapperInterface _instance = BleReactWrapperImpl();

  /// Подключение к устройству по его параметру [id]
  Stream<ConnectionStateUpdate> connectToDevice({
    required String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  });

  /// Поиск устройства с заданными сервисами [withServices]
  /// или вовсе без них
  Stream<DiscoveredDevice> scanForDevices({
    required List<Uuid> withServices,
    ScanMode scanMode = ScanMode.balanced,
    bool requireLocationServicesEnabled = true,
  });

  /// Отправка данных на bluetooth в заданную [characteristic]
  Future<void> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  });

  /// Возвращает стрим статуса подключения
  Stream<BleStatus> get statusStream;
}
