import 'package:flutter/foundation.dart';
import 'package:light_house/src/utils/extensions.dart';

/// Базовый объект для режима проигрывания цветом
@immutable
sealed class PlayModeBase {
  const PlayModeBase();

  /// Один символ названия мода
  String get modeName;

  /// Сформированный пакет, который уходит на плату
  @mustCallSuper
  String get genData => modeName;
}

/// Режим проигрывания отключен
class DisabledPlayMode extends PlayModeBase {
  const DisabledPlayMode();

  @override
  String get modeName => '0';
}

/// Режим плавной яркости
class BrightnessPlayMode extends PlayModeBase {
  const BrightnessPlayMode({
    this.delay = 0,
  });

  /// Задержка между сменой яркости, измеряется в 1 байта. Т.е. скорость проигрывания
  final int delay;

  @override
  String get modeName => '1';

  @override
  String get genData => '${super.genData}${delay.uint8HexFormat}';
}

/// Плавное перетекание цвета
class ChangeColorPlayMode extends PlayModeBase {
  const ChangeColorPlayMode();

  @override
  String get modeName => '2';
}
