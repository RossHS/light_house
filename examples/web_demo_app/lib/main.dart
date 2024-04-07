import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:light_house/main.dart' as lh;
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house_web_demo_app/controllers/demo_play_mods_controller.dart';
import 'package:light_house_web_demo_app/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await lh.permissionRequest();
  await lh.diRegisters(isMock: true);
  // Установка первичного цвета в белый, дабы было видно изображение
  GetIt.I<RGBController>().color = Colors.white;
  GetIt.I.registerSingleton<DemoPlayModeController>(DemoPlayModeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(fontFamily: 'JetBrains Mono'),
      routerConfig: router,
      title: 'Light House',
    );
  }
}
