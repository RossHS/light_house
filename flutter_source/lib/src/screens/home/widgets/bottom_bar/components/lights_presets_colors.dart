import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/my_colors_controller.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/utils/extensions.dart';
import 'package:light_house/src/widgets/delete_item_widget.dart';
import 'package:light_house/src/widgets/rotation_switch_widget.dart';
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
    final contentSize = MediaQuery.of(context).size / 1.5;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: contentSize.width,
        maxWidth: contentSize.width,
        maxHeight: contentSize.height,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Цвета',
              style: textTheme.headlineSmall,
            ),
            Observer(
              builder: (context) {
                final rgbController = GetIt.I<RGBController>();
                return Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: _presetColors
                      .map<Widget>(
                        (e) => SelectableCircleColor(
                          color: e,
                          isSelected: rgbController.color.value == e.value,
                          onTap: () {
                            if (rgbController.color != e) {
                              rgbController.color = e;
                            }
                          },
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Мои цвета',
              style: textTheme.headlineSmall,
            ),
            const _MySavedColors(),
          ],
        ),
      ),
    );
  }
}

/// Виджет моих сохраненных цветов, если [delete] - true, то тогда при нажатии,
/// мы можем удалять виджет, если [delete] - false, то нажатие выбирает цвет
class _MySavedColors extends StatefulWidget {
  const _MySavedColors();

  @override
  State<_MySavedColors> createState() => _MySavedColorsState();
}

class _MySavedColorsState extends State<_MySavedColors> {
  var _delete = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Observer(
      builder: (context) {
        final rgbController = GetIt.I<RGBController>();
        final myColorsController = GetIt.I<MyColorsController>();
        final myColors = myColorsController.myColors.value ?? {};
        if (myColors.isEmpty) {
          return Text(
            'Пока тут пусто',
            style: textTheme.bodyMedium,
          );
        }
        return Wrap(
          runSpacing: 8,
          spacing: 8,
          children: [
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkResponse(
                onTap: () => setState(() => _delete = !_delete),
                child: SizedBox.square(
                  dimension: 35,
                  child: RotationSwitchWidget(
                    child: _delete
                        ? Icon(key: ValueKey(_delete), Icons.close)
                        : Icon(key: ValueKey(_delete), Icons.delete),
                  ),
                ),
              ),
            ),
            ...myColors.map(
              (e) => DeleteItemWidget(
                delete: _delete,
                closeColor: e.calcOppositeColor,
                child: SelectableCircleColor(
                  key: ValueKey(e),
                  color: e,
                  isSelected: rgbController.color.value == e.value && !_delete,
                  onTap: () {
                    // В зависимости от режима, мы выбираем, удаление или включение цвета
                    if (!_delete) {
                      if (rgbController.color.value != e.value) {
                        rgbController.color = e;
                      }
                    } else {
                      myColorsController.deleteColor(e);
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
