/// Алгоритм расчетной хэш суммы исходящего пакета, отдает один байт пакета [data].
/// Так как dart не поддерживает uint8 и прочих типов, то используем обычный int
int calcHashSum(List<int> data) {
  var sum = 0;
  for (final value in data) {
    assert(value >= 0 && value <= 255, 'must be uint8, but value == $value');
    sum += value;
  }
  return sum % 256;
}
