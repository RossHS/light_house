import 'package:logger/logger.dart';

/// Стандартный логгер, который следует использовать по всему приложению
final logger = Logger(
  printer: PrettyPrinter(
    printTime: true,
  ),
);
