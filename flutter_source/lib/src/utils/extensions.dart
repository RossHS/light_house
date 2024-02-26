import 'dart:math' as math;

import 'package:flutter/material.dart';

extension IntExt on int {
  /// Перевод одного байта int в удобочитаемый формат hex. 10 -> 0A, 255 -> FF
  String get uint8HexFormat => _worker(8, 2);

  /// Перевод 3 последовательных байтов int в удобочитаемый формат hex. 10 -> 00000A, 13_361_120 -> CBDFE0
  /// Используется для преобразования цвета из DEC в HEX
  String get uint24HexFormat => _worker(24, 6);

  String _worker(int exponent, int padLength) {
    assert(this >= 0 && this <= math.pow(2, exponent), 'current value - $this');
    return toRadixString(16).padLeft(padLength, '0');
  }
}

/// Используется для определения цвета в зависимости от яркости предоставляемого цвета,
/// удобно для определения контрастных цветов
extension CalculateOpposite on Color {
  /// Для оптимизации кеширую уже рассчитанные цвета текста,
  /// т.к. computeLuminance весьма затратная операция
  static final _cache = <Color, Color>{};

  /// Расчет цвета, который бы не сливался с текущим
  Color get calcOppositeColor {
    return _cache.putIfAbsent(this, () => computeLuminance() > .5 ? Colors.black : Colors.white);
  }
}
