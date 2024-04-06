import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/services/ble_react_wrappers.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:light_house/src/controllers/ble_core/rgb_controller.dart';

/// Визуализация отправки данных
class DemoStand extends StatefulWidget {
  const DemoStand({
    super.key,
    required this.mqd,
  });

  final MediaQueryData mqd;

  @override
  State<DemoStand> createState() => _DemoStandState();
}

class _DemoStandState extends State<DemoStand> {
  final bleReactWrapperMock = GetIt.I<BleReactWrapperInterface>() as BleReactWrapperMock;

  @override
  void initState() {
    super.initState();
    bleReactWrapperMock.dataListener = (value) {
      print(value);
    };
  }

  @override
  void dispose() {
    bleReactWrapperMock.dataListener = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: MediaQuery(
          data: widget.mqd.copyWith(size: Size(widget.mqd.size.longestSide, widget.mqd.size.longestSide)),
          child: SizedBox.square(
            dimension: widget.mqd.size.longestSide,
            child: Observer(
              builder: (context) {
                final rgbController = GetIt.I<RGBController>();
                return Container(
                  color: rgbController.color,
                  child: Text('pepega'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
