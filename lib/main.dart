import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:light_house/src/controllers/additions/app_theme_controller.dart';
import 'package:light_house/src/controllers/additions/my_colors_controller.dart';
import 'package:light_house/src/controllers/core/brightness_controller.dart';
import 'package:light_house/src/controllers/core/play_mode_controller.dart';
import 'package:light_house/src/controllers/core/rgb_controller.dart';
import 'package:light_house/src/controllers/core/send_data_controller.dart';
import 'package:light_house/src/screens/home/home_screen.dart';
import 'package:light_house/src/utils/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await _diRegisters();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final appThemeController = GetIt.I<AppThemeController>();
        return MaterialApp(
          title: 'Light House',
          themeMode: appThemeController.themeMode.rawMode,
          theme: appThemeController.themeMode.rawMode != ThemeMode.system
              ? lightTheme
              : generateThemeData(
                  seedColor: GetIt.I<RGBController>().color,
                  brightness: switch (appThemeController.themeMode) {
                    ThemeModeExtension.systemLight => Brightness.light,
                    ThemeModeExtension.systemDark => Brightness.dark,
                    _ => Brightness.light,
                  },
                ),
          darkTheme: dartTheme,
          home: const HomeScreen(),
        );
      },
    );
  }
}

/// Регистрация данных в сервис для контроллеров через GetIt
Future<void> _diRegisters() async {
  final prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton(prefs);
  GetIt.I.registerSingleton(SendDataController());
  GetIt.I.registerSingleton(RGBController());
  GetIt.I.registerSingleton(BrightnessController());
  GetIt.I.registerSingleton(PlayModeController());
  GetIt.I.registerSingleton(MyColorsController());
  GetIt.I.registerSingleton(AppThemeController(prefs));
}
