import 'package:flutter/foundation.dart';

/// Логирующее сообщение.
/// где
/// [level] - уровень сообщения из [MessageLevel]
/// [msg] - текст для фиксации
/// [stackTrace] - возможный стек вызова на случай ошибки
@immutable
class LogMessage {
  const LogMessage({required this.level, required this.msg, required this.stackTrace});

  const LogMessage.info(
    this.msg,
  )   : level = MessageLevel.info,
        stackTrace = null;

  const LogMessage.debug(
    this.msg,
  )   : level = MessageLevel.debug,
        stackTrace = null;

  const LogMessage.error(
    this.msg, {
    this.stackTrace,
  }) : level = MessageLevel.error;

  const LogMessage.warning(
    this.msg, {
    this.stackTrace,
  }) : level = MessageLevel.warning;

  final MessageLevel level;
  final String msg;
  final StackTrace? stackTrace;
}

/// Уровни логов
enum MessageLevel {
  error,
  info,
  debug,
  warning,
}
