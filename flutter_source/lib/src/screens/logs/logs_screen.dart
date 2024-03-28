import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/logs_store_controller.dart';
import 'package:light_house/src/controllers/additions/settings_controller.dart';

/// Экран с выводом логов приложения [SettingsController]
class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = GetIt.I<LogsStoreController>();
    return Observer(
      builder: (context) {
        final logsList = logs.logsList;
        return ListView.builder(
          itemCount: logsList.length,
          itemBuilder: (context, index) {
            return Text(
              logsList[index].msg,
            );
          },
        );
      },
    );
  }
}
