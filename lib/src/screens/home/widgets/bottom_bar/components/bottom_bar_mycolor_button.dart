import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/bottom_custom_popup_button.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/components/lights_presets_colors.dart';
import 'package:light_house/src/widgets/object_fly_animation.dart';
import 'package:light_house/src/widgets/shake_jump_animation.dart';

class BottomBarMyColorsButton extends StatefulWidget {
  const BottomBarMyColorsButton({super.key});

  @override
  State<BottomBarMyColorsButton> createState() => _BottomBarMyColorsButtonState();
}

class _BottomBarMyColorsButtonState extends State<BottomBarMyColorsButton> {
  final _shakeJumpController = ShakeJumpController();
  late final ObjectFlyingNotifier _flyingNotifier;

  @override
  void initState() {
    super.initState();
    _flyingNotifier = ObjectFlyAnimation.notifier(context);
    // Слушаем окончание анимации, когда она закончилась - "дергаем" иконку
    _flyingNotifier.addListener(_flyingListener);
  }

  @override
  void dispose() {
    _flyingNotifier.removeListener(_flyingListener);
    _shakeJumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShakeJumpAnimation(
      controller: _shakeJumpController,
      child: const BottomCustomPopupButton(
        menuWidget: LightsPresetsColors(),
        iconWidget: Icon(Icons.favorite),
      ),
    );
  }

  void _flyingListener() {
    if (_flyingNotifier.value == ObjectFlyingStates.ended) {
      HapticFeedback.heavyImpact();
      _shakeJumpController.jump();
    }
  }
}
