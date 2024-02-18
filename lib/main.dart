import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/core/brightness_controller.dart';
import 'package:light_house/src/controllers/core/play_mode_controller.dart';
import 'package:light_house/src/controllers/core/rgb_controller.dart';
import 'package:light_house/src/controllers/core/send_data_controller.dart';
import 'package:light_house/src/screens/home/home_screen.dart';

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
        fontFamily: 'JetBrains Mono',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const HomeScreen(),
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
