import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';

/// Колесо Hue для управления цветом лампы
class LightHue extends StatelessWidget {
  const LightHue({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final rgbController = GetIt.I<RGBController>();
        final brightnessController = GetIt.I<BrightnessController>();
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorPicker(
                labelTypes: const [],
                enableAlpha: false,
                displayThumbColor: false,
                colorPickerWidth: 350,
                paletteType: PaletteType.hueWheel,
                pickerColor: rgbController.color,
                onColorChanged: (color) {
                  rgbController.color = color;
                },
              ),
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
          ),
        );
      },
    );
  }
}
