import 'package:flutter/material.dart';
import 'package:light_house/src/models/log_message_model.dart';
import 'package:light_house/src/screens/logs/widgets/logs_widgets.dart';

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
    final theme = Theme.of(context);
    var logsList = logs;
    if (selectedMessageLevel.isNotEmpty) {
      logsList = logsList.where((log) => selectedMessageLevel.contains(log.level)).toList();
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        border: Border.all(
          color: theme.colorScheme.onSurface,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: logsList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            // Выводим на самом верху самые последние логи
            final log = logsList[logsList.length - 1 - index];
            return LogViewItem(key: ValueKey(log), log);
          },
        ),
      ),
    );
  }
}
