import 'dart:ui';

import 'package:light_house/src/utils/color_names/src/color_names_values.dart';

/// Утилитарный класс с поисков названия цвета, т.е. мы ему передаем [Color],
/// а получаем [String] с названием и ближайший цвет [Color]
class ColorNames {
  ColorNames._();

  static ({String colorName, Color closestColor}) search(Color color) {
    final inputColorVal = color.value;
    if (colorNamesMap.containsKey(inputColorVal)) {
      return (
        colorName: colorNamesMap[inputColorVal]!,
        closestColor: color,
      );
    }

    // Начальное значение для минимальной разницы устанавливаем очень большим,
    // чтобы первое сравнение его точно перезаписало
    var minDifference = 0xFFFFFFFF;
    var closestColor = inputColorVal;

    colorNamesMap.forEach((key, value) {
      // Вычисляем разницу по цветам
      var r = (((0x00ff0000 & key) >> 16) - color.red).abs();
      var g = (((0x0000ff00 & key) >> 8) - color.green).abs();
      var b = (((0x000000ff & key) >> 0) - color.blue).abs();
      // Сумма разброса по всем цветам
      final currentDif = r + g + b;
      // Если найденная разница меньше текущего минимума, обновляем минимум и сохраняем текущий ключ
      if (currentDif < minDifference) {
        minDifference = currentDif;
        closestColor = key;
      }
    });
    return (
      colorName: colorNamesMap[closestColor]!,
      closestColor: Color(closestColor),
    );
  }
}
