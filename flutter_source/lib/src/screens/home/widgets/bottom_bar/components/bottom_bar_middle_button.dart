import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/my_colors_controller.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/widgets/light_bubble.dart';
import 'package:light_house/src/widgets/object_fly_animation.dart';
import 'package:light_house/src/widgets/shake_jump_animation.dart';

/// Центральная кнопка на панели [BottomBar]. Нажатие на нее сохраняет
/// текущий цвет в сохраненное
class BottomBarMiddleButton extends StatefulWidget {
  const BottomBarMiddleButton({super.key});

  @override
  State<BottomBarMiddleButton> createState() => _BottomBarMiddleButtonState();
}

class _BottomBarMiddleButtonState extends State<BottomBarMiddleButton> {
  final GlobalKey _sourceKey = GlobalKey(debugLabel: 'flying_animation_source_key');
  final _shakeJumpController = ShakeJumpController();
  late final ObjectFlyingNotifier _flyingNotifier;

  /// Цвет, который мы планируем сохранять
  Color? colorForSave;

  @override
  void initState() {
    super.initState();
    _flyingNotifier = ObjectFlyAnimation.notifier(context);
    // Слушаем окончание анимации, когда она закончилась,
    // можем добавлять цвет в сохраненные
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
    final colorController = GetIt.I<RGBController>();
    final brightnessController = GetIt.I<BrightnessController>();
    final myColorsController = GetIt.I<MyColorsController>();

    return Padding(
      key: _sourceKey,
      padding: const EdgeInsets.all(8.0),
      child: ShakeJumpAnimation(
        controller: _shakeJumpController,
        child: Observer(
          builder: (context) {
            final color = colorController.color;
            final brightness = brightnessController.brightness;
            return GestureDetector(
              onTap: () => onTap(color, myColorsController),
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

  void _flyingListener() {
    if (_flyingNotifier.value == ObjectFlyingStates.ended && colorForSave != null) {
      GetIt.I<MyColorsController>().saveColor(colorForSave!);
      colorForSave = null;
    }
  }

  Future<void> onTap(Color color, MyColorsController myColorsController) async {
    final flyingState = _flyingNotifier.value;
    HapticFeedback.heavyImpact();

    if (flyingState == ObjectFlyingStates.started || await myColorsController.contains(color)) {
      _shakeJumpController.shake();
    } else {
      if (!mounted) return;
      colorForSave = color;
      ObjectFlyAnimation.of(context).startFlyAnimation(
        sourceWidget: _sourceKey,
        flyingWidget: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(width: 0.5),
          ),
          child: const SizedBox.square(dimension: 30),
        ),
      );
      _shakeJumpController.jump();
    }
  }
}
