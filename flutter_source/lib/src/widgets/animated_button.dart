import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Обычная анимированная кнопка, которая используется чаще всего в приложении
class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    this.onPressed,
    this.color,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Color? color;
  final Widget child;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin, _AnimatedButtonStateMixin {

  bool get _isSelected => widget.onPressed != null;

  @override
  Widget get _child => widget.child;

  @override
  Color? get _color => widget.color;

  @override
  VoidCallback? get _onPressed => widget.onPressed;

  @override
  void initState() {
    super.initState();
    // Если кнопку нажать нельзя, то и анимацию изначально мы можем увести в состояние "нажатости"
    if (!_isSelected) _animationController.value = 1;
  }

  @override
  void didUpdateWidget(covariant AnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Подводим текущую анимацию по состоянию доступности нажатия кнопки
    if (oldWidget.onPressed == null && _isSelected) {
      _animationController.reverse();
    } else if (oldWidget.onPressed != null && !_isSelected) {
      _animationController.forward();
    }
  }

  /// Перехватчик нажатия на виджет, который запускает анимацию "смещения" виджета при нажатии
  @override
  void _onTapDown(TapDownDetails _) {
    _animationController.forward();
  }

  /// При отпускании кнопки на экране запускает в обратную сторону анимацию нажатия
  @override
  void _onTapUp() {
    _animationController.reverse();
  }
}

/// Toggle кнопка, визуально клон [AnimatedButton] с той лишь разнице, что это переключатель
class ToggleAnimatedButton extends StatefulWidget {
  const ToggleAnimatedButton({
    super.key,
    required this.isSelected,
    required this.onPressed,
    this.color,
    required this.child,
  });

  final bool isSelected;
  final Function(bool isSelected) onPressed;
  final Color? color;
  final Widget child;

  @override
  State<ToggleAnimatedButton> createState() => _State();
}

class _State extends State<ToggleAnimatedButton> with SingleTickerProviderStateMixin, _AnimatedButtonStateMixin {
  @override
  Widget get _child => widget.child;

  @override
  Color? get _color => widget.color;

  bool get _isSelected => widget.isSelected;

  @override
  VoidCallback? get _onPressed {
    return () => widget.onPressed(!_isSelected);
  }

  @override
  void initState() {
    super.initState();
    _animationController.value = _isSelected ? 1 : 0;
  }

  @override
  void didUpdateWidget(covariant ToggleAnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Подводим под состояние - нажата кнопка или нет
    if (oldWidget.isSelected != widget.isSelected) {
      widget.isSelected ? _animationController.forward() : _animationController.reverse();
    }
  }
}

//------------------------mixin----------------//
/// Примесь для кнопок, решил пойти таким путем, дабы попробовать что-то новое для себя
/// и не дублировать код в [AnimatedButton] и [ToggleAnimatedButton]
mixin _AnimatedButtonStateMixin<T extends StatefulWidget> on State<T>, SingleTickerProviderStateMixin<T> {
  late final AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  Color? get _color;

  VoidCallback? get _onPressed;

  Widget get _child;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-5, -5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final color = _color ?? theme.colorScheme.surface;
    return RepaintBoundary(
      child: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium!,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.onSurface,
          ),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: _offsetAnimation.value,
                child: child,
              );
            },
            child: GestureDetector(
              onTap: _onPressed,
              onTapCancel: _onTapUp,
              onTapDown: _onPressed != null ? _onTapDown : null,
              onTapUp: (_) => _onPressed != null ? _onTapUp() : null,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: theme.colorScheme.onSurface,
                    width: 0.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Перехватчик нажатия на виджет, который запускает анимацию "смещения" виджета при нажатии
  void _onTapDown(TapDownDetails _) {}

  /// При отпускании кнопки на экране запускает в обратную сторону анимацию нажатия
  void _onTapUp() {}
}

//---------------------Widgetbook-----------------//
@widgetbook.UseCase(name: 'AnimatedButton use case', type: AnimatedButton)
Widget animatedButtonUseCase(BuildContext context) {
  final color = context.knobs.colorOrNull(label: 'Close Color');
  return Center(
    child: _AnimatedButtonTest(
      buttonColor: color,
    ),
  );
}

/// Вспомогательный виджет для [Widgetbook], тут мы просто проверяем поведение [AnimatedButton]
class _AnimatedButtonTest extends StatefulWidget {
  const _AnimatedButtonTest({required this.buttonColor});

  final Color? buttonColor;

  @override
  State<_AnimatedButtonTest> createState() => _AnimatedButtonTestState();
}

class _AnimatedButtonTestState extends State<_AnimatedButtonTest> {
  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedButton(
          onPressed: () {
            // ignore: avoid_print
            print('onPressed');
          },
          color: widget.buttonColor,
          child: const Text('regular button'),
        ),
        const SizedBox(height: 20),
        AnimatedButton(
          color: widget.buttonColor,
          child: const Text('disabled button'),
        ),
        const SizedBox(height: 20),
        ToggleAnimatedButton(
          isSelected: isSelected,
          onPressed: (value) {
            // ignore: avoid_print
            print('current toggle state - $value');
            setState(() => isSelected = value);
          },
          color: widget.buttonColor,
          child: const Text('Toggle button'),
        ),
      ],
    );
  }
}