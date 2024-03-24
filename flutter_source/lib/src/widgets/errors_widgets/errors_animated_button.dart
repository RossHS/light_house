import 'package:flutter/material.dart';

/// Элемент ошибки в виде кнопки
class ErrorsAnimatedButton extends StatefulWidget {
  const ErrorsAnimatedButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<ErrorsAnimatedButton> createState() => _ErrorsAnimatedButtonState();
}

class _ErrorsAnimatedButtonState extends State<ErrorsAnimatedButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  bool get _isSelectable => widget.onPressed != null;

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
    // Если кнопку нажать нельзя, то и анимацию изначально мы можем увести в состояние "нажатости"
    if (!_isSelectable) _animationController.value = 1;
  }

  @override
  void didUpdateWidget(covariant ErrorsAnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Подводим текущую анимацию по состоянию доступности нажатия кнопки
    if (oldWidget.onPressed == null && _isSelectable) {
      _animationController.reverse();
    } else if (oldWidget.onPressed != null && !_isSelectable) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RepaintBoundary(
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
            onTap: widget.onPressed,
            onTapCancel: _onTapUp,
            onTapDown: widget.onPressed != null ? _onTapDown : null,
            onTapUp: (_) => widget.onPressed != null ? _onTapUp() : null,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  /// Перехватчик нажатия на виджет, который запускает анимацию "смещения" виджета при нажатии
  void _onTapDown(TapDownDetails _) {
    _animationController.forward();
  }

  /// При отпускании кнопки на экране запускает в обратную сторону анимацию нажатия
  void _onTapUp() {
    _animationController.reverse();
  }
}
