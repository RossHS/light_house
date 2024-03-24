import 'package:light_house/src/models/log_message_model.dart';
import 'package:light_house/src/utils/mobx_async_value.dart';
import 'package:mobx/mobx.dart';

part 'logs_store_controller.g.dart';

// ignore: library_private_types_in_public_api
class LogsStoreController = _LogsStoreControllerBase with _$LogsStoreController;

/// Контроллер, который сохраняет все прешедшие логи в [logsList]
abstract class _LogsStoreControllerBase with Store {
  _LogsStoreControllerBase();

  /// Хранилище всех логов
  @observable
  List<LogMessage> logsList = <LogMessage>[];

  @action
  void addLog(LogMessage log) => logsList = [...logsList, log];
}
