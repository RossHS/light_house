import 'package:flutter/material.dart';
import 'package:light_house/src/widgets/glass_box.dart';

/// Элемент ошибки, может быть как кнопкой, так и обычной плашкой с информацией
class ErrorForList extends StatefulWidget {
  const ErrorForList({
    super.key,
    required this.text,
    this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  State<ErrorForList> createState() => _ErrorForListState();
}

class _ErrorForListState extends State<ErrorForList> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(covariant ErrorForList oldWidget) {
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
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
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
            child: GlassBox(
              glassColor: colorScheme.error,
              opacity: 1,
              boxBorderSides: const BoxBorderSides.all(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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

