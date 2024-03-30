import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/logs_store_controller.dart';
import 'package:light_house/src/controllers/additions/settings_controller.dart';
import 'package:light_house/src/models/log_message_model.dart';
import 'package:light_house/src/widgets/animated_button.dart';

/// Экран с выводом логов приложения из [SettingsController]
class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _selectedMessageLevel = <MessageLevel>{};

  @override
  Widget build(BuildContext context) {
    final logs = GetIt.I<LogsStoreController>();
    const messageLevels = MessageLevel.values;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...messageLevels.map(
                  (e) => AnimatedButton(
                    onPressed: () {},
                    child: Text(e.name),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Observer(
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
            ),
          ),
        ],
      ),
    );
  }
}
