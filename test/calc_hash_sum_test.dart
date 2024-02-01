import 'package:flutter_test/flutter_test.dart';
import 'package:light_house/utils.dart';

/// Юнит тест контрольной суммы
void main() {
  test('Check hash sum calc algorithm - 0', () => expect(calcHashSum([0x30]), 0x30));
  test('Check hash sum calc algorithm - 0xff', () => expect(calcHashSum([0xff]), 0xff));
  test('Check hash sum calc algorithm - 0x0', () => expect(calcHashSum([0x0]), 0x00));
  test('Check hash sum calc algorithm - 0x00ff00', () => expect(calcHashSum([0x00, 0xff, 0x00]), 0xff));
  test('Check hash sum calc algorithm - 0x0000ff', () => expect(calcHashSum([0x00, 0x00, 0xff]), 0xff));
  test('Check hash sum calc algorithm - 0xff00ff', () => expect(calcHashSum([0xff, 0x00, 0xff]), 0xfe));
  test('Check hash sum calc algorithm - 0xffffff', () => expect(calcHashSum([0xff, 0xff, 0xff]), 0xfd));
}
