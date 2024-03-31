import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/logs_store_controller.dart';
import 'package:light_house/src/models/log_message_model.dart';
import 'package:light_house/src/widgets/rotation_switch_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Кнопка - поделиться логами с устройства из хранилища [LogsStoreController]
class LogsShareButton extends StatelessWidget {
  const LogsShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();
    return Observer(
      builder: (context) {
        final logs = GetIt.I<LogsStoreController>().logsList;
        return RotationSwitchWidget(
          child: logs.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    shareLogs(logs);
                  },
                  icon: const Icon(Icons.share),
                ),
        );
      },
    );
  }
}

/// Функция объединения логов в единый файл и его отправку стандартными средствами платформы
Future<void> shareLogs(List<LogMessage> logs) async {
  final dir = await getTemporaryDirectory();
  final dirPath = dir.path;
  final fmtDate = DateTime.now().toString().replaceAll(':', ' ');
  final file = await File('$dirPath/light_house_logs_$fmtDate.txt').create(recursive: true);
  final fileData = logs.map((e) => e.toFormattedString()).join('\n');
  await file.writeAsString(fileData);
  await Share.shareXFiles(
    <XFile>[
      XFile(file.path),
    ],
  );
}
