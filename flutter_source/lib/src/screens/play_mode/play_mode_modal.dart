import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/models/play_mode_models.dart';
import 'package:light_house/src/widgets/custom_hero.dart';
import 'package:light_house/src/widgets/play_mode_indicator_widget.dart';

class PlayModeModal extends StatelessWidget {
  const PlayModeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final rgbController = GetIt.I<RGBController>();
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  GetIt.I<PlayModeController>().playMode = const DisabledPlayMode();
                },
                child: Card(
                  child: CustomHero(
                    tag: const DisabledPlayMode().modeName,
                    child: PlayModeIndicatorWidget(
                      color: rgbController.color,
                      playMode: const DisabledPlayMode(),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  GetIt.I<PlayModeController>().playMode = const BrightnessPlayMode();
                },
                child: Card(
                  child: CustomHero(
                    tag: const BrightnessPlayMode().modeName,
                    child: PlayModeIndicatorWidget(
                      color: rgbController.color,
                      playMode: const BrightnessPlayMode(),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  GetIt.I<PlayModeController>().playMode = const ChangeColorPlayMode();
                },
                child: Card(
                  child: CustomHero(
                    tag: const ChangeColorPlayMode().modeName,
                    child: PlayModeIndicatorWidget(
                      color: rgbController.color,
                      playMode: const ChangeColorPlayMode(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
