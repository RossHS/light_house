import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/settings_controller.dart';

/// Экран настроек приложения
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I<SettingsController>();
    return Observer(
      builder: (context) {
        return SwitchListTile(
          title: const Text('Glitch'),
          value: controller.glitchOn,
          onChanged: (value) => controller.glitchOn = value,
        );
      },
    );
  }
}
