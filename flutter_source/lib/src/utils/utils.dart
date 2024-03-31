import 'dart:math' as math;

/// Алгоритм расчетной хэш суммы исходящего пакета, отдает один байт пакета [data].
/// Так как dart не поддерживает uint8 и прочих типов, то используем обычный int
int calcHashSum(String data) {
  var sum = 0;
  for (final value in data.codeUnits) {
    sum += value;
  }
  return sum % 256;
}

double degreesToRadians(double deg) => deg * (math.pi / 180.0);
