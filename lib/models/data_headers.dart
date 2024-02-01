/// Заголовки для задания типа пакета
enum DataHeader {
  /// Установка цвета RGB
  c(0x63),

  /// Установка яркости
  b(0x62);

  const DataHeader(this.codeUnit);

  final int codeUnit;
}
