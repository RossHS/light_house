import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart' hide FlutterReactiveBle;
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_connection_controller.dart';
import 'package:light_house/src/widgets/light_bubble.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Виджет с индикацией соединения с BLE, так-же он способен устанавливать и разрывать соединения
class BLEConnectionStatesIndicator extends StatelessWidget {
  const BLEConnectionStatesIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final controller = GetIt.I<BLEConnectionController>();
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (controller.connectionStates == DeviceConnectionState.connected) {
              controller.disconnect();
              HapticFeedback.heavyImpact();
            } else if (controller.connectionStates == DeviceConnectionState.disconnected) {
              controller.connect();
              HapticFeedback.heavyImpact();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _BLEConnectionStatesIndicatorRaw(
              connectionState: controller.connectionStates,
            ),
          ),
        );
      },
    );
  }
}

/// Просто отображение верстки
class _BLEConnectionStatesIndicatorRaw extends StatelessWidget {
  const _BLEConnectionStatesIndicatorRaw({
    required this.connectionState,
  });

  final DeviceConnectionState connectionState;

  @override
  Widget build(BuildContext context) {
    final color = switch (connectionState) {
      DeviceConnectionState.connected => Colors.greenAccent,
      DeviceConnectionState.connecting => Colors.amber,
      DeviceConnectionState.disconnecting => Colors.amber,
      DeviceConnectionState.disconnected => Colors.redAccent,
    };
    return LightBubble(
      color: color,
      radius: 20,
      brightness: 15,
    );
  }
}

//---------------------Widgetbook-----------------//
@widgetbook.UseCase(name: 'BLEConnectionStatesIndicatorRaw use case', type: _BLEConnectionStatesIndicatorRaw)
Widget bleConnectionStatesIndicatorRawWidgetUseCase(BuildContext context) {
  return const Center(
    child: _BLEConnectionStatesIndicatorRawWidgetbook(),
  );
}

class _BLEConnectionStatesIndicatorRawWidgetbook extends StatefulWidget {
  const _BLEConnectionStatesIndicatorRawWidgetbook();

  @override
  State<_BLEConnectionStatesIndicatorRawWidgetbook> createState() => _BLEConnectionStatesIndicatorRawWidgetbookState();
}

class _BLEConnectionStatesIndicatorRawWidgetbookState extends State<_BLEConnectionStatesIndicatorRawWidgetbook> {
  var connectionState = DeviceConnectionState.disconnected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BLEConnectionStatesIndicatorRaw(
          connectionState: connectionState,
        ),
        const SizedBox(width: 50),
        DropdownButton<DeviceConnectionState>(
          value: connectionState,
          items: DeviceConnectionState.values
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => connectionState = value!),
        ),
      ],
    );
  }
}
