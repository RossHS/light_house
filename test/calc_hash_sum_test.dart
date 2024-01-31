import 'package:flutter_test/flutter_test.dart';
import 'package:light_house/utils.dart';

/// Юнит тест контрольной суммы
void main() {
  test('Check hash sum calc algorithm - 0', () => expect(calcHashSum('0'), 0x30));
  test('Check hash sum calc algorithm - 00ff00', () => expect(calcHashSum('00ff00'), 0x8c));
  test('Check hash sum calc algorithm - 0000ff', () => expect(calcHashSum('0000ff'), 0x8c));
  test('Check hash sum calc algorithm - ff00ff', () => expect(calcHashSum('ff00ff'), 0xf8));
  test('Check hash sum calc algorithm - abcd', () => expect(calcHashSum('abcd'), 0x8a));
  test('Check hash sum calc algorithm - abcd@12G', () => expect(calcHashSum('abcd@12G'), 0x74));
  test('Check hash sum calc algorithm - abcd@12Gasdfcvfge1234', () => expect(calcHashSum('abcd@12Gasdfcvfge1234'), 0xe7));
}
