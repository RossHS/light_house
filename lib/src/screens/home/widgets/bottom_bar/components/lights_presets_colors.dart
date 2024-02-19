import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/my_colors_controller.dart';
import 'package:light_house/src/controllers/core/rgb_controller.dart';
import 'package:light_house/src/widgets/selectable_circle_color.dart';

const _presetColors = [
  Colors.red,
  Colors.blue,
  Colors.amber,
];

/// Виджет предустановленных цветов, так-же в него можно сохранять и другие цвета,
/// к примеру - сохранять текущий
class LightsPresetsColors extends StatelessWidget {
  const LightsPresetsColors({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Observer(
          builder: (context) {
            final rgbController = GetIt.I<RGBController>();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Цвета',
                  style: textTheme.headlineSmall,
                ),
                Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: _presetColors
                      .map<Widget>(
                        (e) => SelectableCircleColor(
                          color: e,
                          isSelected: rgbController.color == e,
                          onTap: () {
                            if (rgbController.color != e) {
                              rgbController.color = e;
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Мои цвета',
                  style: textTheme.headlineSmall,
                ),
                Observer(
                  builder: (context) {
                    final myColorsController = GetIt.I<MyColorsController>();
                    return myColorsController.myColors.map(
                      value: (value) => Wrap(
                        runSpacing: 8,
                        spacing: 8,
                        children: value.value
                                ?.map(
                                  (e) => SelectableCircleColor(
                                    key: ValueKey(e),
                                    color: e,
                                    isSelected: rgbController.color == e,
                                    onDoubleTap: () {
                                      myColorsController.deleteColor(e);
                                    },
                                    onTap: () {
                                      if (rgbController.color != e) {
                                        rgbController.color = e;
                                      }
                                    },
                                  ),
                                )
                                .toList() ??
                            [],
                      ),
                      error: (error) => const SizedBox(),
                      loading: (loading) => const SizedBox(),
                    );
                  },
                ),
                IconButton(
                    onPressed: () => GetIt.I<MyColorsController>().saveColor(rgbController.color),
                    icon: const Icon(Icons.add)),
              ],
            );
          },
        ),
      ),
    );
  }
}
