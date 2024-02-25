import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/app_theme_controller.dart';
import 'package:light_house/src/widgets/rotation_switch_widget.dart';

/// Кнопка, которая переключает световую тему приложения
class AppThemeChangeButton extends StatelessWidget {
  const AppThemeChangeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final themeModeController = GetIt.I<AppThemeController>();
        final themeMode = themeModeController.themeMode;

        final child = switch (themeMode) {
          ThemeMode.light => const Icon(
              key: ValueKey(ThemeMode.light),
              Icons.light_mode,
              color: Colors.black,
            ),
          ThemeMode.dark => const Icon(
              key: ValueKey(ThemeMode.dark),
              Icons.dark_mode,
              color: Colors.white,
            ),
          ThemeMode.system =>const Icon(
            key: ValueKey(ThemeMode.system),
            Icons.line_axis,
          ),
        };
        return IconButton(
          onPressed: themeModeController.setNext,
          icon: RotationSwitchWidget(
            child: child,
          ),
        );
      },
    );
  }
}
