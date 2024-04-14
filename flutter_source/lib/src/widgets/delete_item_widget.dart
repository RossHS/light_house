import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:light_house/src/utils/extensions.dart';
import 'package:light_house/src/widgets/widgetbook_def_frame.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

class DeleteItemWidget extends StatefulWidget {
  const DeleteItemWidget({
    super.key,
    required this.child,
    this.delete = false,
    this.closeColor = Colors.black,
  });

  final Widget child;
  final bool delete;
  final Color closeColor;

  @override
  State<DeleteItemWidget> createState() => _DeleteItemWidgetState();
}

class _DeleteItemWidgetState extends State<DeleteItemWidget> with TickerProviderStateMixin {
  late final AnimationController _deleteController;
  late final Animation<double> _deleteAnimation;

  @override
  void initState() {
    super.initState();
    _deleteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _deleteAnimation = CurvedAnimation(
      parent: _deleteController,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeInCubic,
    );

    if (widget.delete) {
      _deleteController.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant DeleteItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.delete != widget.delete) {
      _animateToValue();
    }
  }

  @override
  void dispose() {
    _deleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        foregroundPainter: _ClosePainter(
          animation: _deleteAnimation,
          closeColor: widget.closeColor,
        ),
        child: widget.child,
      ),
    );
  }

  void _animateToValue() {
    widget.delete ? _deleteController.forward() : _deleteController.reverse();
  }
}

/// Отрисовка индикации закрытия, красный круг с крестиком
class _ClosePainter extends CustomPainter {
  _ClosePainter({
    required this.animation,
    required this.closeColor,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color closeColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (animation.value == 0) return;
    final radius = (size.width / 3.5) * animation.value;
    final circle = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    final closePaint = Paint()
      ..color = closeColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(
        circle.center.dx + radius * math.cos(_degreesToRadians(40)),
        circle.center.dy + radius * math.sin(_degreesToRadians(40)),
      ),
      Offset(
        circle.center.dx - radius * math.cos(_degreesToRadians(40)),
        circle.center.dy - radius * math.sin(_degreesToRadians(40)),
      ),
      closePaint,
    );

    canvas.drawLine(
      Offset(
        circle.center.dx + radius * math.cos(_degreesToRadians(-40)),
        circle.center.dy + radius * math.sin(_degreesToRadians(-40)),
      ),
      Offset(
        circle.center.dx - radius * math.cos(_degreesToRadians(-40)),
        circle.center.dy - radius * math.sin(_degreesToRadians(-40)),
      ),
      closePaint,
    );
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }

  @override
  bool shouldRepaint(_ClosePainter oldDelegate) => oldDelegate.closeColor != closeColor;
}

//---------------------Widgetbook-----------------//
@widgetbook.UseCase(name: 'DeleteItemWidget use case', type: DeleteItemWidget)
Widget deleteItemWidgetWidgetUseCase(BuildContext context) {
  final color = context.knobs.colorOrNull(label: 'Close Color');
  return WidgetbookDefFrame(
    child: _DeleteItemWidgetTest(color),
  );
}

/// Вспомогательный виджет для [Widgetbook], тут мы просто проверяем поведение [RotationSwitchWidget]
class _DeleteItemWidgetTest extends StatefulWidget {
  const _DeleteItemWidgetTest(this.closeColor);

  final Color? closeColor;

  @override
  State<_DeleteItemWidgetTest> createState() => _DeleteItemWidgetTestState();
}

class _DeleteItemWidgetTestState extends State<_DeleteItemWidgetTest> {
  var delete = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...[
              Colors.black,
              Colors.amber,
              Colors.redAccent,
              Colors.greenAccent,
            ].map(
              (e) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: DeleteItemWidget(
                  delete: delete,
                  closeColor: widget.closeColor ?? e.calcOppositeColor,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: e,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 35),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => setState(() => delete = !delete),
          child: const Text('Toggle'),
        ),
      ],
    );
  }
}
