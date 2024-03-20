import 'package:flutter/material.dart';
import 'package:light_house/src/widgets/glass_box.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

class ErrorsAnimatedList extends StatelessWidget {
  const ErrorsAnimatedList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

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

//---------------------Widgetbook----------------------//
@widgetbook.UseCase(name: 'ErrorForList use case', type: ErrorForList)
Widget errorForListUseCase(BuildContext context) {
  final text = context.knobs.string(label: 'text', initialValue: 'default error');
  return _WidgetbookTest(text);
}

class _WidgetbookTest extends StatefulWidget {
  const _WidgetbookTest(this.text);

  final String text;

  @override
  State<_WidgetbookTest> createState() => _WidgetbookTestState();
}

class _WidgetbookTestState extends State<_WidgetbookTest> {
  var _isTappable = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ErrorForList(
          text: widget.text,
          // ignore: avoid_print
          onPressed: _isTappable ? () => print('pressed') : null,
        ),
        const SizedBox(height: 20),
        Switch(
          value: _isTappable,
          onChanged: (value) => setState(() => _isTappable = value),
        ),
      ],
    );
  }
}
