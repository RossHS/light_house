import 'package:flutter_test/flutter_test.dart';
import 'package:light_house/src/utils/extensions.dart';

/// Юнит тест расширений
void main() {
  group('IntExt.uint8HexFormat', () {
    test('test 0', () => expect(0.uint8HexFormat, '00'));
    test('test 255', () => expect(255.uint8HexFormat, 'ff'));
    test('test 100', () => expect(100.uint8HexFormat, '64'));
    test('error overflow -1', () => expect(() => (-1).uint8HexFormat, throwsAssertionError));
    test('error overflow 2222', () => expect(() => 2222.uint8HexFormat, throwsAssertionError));
  });
  group('IntExt.uint24HexFormat', () {
    test('test 0', () => expect(0.uint24HexFormat, '000000'));
    test('test 100', () => expect(100.uint24HexFormat, '000064'));
    test('test 16777215', () => expect(16777215.uint24HexFormat, 'ffffff'));
    test('error overflow -1', () => expect(() => (-1).uint24HexFormat, throwsAssertionError));
    test('error overflow 167772152323', () => expect(() => 167772152323.uint24HexFormat, throwsAssertionError));
  });
}
