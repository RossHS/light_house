import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:light_house/src/utils/color_names/color_names.dart';

/// Unit тест с проверкой метода [ColorNames.search], данный метод ищем названия цвета по его символьному коду
void main() {
  group('Color names - find', () {
    void shortHand(String desc, Color color, String matcher) {
      test(desc, () {
        expect(ColorNames.search(color), matcher);
      });
    }

    shortHand('search for a matching color - Алый', const Color(0xFFFF2400), 'Алый');
    shortHand('search for a matching color - Алый', const Color(0xFFFF2401), 'Алый');
    shortHand('search for a matching color - Мятно-бирюзовый', const Color(0xFF58897D), 'Мятно-бирюзовый');
    shortHand('search for a matching color - Бирюзово-зеленый', const Color(0xFF0A5240), 'Бирюзово-зеленый');
    shortHand('search for a matching color - Слоновая кость', const Color(0xFFFFFFF1), 'Слоновая кость');
    shortHand('search for a matching color - Бирюзовый', const Color(0xFF31E3B8), 'Бирюзовый');
    shortHand('search for a matching color - Яркий красно-пурпурный', const Color(0xFF7F1A51), 'Яркий красно-пурпурный');
  });
}
