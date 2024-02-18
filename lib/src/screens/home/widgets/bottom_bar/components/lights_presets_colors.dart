import 'package:flutter/material.dart';

/// Виджет предустановленных цветов, так-же в него можно сохранять и другие цвета,
/// к примеру - сохранять текущий
class LightsPresetsColors extends StatelessWidget {
  const LightsPresetsColors({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [TextButton(onPressed: () {}, child: Text('Сохранить текущий цвет!'))],
    );
  }
}
