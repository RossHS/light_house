import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Виджет переключения [child], т.е. при смене виджета произойдет его вращение с затемнением
class RotationSwitchWidget extends StatelessWidget {
  const RotationSwitchWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: RotationTransition(
          turns: animation,
          child: child,
        ),
      ),
      child: child,
    );
  }
}

@widgetbook.UseCase(name: 'RotationSwitchWidget use case', type: RotationSwitchWidget)
Widget rotationSwitchWidgetUseCase(BuildContext context) {
  final ms = context.knobs.int.slider(
    label: 'Duration ms',
    initialValue: 1000,
    min: 200,
    max: 5000,
  );
  return Center(
    child: _RotationSwitchTest(
      duration: Duration(milliseconds: ms),
    ),
  );
}

/// Вспомогательный виджет для [Widgetbook], тут мы просто проверяем поведение [RotationSwitchWidget]
class _RotationSwitchTest extends StatefulWidget {
  const _RotationSwitchTest({
    required this.duration,
  });

  final Duration duration;

  @override
  State<_RotationSwitchTest> createState() => _RotationSwitchTestState();
}

class _RotationSwitchTestState extends State<_RotationSwitchTest> {
  var _state = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => setState(() => _state = !_state),
      icon: RotationSwitchWidget(
        duration: widget.duration,
        child: _state
            ? Icon(key: ValueKey(_state), Icons.light_mode)
            : Icon(key: ValueKey(_state), Icons.nights_stay_sharp),
      ),
    );
  }
}
