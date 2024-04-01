import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/my_colors_controller.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/widgets/object_fly_animation.dart';
import 'package:light_house/src/widgets/shake_jump_animation.dart';

/// Кнопка сохранения цвета
class MyColorsSaverButton extends StatefulWidget {
  const MyColorsSaverButton({super.key});

  @override
  State<MyColorsSaverButton> createState() => _MyColorsSaverButtonState();
}

class _MyColorsSaverButtonState extends State<MyColorsSaverButton> {
  final GlobalKey _sourceKey = GlobalKey(debugLabel: 'flying_animation_source_key');
  final _shakeJumpController = ShakeJumpController();
  late final ObjectFlyingNotifier _flyingNotifier;

  /// Цвет, который мы планируем сохранять
  Color? _colorForSave;

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

    return ShakeJumpAnimation(
      key: _sourceKey,
      controller: _shakeJumpController,
      child: Builder(
        builder: (context) {
          return TextButton.icon(
            onPressed: () => _onTap(colorController.color),
            icon: const Icon(Icons.save),
            label: const Text('Сохранить'),
          );
        },
      ),
    );
  }

  void _flyingListener() {
    if (_flyingNotifier.value == ObjectFlyingStates.ended && _colorForSave != null) {
      GetIt.I<MyColorsController>().saveColor(_colorForSave!);
      _colorForSave = null;
    }
  }

  Future<void> _onTap(Color color) async {
    final myColorsController = GetIt.I<MyColorsController>();

    final flyingState = _flyingNotifier.value;
    HapticFeedback.heavyImpact();

    if (flyingState == ObjectFlyingStates.started || await myColorsController.contains(color)) {
      _shakeJumpController.shake();
    } else {
      if (!mounted) return;
      _colorForSave = color;
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
