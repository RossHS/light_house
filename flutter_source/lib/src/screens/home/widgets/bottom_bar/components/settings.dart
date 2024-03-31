import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:light_house/src/controllers/additions/settings_controller.dart';
import 'package:light_house/src/widgets/animated_button.dart';
import 'package:light_house/src/widgets/transitions/screen_transitions.dart';

/// Экран настроек приложения
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I<SettingsController>();
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.titleMedium!,
      child: Observer(
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: const Text('Glitch'),
                value: controller.glitchOn,
                onChanged: (value) => controller.glitchOn = value,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(height: 56),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Expanded(child: Text('Переходы')),
                      const SizedBox(width: 10),
                      ...CustomClippers.values.map(
                        (e) => ToggleAnimatedButton(
                          isSelected: e == controller.currentClipper,
                          onPressed: (value) => controller.currentClipper = e,
                          child: Text(
                            switch (e) {
                              CustomClippers.fan => 'Веер',
                              CustomClippers.triangle => 'Треугольник',
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  onPressed: () => context.go('/logs_screen'),
                  icon: const Icon(Icons.note),
                  label: const Text('Логи'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
