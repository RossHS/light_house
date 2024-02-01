extension IntExt on int {
  /// Перевод одного байта int в удобочитаемый формат hex. 10 -> 0x0A, 255 -> 0xFF
  String get uint8HexFormat {
    assert(this >= 0 && this <= 255);
    return toRadixString(16).padLeft(2, '0');
  }
}
