import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/bottom_bar_components.dart';
import 'package:light_house/src/widgets/custom_popup_menu.dart';
import 'package:light_house/src/widgets/light_bubble.dart';

/// Центральная кнопка на панели [BottomBar]. Нажатие на нее сохраняет
/// текущий цвет в сохраненное
class BottomBarMiddleButton extends StatefulWidget {
  const BottomBarMiddleButton({super.key});

  @override
  State<BottomBarMiddleButton> createState() => _BottomBarMiddleButtonState();
}

class _BottomBarMiddleButtonState extends State<BottomBarMiddleButton> {
  final _customPopupController = CustomPopupMenuController();

  @override
  void dispose() {
    _customPopupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorController = GetIt.I<RGBController>();
    final brightnessController = GetIt.I<BrightnessController>();

    return CustomPopupMenu(
      controller: _customPopupController,
      menuBuilder: () {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: const LightHue(),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Observer(
          builder: (context) {
            final color = colorController.color;
            final brightness = brightnessController.brightness;
            return GestureDetector(
              onTap: _onTap,
              child: LightBubble(
                radius: 50,
                color: color,
                brightness: brightness,
              ),
            );
          },
        ),
      ),
    );
  }

  void _onTap() {
    HapticFeedback.heavyImpact();
    _customPopupController.showMenu();
  }
}
