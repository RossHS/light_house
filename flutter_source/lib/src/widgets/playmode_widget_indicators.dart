import 'package:flutter/material.dart';
import 'package:light_house/src/utils/extensions.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

class DisabledPlayModeWidget extends StatefulWidget {
  const DisabledPlayModeWidget({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  State<DisabledPlayModeWidget> createState() => _DisabledPlayModeWidgetState();
}

class _DisabledPlayModeWidgetState extends State<DisabledPlayModeWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final oppositeColor = widget.color.calcOppositeColor;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                // color: widget.color,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.onSurface, width: 0.5),
                gradient: RadialGradient(
                  colors: [
                    widget.color,
                    Colors.transparent,
                  ],
                  stops: [0.3, 1.0],
                  // radius: 0.1,
                  // focalRadius: 1
                ),
              ),
              child: const SizedBox.square(dimension: 34),
            ),
          ),
          Center(
            child: Icon(
              Icons.play_arrow,
              color: oppositeColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

//----------------------------------Widgetbook------------------------------------//
@widgetbook.UseCase(name: 'DisabledPlayModeWidget use case', type: DisabledPlayModeWidget)
Widget disabledPlayModeWidgetUseCase(BuildContext context) {
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
    return DisabledPlayModeWidget(
      color: Colors.black,
    );
  }
}
