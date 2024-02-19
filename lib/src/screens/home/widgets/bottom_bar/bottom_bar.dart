import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/core/brightness_controller.dart';
import 'package:light_house/src/controllers/core/play_mode_controller.dart';
import 'package:light_house/src/controllers/core/rgb_controller.dart';
import 'package:light_house/src/models/play_mode_models.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/bottom_custom_popup_button.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/light_hue.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/light_sliders.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/lights_presets_colors.dart';
import 'package:light_house/src/widgets/glass_box.dart';
import 'package:light_house/src/widgets/light_bubble.dart';

/// Нижний бар с элементами управления на главном экране
class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 50,
          child: NavigationToolbar(
            centerMiddle: true,
            leading: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomCustomPopupButton(
                  menuWidget: LightSliders(),
                  iconWidget: Icon(Icons.lightbulb),
                ),
                BottomCustomPopupButton(
                  menuWidget: LightHue(),
                  iconWidget: Icon(Icons.change_circle_rounded),
                ),
                BottomCustomPopupButton(
                  menuWidget: LightsPresetsColors(),
                  iconWidget: Icon(Icons.color_lens),
                ),
              ],
            ),
            middle: Observer(
              builder: (context) {
                final color = GetIt.I<RGBController>().color;
                final brightness = GetIt.I<BrightnessController>().brightness;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LightBubble(
                    radius: 50,
                    color: color,
                    brightness: brightness,
                  ),
                );
              },
            ),
            trailing: Observer(
              builder: (context) {
                final playModeController = GetIt.I<PlayModeController>();
                return DropdownButton<PlayModeBase>(
                  value: playModeController.playMode,
                  items: const [
                    DropdownMenuItem<PlayModeBase>(
                      value: DisabledPlayMode(),
                      child: Text('Отключен'),
                    ),
                    DropdownMenuItem<PlayModeBase>(
                      value: BrightnessPlayMode(),
                      child: Text('Плавная яркость'),
                    ),
                    DropdownMenuItem<PlayModeBase>(
                      value: ChangeColorPlayMode(),
                      child: Text('Плавный цвет'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) playModeController.playMode = value;
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
