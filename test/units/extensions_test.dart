import 'package:flutter_test/flutter_test.dart';
import 'package:light_house/src/utils/extension.dart';

/// Юнит тест расширений
void main() {
  group('IntExt.uint8HexFormat', () {
    test('test 0', () => expect(0.uint8HexFormat, '00'));
    test('test 255', () => expect(255.uint8HexFormat, 'ff'));
    test('test 100', () => expect(100.uint8HexFormat, '64'));
  });
}
