import 'dart:ui';

import 'package:light_house/src/utils/color_names/color_names.dart';

/// Расширение класса [Color], для удобного поиска названий
extension ColorNamesExt on Color {
  ({String colorName, Color closestColor}) get getColorName => ColorNames.search(this);
}
