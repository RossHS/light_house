import 'package:flutter_test/flutter_test.dart';
import 'package:light_house/src/models/data_headers.dart';
import 'package:light_house/src/utils/utils.dart';

/// Юнит тест контрольной суммы
void main() {
  test('Check hash sum calc algorithm - 0', () => expect(calcHashSum('0'), 0x30));
  test('Check hash sum calc algorithm - ff', () => expect(calcHashSum('ff'), 204));
  test('Check hash sum calc algorithm - 11', () => expect(String.fromCharCode(calcHashSum('11')), 'b'));
  test('Check hash sum calc algorithm - 123456', () => expect(String.fromCharCode(calcHashSum('123456')), '5'));
  test('Check hash sum calc algorithm - 00ff00', () => expect(calcHashSum('00ff00'), 0x8C));
  test('Check hash sum calc algorithm - 0000ff', () => expect(calcHashSum('0000ff'), 0x8C));
  test('Check hash sum calc algorithm - ff00ff', () => expect(calcHashSum('ff00ff'), 0xF8));
  test('Check hash sum calc algorithm - ffffff', () => expect(calcHashSum('ffffff'), 0x64));
  test('Check hash sum calc algorithm with header', () => expect(calcHashSum('${DataHeader.c.name}c80000'), 190));
}
