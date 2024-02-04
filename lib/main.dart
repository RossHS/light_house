import 'package:flutter/material.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                  // Text('0x$_red, 0x$_green, 0x$_blue; hash -0x${calcHashSum([_red, _green, _blue]).toRadixString(16)}'),
                  const SizedBox(height: 12),
                  Slider(
                    activeColor: Colors.red,
                    value: rgbController.red.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) {
                      rgbController.red = value.toInt();
                    },
                  ),
                  Slider(
                    activeColor: Colors.green,
                    value: rgbController.green.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) {
                      rgbController.green = value.toInt();
                    },
                  ),
                  Slider(
                    activeColor: Colors.blue,
                    value: rgbController.blue.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) {
                      rgbController.blue = value.toInt();
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
