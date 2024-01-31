/// Алгоритм расчетной хэш суммы исходящего пакета, отдает один байт пакета [data].
/// Алгоритм суммирует все юникод char и считает модуль по байту
int calcHashSum(String data) {
  var sum = 0;
  for (final char in data.codeUnits) {
    sum += char;
  }
  return sum % 256;
}