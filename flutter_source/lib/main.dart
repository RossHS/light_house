import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:light_house/navigation.dart';
import 'package:light_house/src/controllers/additions/app_theme_controller.dart';
import 'package:light_house/src/controllers/additions/logs_store_controller.dart';
import 'package:light_house/src/controllers/additions/my_colors_controller.dart';
import 'package:light_house/src/controllers/additions/settings_controller.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/services/ble_react_wrappers.dart';
import 'package:light_house/src/utils/app_themes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await permissionRequest();
  await diRegisters(isMock: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final appThemeController = GetIt.I<AppThemeController>();
        return MaterialApp.router(
          routerConfig: router,
          title: 'Light House',
          themeMode: appThemeController.themeMode.rawMode,
          theme: generateThemeData(seedColor: GetIt.I<RGBController>().color, brightness: Brightness.light),
          darkTheme: generateThemeData(seedColor: GetIt.I<RGBController>().color, brightness: Brightness.dark),
        );
      },
    );
  }
}

/// Регистрация данных в сервис для контроллеров через GetIt
// TODO 03.04.2024 - подумать, как лучше организовать прокидывание mock данных
Future<void> diRegisters({bool isMock = false}) async {
  // Регистрация хранилища логов.
  GetIt.I.registerSingleton<LogsStoreController>(
    LogsStoreController(
      initCallback: (controller) {
        InitCallbacks.connectControllerToLogger(controller);
        InitCallbacks.trackFlutterErrors(controller);
      },
    ),
  );
  GetIt.I.registerSingleton<BleReactWrapperInterface>(isMock ? BleReactWrapperMock() : BleReactWrapperImpl());
  final prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(prefs);
  // BLE
  GetIt.I.registerSingleton<BLEDevicePresetsInitController>(BLEDevicePresetsInitController());
  GetIt.I.registerSingleton<BLEConnectionController>(BLEConnectionController());
  GetIt.I.registerSingleton<SendDataController>(SendDataController());
  GetIt.I.registerSingleton<RGBController>(RGBController());
  GetIt.I.registerSingleton<BrightnessController>(BrightnessController());
  GetIt.I.registerSingleton<PlayModeController>(PlayModeController());

  // Установка вспомогательных контроллеров
  GetIt.I.registerSingleton<MyColorsController>(MyColorsController());
  GetIt.I.registerSingleton<AppThemeController>(AppThemeController(prefs));
  GetIt.I.registerSingleton<SettingsController>(SettingsController(prefs));
}

/// Запрос разрешений для корректной работы
/// TODO 18.03.2024 - подумать о том, чтоб вынести это все добро в отдельный контроллер!
Future<void> permissionRequest() async {
  // Для веба данные разрешения не подходят!
  if (kIsWeb) return;
  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();
}
