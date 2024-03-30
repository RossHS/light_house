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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogMessage &&
          runtimeType == other.runtimeType &&
          level == other.level &&
          msg == other.msg &&
          stackTrace == other.stackTrace &&
          time == other.time;

  @override
  int get hashCode => Object.hashAll([
        level.hashCode,
        msg.hashCode,
        stackTrace.hashCode,
        time.hashCode,
      ]);

  @override
  String toString() {
    return 'LogMessage{level: $level, msg: $msg, stackTrace: $stackTrace, time: $time}';
  }

  String toFormattedString() {
    return '[$time:${level.name}]\t$msg${stackTrace == null ? '' : '\nStackTrace:\n$stackTrace'}';
  }
}

/// Уровни логов
enum MessageLevel {
  error,
  info,
  debug,
  warning,
}
