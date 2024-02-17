import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/brightness_controller.dart';
import 'package:light_house/src/controllers/play_mode_controller.dart';
import 'package:light_house/src/controllers/rgb_controller.dart';
import 'package:light_house/src/models/play_mode_models.dart';
import 'package:light_house/src/screens/home/widgets/home_widgets.dart';
import 'package:light_house/src/widgets/animated_text_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: RunningTextAnimation(
              text: '0\nx\nF\nF\n0\n0\nE\n1\n_',
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Observer(
          //       builder: (context) {
          //         final rgbController = GetIt.I<RGBController>();
          //         final brightnessController = GetIt.I<BrightnessController>();
          //         final playModeController = GetIt.I<PlayModeController>();
          //         return Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: <Widget>[
          //             const SizedBox(height: 12),
          //             Slider(
          //               activeColor: Colors.red,
          //               value: rgbController.color.red.toDouble(),
          //               min: 0,
          //               max: 255,
          //               onChanged: (value) => rgbController.color = rgbController.color.withRed(value.toInt()),
          //             ),
          //             Slider(
          //               activeColor: Colors.green,
          //               value: rgbController.color.green.toDouble(),
          //               min: 0,
          //               max: 255,
          //               onChanged: (value) => rgbController.color = rgbController.color.withGreen(value.toInt()),
          //             ),
          //             Slider(
          //               activeColor: Colors.blue,
          //               value: rgbController.color.blue.toDouble(),
          //               min: 0,
          //               max: 255,
          //               onChanged: (value) => rgbController.color = rgbController.color.withBlue(value.toInt()),
          //             ),
          //             const SizedBox(height: 12),
          //             ColorPicker(
          //               labelTypes: const [],
          //               enableAlpha: false,
          //               displayThumbColor: false,
          //               colorPickerWidth: 300,
          //               paletteType: PaletteType.hueWheel,
          //               pickerColor: rgbController.color,
          //               onColorChanged: (color) {
          //                 rgbController.color = color;
          //               },
          //             ),
          //             const SizedBox(height: 12),
          //             const Text('Яркость'),
          //             Slider(
          //               activeColor: Colors.yellow,
          //               value: brightnessController.brightness.toDouble(),
          //               min: 0,
          //               max: 255,
          //               onChanged: (value) {
          //                 brightnessController.brightness = value.toInt();
          //               },
          //             ),
          //             DropdownButton<PlayModeBase>(
          //               value: playModeController.playMode,
          //               items: const [
          //                 DropdownMenuItem<PlayModeBase>(
          //                   value: DisabledPlayMode(),
          //                   child: Text('Отключен'),
          //                 ),
          //                 DropdownMenuItem<PlayModeBase>(
          //                   value: BrightnessPlayMode(),
          //                   child: Text('Плавная яркость'),
          //                 ),
          //                 DropdownMenuItem<PlayModeBase>(
          //                   value: ChangeColorPlayMode(),
          //                   child: Text('Плавный цвет'),
          //                 ),
          //               ],
          //               onChanged: (value) {
          //                 if (value != null) playModeController.playMode = value;
          //               },
          //             ),
          //           ],
          //         );
          //       },
          //     ),
          //   ),
          // ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(),
          ),
        ],
      ),
    );
  }
}