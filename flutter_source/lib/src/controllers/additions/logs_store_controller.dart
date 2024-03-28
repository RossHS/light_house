import 'package:flutter/foundation.dart';
import 'package:light_house/src/models/log_message_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';

part 'logs_store_controller.g.dart';

// ignore: library_private_types_in_public_api
class LogsStoreController = _LogsStoreControllerBase with _$LogsStoreController;

/// Контроллер, который сохраняет все прешедшие логи в [logsList]
abstract class _LogsStoreControllerBase with Store {
  _LogsStoreControllerBase({Function(_LogsStoreControllerBase controller)? initCallback}) {
    // Запуск дополнительных настроек, которые необходимо сделать для запуска всех звеньев контроллера
    initCallback?.call(this);
  }

  /// Хранилище всех логов
  @observable
  List<LogMessage> logsList = <LogMessage>[];

  @action
  void addLog(LogMessage log) => logsList = [...logsList, log];
}

class InitCallbacks {
  InitCallbacks._();

  /// Подключение контроллера [LogsStoreController] к [Logger]
  // ignore: library_private_types_in_public_api
  static void connectControllerToLogger(_LogsStoreControllerBase logsStoreController) {
    Logger.addLogListener(
      (event) {
        MessageLevel level = switch (event.level) {
          Level.debug => MessageLevel.debug,
          Level.fatal || Level.error => MessageLevel.error,
          Level.warning => MessageLevel.warning,
          _ => MessageLevel.info,
        };

        logsStoreController.addLog(
          LogMessage(
            level: level,
            msg: event.message.toString(),
            stackTrace: event.stackTrace,
            time: event.time,
          ),
        );
      },
    );
  }

  /// Подключение ошибок Flutter и Dart к контроллеру [LogsStoreController]
  // ignore: library_private_types_in_public_api
  static void trackFlutterErrors(_LogsStoreControllerBase logsStoreController) {
    final flutterError = FlutterError.onError;
    FlutterError.onError = (errorDetails) {
      flutterError?.call(errorDetails);
      logsStoreController.addLog(LogMessage.error(errorDetails.toString(), stackTrace: errorDetails.stack));
    };

    final platformDispatcher = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      platformDispatcher?.call(error, stack);
      logsStoreController.addLog(LogMessage.error(error.toString(), stackTrace: stack));
      return true;
    };
  }
}
