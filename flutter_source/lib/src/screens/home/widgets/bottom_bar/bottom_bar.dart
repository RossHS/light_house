import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/models/play_mode_models.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/app_theme_change_button.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/bottom_bar_middle_button.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/bottom_bar_mycolor_button.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/bottom_custom_popup_button.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/light_hue.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/light_sliders.dart';
import 'package:light_house/src/widgets/glass_box.dart';
import 'package:light_house/src/widgets/object_fly_animation.dart';

/// Нижний бар с элементами управления на главном экране
class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final GlobalKey _destKey = GlobalKey(debugLabel: 'flying_animation_dest_key');

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 50,
          child: ObjectFlyAnimation(
            destinationGlobalKey: _destKey,
            child: NavigationToolbar(
              centerMiddle: true,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BottomCustomPopupButton(
                    menuWidget: LightSliders(),
                    iconWidget: Icon(Icons.lightbulb),
                  ),
                  const BottomCustomPopupButton(
                    menuWidget: LightHue(),
                    iconWidget: Icon(Icons.palette),
                  ),
                  BottomBarMyColorsButton(key: _destKey),
                ],
              ),
              middle: const BottomBarMiddleButton(),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppThemeChangeButton(),
                  Observer(
                    builder: (context) {
                      final playModeController = GetIt.I<PlayModeController>();
                      return DropdownButton<PlayModeBase>(
                        value: playModeController.playMode,
                        items: const [
                          DropdownMenuItem<PlayModeBase>(
                            value: DisabledPlayMode(),
                            child: Text('Off'),
                          ),
                          DropdownMenuItem<PlayModeBase>(
                            value: BrightnessPlayMode(),
                            child: Text('B'),
                          ),
                          DropdownMenuItem<PlayModeBase>(
                            value: ChangeColorPlayMode(),
                            child: Text('C'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) playModeController.playMode = value;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}