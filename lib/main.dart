import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/controllers/brightness_controller.dart';
import 'package:light_house/controllers/play_mode_controller.dart';
import 'package:light_house/controllers/rgb_controller.dart';
import 'package:light_house/controllers/send_data_controller.dart';
import 'package:light_house/models/play_mode_models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _diRegisters();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Light House',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Observer(
            builder: (context) {
              final rgbController = GetIt.I<RGBController>();
              final brightnessController = GetIt.I<BrightnessController>();
              final playModeController = GetIt.I<PlayModeController>();
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 12),
                  Slider(
                    activeColor: Colors.red,
                    value: rgbController.color.red.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) => rgbController.color = rgbController.color.withRed(value.toInt()),
                  ),
                  Slider(
                    activeColor: Colors.green,
                    value: rgbController.color.green.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) => rgbController.color = rgbController.color.withGreen(value.toInt()),
                  ),
                  Slider(
                    activeColor: Colors.blue,
                    value: rgbController.color.blue.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) => rgbController.color = rgbController.color.withBlue(value.toInt()),
                  ),
                  const SizedBox(height: 12),
                  ColorPicker(
                    labelTypes: const [],
                    enableAlpha: false,
                    displayThumbColor: false,
                    colorPickerWidth: 300,
                    paletteType: PaletteType.hueWheel,
                    pickerColor: rgbController.color,
                    onColorChanged: (color) {
                      rgbController.color = color;
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Яркость'),
                  Slider(
                    activeColor: Colors.yellow,
                    value: brightnessController.brightness.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) {
                      brightnessController.brightness = value.toInt();
                    },
                  ),
                  DropdownButton<PlayModeBase>(
                    value: playModeController.playMode,
                    items: const [
                      DropdownMenuItem<PlayModeBase>(
                        value: DisabledPlayMode(),
                        child: Text('Отключен'),
                      ),
                      DropdownMenuItem<PlayModeBase>(
                        value: BrightnessPlayMode(),
                        child: Text('Плавная яркость'),
                      ),
                      DropdownMenuItem<PlayModeBase>(
                        value: ChangeColorPlayMode(),
                        child: Text('Плавный цвет'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) playModeController.playMode = value;
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Регистрация данных в сервис для контроллеров через GetIt
void _diRegisters() {
  GetIt.I.registerSingleton(SendDataController());
  GetIt.I.registerSingleton(RGBController());
  GetIt.I.registerSingleton(BrightnessController());
  GetIt.I.registerSingleton(PlayModeController());
}
