import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/core/brightness_controller.dart';
import 'package:light_house/src/controllers/core/rgb_controller.dart';

/// Колесо Hue для управления цветом лампы
class LightHue extends StatelessWidget {
  const LightHue({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final rgbController = GetIt.I<RGBController>();
        final brightnessController = GetIt.I<BrightnessController>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              labelTypes: const [],
              enableAlpha: false,
              displayThumbColor: false,
              colorPickerWidth: 500,
              paletteType: PaletteType.hueWheel,
              pickerColor: rgbController.color,
              onColorChanged: (color) {
                rgbController.color = color;
              },
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
        );
      },
    );
  }
}
