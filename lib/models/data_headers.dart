/// Заголовки для задания типа пакета
enum DataHeader {
  /// Установка цвета RGB
  c(0x63),

  /// Установка яркости
  b(0x62),

  /// Переключение режима проигрывания
  m(0x6d);

  const DataHeader(this.codeUnit);

  final int codeUnit;
}
