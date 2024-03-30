import 'package:flutter/material.dart';
import 'package:light_house/src/models/log_message_model.dart';

/// Вывод на экран логов с учетом фильтрации [selectedMessageLevel]
class LogsView extends StatelessWidget {
  const LogsView({
    super.key,
    required this.selectedMessageLevel,
    required this.logs,
  });

  final Set<MessageLevel> selectedMessageLevel;
  final List<LogMessage> logs;

  @override
  Widget build(BuildContext context) {
    var logsList = logs;
    if (selectedMessageLevel.isNotEmpty) {
      logsList = logsList.where((log) => selectedMessageLevel.contains(log.level)).toList();
    }
    return ListView.builder(
      itemCount: logsList.length,
      itemBuilder: (context, index) {
        final log = logsList[index];
        return Text(
          '[${log.time}:${log.level.name}]\t${log.msg}',
        );
      },
    );
  }
}
