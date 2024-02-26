import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';

/// Контент оверлея управления цветом и яркостью через слайдеры
class LightSliders extends StatelessWidget {
  const LightSliders({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final rgbController = GetIt.I<RGBController>();
        final brightnessController = GetIt.I<BrightnessController>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              activeColor: Colors.red,
              value: rgbController.color.red.toDouble(),
              min: 0,
              max: 255,
              onChanged: (value) => rgbController.withRed(value.toInt()),
            ),
            Slider(
              activeColor: Colors.green,
              value: rgbController.color.green.toDouble(),
              min: 0,
              max: 255,
              onChanged: (value) => rgbController.withGreen(value.toInt()),
            ),
            Slider(
              activeColor: Colors.blue,
              value: rgbController.color.blue.toDouble(),
              min: 0,
              max: 255,
              onChanged: (value) => rgbController.withBlue(value.toInt()),
            ),
            const SizedBox(height: 12),
            Slider(
              activeColor: Colors.yellow,
              value: brightnessController.brightness.toDouble(),
              min: 0,
              max: 255,
              onChanged: (value) {
                brightnessController.brightness = value.toInt();
              },
            ),
          ],
        );
      },
    );
  }
}
