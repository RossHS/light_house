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
          ThemeModeExtension.light => const Icon(
              key: ValueKey(ThemeModeExtension.light),
              Icons.light_mode,
            ),
          ThemeModeExtension.dark => const Icon(
              key: ValueKey(ThemeModeExtension.dark),
              Icons.dark_mode,
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
