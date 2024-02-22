import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Анимация перелета одного элемента в другой
class ObjectFlyAnimation extends StatefulWidget {
  const ObjectFlyAnimation({
    super.key,
    required this.destinationGlobalKey,
    required this.child,
    this.onAnimationEnd,
  });

  /// Ключи виджета в который полетит элемент
  final GlobalKey destinationGlobalKey;

  /// Обратный вызов, который срабатываем при окончании анимации
  final VoidCallback? onAnimationEnd;
  final Widget child;

  static ObjectFlyAnimationState of(BuildContext context) {
    ObjectFlyAnimationState? state;
    if (context is StatefulElement && context.state is ObjectFlyAnimationState) {
      state = context.state as ObjectFlyAnimationState;
    }
    state = state ?? context.findAncestorStateOfType<ObjectFlyAnimationState>();
    assert(() {
      if (state == null) throw FlutterError('ObjectFlyAnimationState state not found');
      return true;
    }());
    return state!;
  }

  @override
  State<ObjectFlyAnimation> createState() => ObjectFlyAnimationState();
}

class ObjectFlyAnimationState extends State<ObjectFlyAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  void startFlyAnimation({required GlobalKey sourceWidget, required Widget flyingWidget}) {
    final destBox = widget.destinationGlobalKey.currentContext?.findRenderObject() as RenderBox;
    final destPosition = destBox.localToGlobal(Offset.zero);
    final destSize = destBox.size;

    final sourceBox = sourceWidget.currentContext?.findRenderObject() as RenderBox;
    final sourcePosition = sourceBox.localToGlobal(Offset.zero);
    final sourceSize = sourceBox.size;
    // Рассчитываем центры виджетов на экране в абсолютных координатах
    _showOverlay(
      Offset(sourcePosition.dx + sourceSize.width / 2, sourcePosition.dy + sourceSize.height / 2),
      Offset(destPosition.dx + destSize.width / 2, destPosition.dy + destSize.height / 2),
      flyingWidget,
    );
  }

  void _showOverlay(Offset startOffset, Offset endOffset, Widget flyingObject) {
    if (_overlayEntry != null) return;
    final movingAnimation = Tween<Offset>(begin: startOffset, end: endOffset).animate(_controller);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: movingAnimation,
          builder: (BuildContext context, Widget? child) {
            return _PositionCentered(
              center: movingAnimation.value,
              child: child!,
            );
          },
          child: flyingObject,
        );
      },
    );
    _controller.forward(from: 0).then((value) {
      _hideOverlay();
    });
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    widget.onAnimationEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Виджет, которые отображает дочерний элемент [child] согласно заданному центру [center].
/// Т.е. он нужен для достижения совпадения центра [child] с центром параметра [center]
class _PositionCentered extends SingleChildRenderObjectWidget {
  const _PositionCentered({
    required this.center,
    required super.child,
  });

  /// Центр в котором будет находиться наш дочерний элемент [child]
  final Offset center;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _PositionCenteredRenderObject(center: center);
  }

  @override
  void updateRenderObject(BuildContext context, _PositionCenteredRenderObject renderObject) {
    renderObject.center = center;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Offset>('center', center));
  }
}

/// RenderObject для [_PositionCentered], в нем происходит вся логика отрисовки
class _PositionCenteredRenderObject extends RenderProxyBox {
  _PositionCenteredRenderObject({required Offset center}) : _center = center;

  /// Центр в котором будет находиться наш дочерний элемент [child]
  Offset _center;

  Offset get center => _center;

  set center(Offset value) {
    if (_center == value) {
      return;
    }
    _center = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    child!.layout(constraints.loosen(), parentUsesSize: true);
    size = constraints.constrain(child!.size);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(
      child!,
      Offset(_center.dx - child!.size.width / 2, _center.dy - child!.size.height / 2),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Offset>('center', _center));
  }
}
