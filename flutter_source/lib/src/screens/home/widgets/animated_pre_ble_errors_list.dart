import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/main.dart' as main;
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/widgets/errors_widgets/errors_widgets.dart';

const _padding = EdgeInsets.all(8.0);

/// Анимированный список, который используется исключительно для нотификации пользователя
/// о не пройденности всех этапов для полноценной работы приложения
/// Тут мы проверяем следующее
/// 1. Наличие bluetooth на устройстве и наличие всех разрешений для работы
/// 2. Найден ли необходимый BLE для подключения
class AnimatedPreBLEErrorsList extends StatefulWidget {
  const AnimatedPreBLEErrorsList({super.key});

  @override
  State<AnimatedPreBLEErrorsList> createState() => _AnimatedPreBLEErrorsListState();
}

class _AnimatedPreBLEErrorsListState extends State<AnimatedPreBLEErrorsList> {
  final List<Widget> _additionsErrors = [];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: mq.size.width / 2),
      child: RepaintBoundary(
        child: ErrorsAnimatedList(
          children: [
            const _BLEStatusInfo(key: ValueKey('BLE STATUS INFO')),
            // if (dataForConnectionWidget != null) dataForConnectionWidget,
            const _BLEDevicePresetsInitInfo(key: ValueKey('BLE DEVICE INFO')),
            ..._additionsErrors,
          ],
        ),
      ),
    );
  }
}

class _BLEStatusInfo extends StatelessWidget {
  const _BLEStatusInfo({required super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterReactiveBle().statusStream,
      builder: (context, s) {
        if (!s.hasData) return const SizedBox.shrink();
        return switch (s.requireData) {
          BleStatus.unsupported => const _ButtonShortHand(child: Text('BLE не поддерживается')),
          BleStatus.poweredOff => const _ButtonShortHand(child: Text('Включите Bluetooth')),
          BleStatus.unauthorized => const _ButtonShortHand(
              onPressed: main.permissionRequest,
              child: Text('Запросить разрешения?'),
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

/// Вывод информации и целевых действий под поиск девайса и предустановки данных для его подключения
class _BLEDevicePresetsInitInfo extends StatelessWidget {
  const _BLEDevicePresetsInitInfo({required super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final controller = GetIt.I<BLEDevicePresetsInitController>();

        final dataForConnection = controller.bleDeviceDataForConnection;
        if (dataForConnection.value != null) return const SizedBox();

        return dataForConnection.map(
          value: (value) => _ButtonShortHand(
            onPressed: controller.initBleSettings,
            child: const Text('Нет данных для подключения'),
          ),
          error: (error) => _ButtonShortHand(
            onPressed: controller.initBleSettings,
            child: Text(error.error!.errorMessage),
          ),
          loading: (loading) => const _ButtonShortHand(
            onPressed: null,
            child: Text('Поиск данных!'),
          ),
        );
      },
    );
  }
}

/// Вспомогательный виджет, дабы подогнать контент до нужный размеров
class _ErrorsSizeConstrains extends StatelessWidget {
  const _ErrorsSizeConstrains.text({
    super.key,
    required this.child,
  }) : constraints = const BoxConstraints(minWidth: double.infinity);

  const _ErrorsSizeConstrains.button({
    super.key,
    required this.child,
  }) : constraints = const BoxConstraints(minWidth: double.infinity, minHeight: 40);

  final BoxConstraints constraints;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: Center(child: child),
    );
  }
}

/// Чисто для упрощения вызывающего кода, дабы было поменьше дублей
class _ButtonShortHand extends StatelessWidget {
  const _ButtonShortHand({
    super.key,
    this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: ErrorsNotification.button(
        onPressed: onPressed,
        child: _ErrorsSizeConstrains.button(
          child: child,
        ),
      ),
    );
  }
}
