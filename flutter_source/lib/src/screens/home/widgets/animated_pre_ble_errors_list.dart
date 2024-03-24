import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/main.dart' as main;
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/widgets/errors_widgets/errors_widgets.dart';
import 'package:mobx/mobx.dart';

const _padding = EdgeInsets.all(8.0);

/// Анимированный список, который используется исключительно для нотификации пользователя
/// о не пройденности всех этапов для полноценной работы приложения
/// Тут мы проверяем следующее
/// 1. Наличие bluetooth на устройстве и наличие всех разрешений для работы
/// 2. Найден ли необходимый BLE для подключения
/// TODO 24.03.2024 - п.с. к сожалению вышел не самый удачный и красивый код, но пока оставим так, возможно потом поменяем (нет 🤡)
class AnimatedPreBLEErrorsList extends StatefulWidget {
  const AnimatedPreBLEErrorsList({super.key});

  @override
  State<AnimatedPreBLEErrorsList> createState() => _AnimatedPreBLEErrorsListState();
}

class _AnimatedPreBLEErrorsListState extends State<AnimatedPreBLEErrorsList> {
  late StreamSubscription<BleStatus> _bleStatusListener;
  late ReactionDisposer _react;

  Widget _bleStatusWidget = const SizedBox.shrink(key: ValueKey('NON BLE STATUS INFO'));
  Widget _bleDeviceInfoWidget = const SizedBox.shrink(key: ValueKey('NON BLE DEVICE INFO'));
  final List<Widget> _additionsErrors = [];

  @override
  void initState() {
    super.initState();

    // Да, не самый красивый и понятный код, но все из-за ограничений при работе с [ErrorsAnimatedList]
    // Т.е. у нас в верхнем уровне обязательно должен быть именно конечный виджет для отрисовки,
    // таким образом, если добавить в само дерево [StreamBuilder], то у нас поломается анимация добавления и удаления
    _bleStatusListener = FlutterReactiveBle().statusStream.listen((event) {
      if (!mounted) return;
      setState(() {
        _bleStatusWidget = switch (event) {
          BleStatus.unsupported =>
            const _ButtonShortHand(key: ValueKey('BLE STATUS INFO'), child: Text('BLE не поддерживается')),
          BleStatus.poweredOff =>
            const _ButtonShortHand(key: ValueKey('BLE STATUS INFO'), child: Text('Включите Bluetooth')),
          BleStatus.unauthorized => const _ButtonShortHand(
              key: ValueKey('BLE STATUS INFO'),
              onPressed: main.permissionRequest,
              child: Text('Запросить разрешения?'),
            ),
          _ => const SizedBox.shrink(key: ValueKey('NON BLE STATUS INFO')),
        };
      });
    });
    _react = reaction(
      (_) => GetIt.I<BLEDevicePresetsInitController>().bleDeviceDataForConnection,
      fireImmediately: true,
      (dataForConnection) {
        if (!mounted) return;

        if (dataForConnection.value != null) {
          setState(() {
            _bleDeviceInfoWidget = const SizedBox.shrink(
              key: ValueKey('NON BLE DEVICE INFO'),
            );
          });
          return;
        }
        final controller = GetIt.I<BLEDevicePresetsInitController>();
        setState(() {
          _bleDeviceInfoWidget = dataForConnection.map(
            value: (value) => _ButtonShortHand(
              key: const ValueKey('BLE DEVICE INFO NON DATA'),
              onPressed: controller.initBleSettings,
              child: const Text('Нет данных для подключения'),
            ),
            error: (error) => _ButtonShortHand(
              key: const ValueKey('BLE DEVICE INFO ERROR'),
              onPressed: controller.initBleSettings,
              child: Text(error.error!.errorMessage),
            ),
            loading: (loading) => const _ButtonShortHand(
              key: ValueKey('BLE DEVICE INFO LOADING'),
              onPressed: null,
              child: Text('Поиск данных!'),
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _bleStatusListener.cancel();
    _react();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: mq.size.width / 2),
      child: RepaintBoundary(
        child: ErrorsAnimatedList(
          children: [
            _bleStatusWidget,
            _bleDeviceInfoWidget,
            ..._additionsErrors,
          ],
        ),
      ),
    );
  }
}

/// Вспомогательный виджет, дабы подогнать контент до нужный размеров.
/// Опять же, вынес логику в отдельный виджет, дабы не повторяться
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
