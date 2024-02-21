import 'dart:math' as math;
extension IntExt on int {
  /// Перевод одного байта int в удобочитаемый формат hex. 10 -> 0A, 255 -> FF
  String get uint8HexFormat => _worker(8, 2);

  /// Перевод 3 последовательных байтов int в удобочитаемый формат hex. 10 -> 00000A, 13_361_120 -> CBDFE0
  /// Используется для преобразования цвета из DEC в HEX
  String get uint24HexFormat => _worker(24, 6);

  String _worker(int exponent, int padLength) {
    assert(this >= 0 && this <= math.pow(2, exponent), 'current value - $this');
    return toRadixString(16).padLeft(padLength,'0');
  }
}
