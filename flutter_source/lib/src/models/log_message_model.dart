import 'package:flutter/foundation.dart';

/// Логирующее сообщение.
/// где
/// [level] - уровень сообщения из [MessageLevel]
/// [msg] - текст для фиксации
/// [stackTrace] - возможный стек вызова на случай ошибки
@immutable
class LogMessage {
  LogMessage({
    required this.level,
    required this.msg,
    required this.stackTrace,
    DateTime? time,
  }) : time = time ?? DateTime.now();

  factory LogMessage.info(
    String msg, {
    DateTime? time,
  }) {
    return LogMessage(
      level: MessageLevel.info,
      msg: msg,
      time: time,
      stackTrace: null,
    );
  }

  factory LogMessage.debug(
    String msg, {
    DateTime? time,
  }) {
    return LogMessage(
      level: MessageLevel.debug,
      msg: msg,
      time: time,
      stackTrace: null,
    );
  }

  factory LogMessage.error(
    String msg, {
    DateTime? time,
    StackTrace? stackTrace,
  }) {
    return LogMessage(
      level: MessageLevel.error,
      msg: msg,
      time: time,
      stackTrace: stackTrace,
    );
  }

  factory LogMessage.warning(
    String msg, {
    DateTime? time,
    StackTrace? stackTrace,
  }) {
    return LogMessage(
      level: MessageLevel.warning,
      msg: msg,
      time: time,
      stackTrace: stackTrace,
    );
  }

  final MessageLevel level;
  final String msg;
  final StackTrace? stackTrace;
  final DateTime time;
}

/// Уровни логов
enum MessageLevel {
  error,
  info,
  debug,
  warning,
}
