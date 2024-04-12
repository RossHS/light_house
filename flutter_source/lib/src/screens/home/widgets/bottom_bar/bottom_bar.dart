import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/screens/home/home_screen.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/bottom_bar_components.dart';
import 'package:light_house/src/screens/play_mode/play_mode_modal.dart';
import 'package:light_house/src/widgets/custom_hero.dart';
import 'package:light_house/src/widgets/glass_box.dart';
import 'package:light_house/src/widgets/play_mode_indicator_widget.dart';

/// Нижний бар с элементами управления на главном экране
class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      boxBorderSides: const BoxBorderSides(top: true),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 50,
            child: NavigationToolbar(
              centerMiddle: true,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BottomCustomPopupButton(
                    menuWidget: Settings(),
                    iconWidget: Icon(Icons.settings),
                  ),
                  BottomBarMyColorsButton(key: flyingDestKey),
                ],
              ),
              middle: const BottomBarMiddleButton(),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppThemeChangeButton(),
                  Observer(
                    builder: (context) {
                      final rgbController = GetIt.I<RGBController>();
                      final playModeController = GetIt.I<PlayModeController>();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            // Т.к. нам нужна поддержка [Hero] перехода прописываем
                            // свой переход для маршрута
                            PageRouteBuilder(
                              opaque: false,
                              barrierDismissible: true,
                              maintainState: false,
                              barrierColor: Colors.black45,
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  FadeTransition(opacity: animation, child: const PlayModeModal()),
                            ),
                          );
                        },
                        child: CustomHero(
                          tag: playModeController.playMode.modeName,
                          child: PlayModeIndicatorWidget(
                            color: rgbController.color,
                            playMode: playModeController.playMode,
                          ),
                        ),
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
