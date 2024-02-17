import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/brightness_controller.dart';
import 'package:light_house/src/controllers/rgb_controller.dart';
import 'package:light_house/src/widgets/brightness_indicator.dart';
import 'package:light_house/src/widgets/custom_popup_menu.dart';
import 'package:light_house/src/widgets/glass_box.dart';
import 'package:light_house/src/widgets/light_bubble.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Observer(
          builder: (context) {
            final color = GetIt.I<RGBController>().color;
            final brightness = GetIt.I<BrightnessController>().brightness;
            return SizedBox(
              height: 30,
              child: NavigationToolbar(
                centerMiddle: true,
                leading: CustomPopupMenu(
                  menuBuilder: () {
                    return Container(
                      color: Colors.green,
                      width: 100,
                      height: 200,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BrightnessIndicator(brightness: brightness),
                    ],
                  ),
                ),
                middle: LightBubble(
                  radius: 20,
                  color: color,
                  brightness: brightness,
                ),
                trailing: CustomPopupMenu(
                  menuBuilder: () {
                    return ElevatedButton(
                      onPressed: (){},
                      child: Text('pepega'),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BrightnessIndicator(brightness: brightness),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
