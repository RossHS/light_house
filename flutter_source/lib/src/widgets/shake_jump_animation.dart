import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:light_house/src/widgets/widgetbook_def_frame.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Передаваемая анимация
enum ShakeJumpStates {
  unknown,
  shake,
  jump,
}

/// Контроллер, через который мы можем запускать анимации в [ShakeJumpAnimation]
class ShakeJumpController extends ChangeNotifier {
  var _state = ShakeJumpStates.unknown;

  void jump() {
    _state = ShakeJumpStates.jump;
    notifyListeners();
  }

  void shake() {
    _state = ShakeJumpStates.shake;
    notifyListeners();
  }
}

/// Виджет, который при помощи внешнего управления запускает анимацию
/// "прыжка" или "тряски" для предоставляемого [child]
class ShakeJumpAnimation extends StatefulWidget {
  const ShakeJumpAnimation({
    super.key,
    required this.controller,
    required this.child,
  });

  final ShakeJumpController controller;
  final Widget child;

  @override
  State<ShakeJumpAnimation> createState() => _ShakeJumpAnimationState();
}

class _ShakeJumpAnimationState extends State<ShakeJumpAnimation> with TickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final AnimationController _jumpController;
  late final Animation<double> _shakeAnimation;
  late final Animation<double> _jumpAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _jumpController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    // Т.к. анимация циклична, то по ее окончанию мы сбрасываем значение
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
    _jumpController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _jumpController.reset();
      }
    });

    _shakeAnimation = CurvedAnimation(parent: _shakeController, curve: Curves.easeInOutCubic);
    _jumpAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.4), weight: 0.25),
      TweenSequenceItem(tween: Tween<double>(begin: 0.4, end: 1.7), weight: 0.25),
      TweenSequenceItem(tween: Tween<double>(begin: 1.7, end: 1.0), weight: 0.5),
    ]).animate(
      CurvedAnimation(parent: _jumpController, curve: Curves.linear),
    );

    widget.controller.addListener(_triggerAnimation);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ShakeJumpAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_triggerAnimation);
      widget.controller.addListener(_triggerAnimation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          final sineValue = math.sin(2 * 2 * math.pi * _shakeAnimation.value);
          return Transform.translate(
            offset: Offset(sineValue * 5, 0),
            child: child!,
          );
        },
        child: ScaleTransition(
          scale: _jumpAnimation,
          child: widget.child,
        ),
      ),
    );
  }

  /// Слушатель изменения состояния, именно здесь происходит запуск анимаций
  void _triggerAnimation() {
    switch (widget.controller._state) {
      case ShakeJumpStates.shake:
        _shakeController.forward();
        break;
      case ShakeJumpStates.jump:
        _jumpController.forward();
        break;
      default:
        break;
    }
  }
}

//-------------------Widgetbook------------------//
@widgetbook.UseCase(name: 'ShakeJumpAnimation use case', type: ShakeJumpAnimation)
Widget shakeJumpAnimationUseCase(BuildContext context) {
  return const WidgetbookDefFrame(child: _ShakeJumpAnimationTest());
}

/// Вспомогательный виджет для [Widgetbook], тут мы просто проверяем поведение [ShakeJumpAnimation]
class _ShakeJumpAnimationTest extends StatefulWidget {
  const _ShakeJumpAnimationTest();

  @override
  State<_ShakeJumpAnimationTest> createState() => _ShakeJumpAnimationTestState();
}

class _ShakeJumpAnimationTestState extends State<_ShakeJumpAnimationTest> {
  final controller = ShakeJumpController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShakeJumpAnimation(
          controller: controller,
          child: const Icon(Icons.play_circle),
        ),
        const SizedBox(height: 20),
        RepaintBoundary(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: controller.shake,
                child: const Text('Shake'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: controller.jump,
                child: const Text('Jump'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
