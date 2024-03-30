import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/logs_store_controller.dart';
import 'package:light_house/src/controllers/additions/settings_controller.dart';
import 'package:light_house/src/models/log_message_model.dart';
import 'package:light_house/src/screens/logs/widgets/filters_widgets.dart';

/// Экран с выводом логов приложения из [SettingsController]
class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: _Body()),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _selectedMessageLevel = ValueNotifier<Set<MessageLevel>>({});

  @override
  void dispose() {
    _selectedMessageLevel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logs = GetIt.I<LogsStoreController>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          FiltersBar(_selectedMessageLevel),
          Expanded(
            child: Observer(
              builder: (context) {
                final logsList = logs.logsList;
                return ValueListenableBuilder(
                  valueListenable: _selectedMessageLevel,
                  builder: (_, value, __) {
                    return LogsView(
                      selectedMessageLevel: value,
                      logs: logsList,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
