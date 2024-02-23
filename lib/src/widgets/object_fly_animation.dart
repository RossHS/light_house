import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Состояния анимации
enum ObjectFlyingStates {
  unknown,
  started,
  ended,
}

/// Оповещатель, через него мы можем получать информацию о
/// состояниях перехода в разных участках приложения
class ObjectFlyingNotifier extends ValueNotifier<ObjectFlyingStates> {
  ObjectFlyingNotifier() : super(ObjectFlyingStates.unknown);
}

/// Анимация перелета одного элемента в другой
class ObjectFlyAnimation extends StatefulWidget {
  const ObjectFlyAnimation({
    super.key,
    required this.destinationGlobalKey,
    this.objectFlyingNotifier,
    required this.child,
  });

  /// Ключи виджета в который полетит элемент
  final GlobalKey destinationGlobalKey;

  /// Нотифаер, слушая его мы можем понимать состояния процесса анимации
  final ObjectFlyingNotifier? objectFlyingNotifier;

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

  static ObjectFlyingNotifier notifier(BuildContext context) => ObjectFlyAnimation.of(context).objectFlyingNotifier;

  @override
  State<ObjectFlyAnimation> createState() => ObjectFlyAnimationState();
}

class ObjectFlyAnimationState extends State<ObjectFlyAnimation> with SingleTickerProviderStateMixin {
  late final ObjectFlyingNotifier objectFlyingNotifier;
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    objectFlyingNotifier = widget.objectFlyingNotifier ?? ObjectFlyingNotifier();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _animationController.dispose();
    if (widget.objectFlyingNotifier == null) {
      objectFlyingNotifier.dispose();
    }
    super.dispose();
  }

  /// Запуск анимации, где [sourceWidget] - ключ того виджета откуда пойдет анимация,
  /// а [flyingWidget] - это тот виджет который мы подвергнем анимации
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

    // Анимация перемещения виджета по экрану от двух центров
    final movingAnimation = Tween<Offset>(begin: startOffset, end: endOffset).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.slowMiddle,
      ),
    );

    // Анимация "подлета" виджета
    final scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: .1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: .8),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: .1),
    ]).animate(_animationController);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: movingAnimation,
          builder: (_, __) {
            return _PositionCentered(
              center: movingAnimation.value,
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: flyingObject,
              ),
            );
          },
        );
      },
    );
    _animationController.forward(from: 0).then((value) {
      _hideOverlay();
    });
    Overlay.of(context).insert(_overlayEntry!);
    objectFlyingNotifier.value = ObjectFlyingStates.started;
  }

  void _hideOverlay() {
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    objectFlyingNotifier.value = ObjectFlyingStates.ended;
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

//---------------------Widgetbook----------------------//
@widgetbook.UseCase(name: 'ObjectFlyAnimation use case', type: ObjectFlyAnimation)
Widget objectFlyAnimationUseCase(BuildContext context) {
  return const _WidgetbookExample();
}

class _WidgetbookExample extends StatefulWidget {
  const _WidgetbookExample();

  @override
  State<_WidgetbookExample> createState() => _WidgetbookExampleState();
}

class _WidgetbookExampleState extends State<_WidgetbookExample> {
  final GlobalKey _destKey = GlobalKey(debugLabel: 'flying_animation_dest_key');
  final GlobalKey _sourceKey = GlobalKey(debugLabel: 'flying_animation_source_key');
  final _notifier = ObjectFlyingNotifier();

  // Список со состояниями анимации
  final _statesList = <String>[];

  @override
  void initState() {
    super.initState();
    _notifier.addListener(() => setState(() => _statesList.add('${DateTime.now()}: ${_notifier.value}')));
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ObjectFlyAnimation(
        destinationGlobalKey: _destKey,
        objectFlyingNotifier: _notifier,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(key: _sourceKey, Icons.start),
                Icon(key: _destKey, Icons.stop),
              ],
            ),
            const SizedBox(height: 20),
            Builder(
              // Чисто для получения контекста
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ObjectFlyAnimation.of(context).startFlyAnimation(
                      sourceWidget: _sourceKey,
                      flyingWidget: const Icon(Icons.ac_unit),
                    );
                  },
                  child: const Text('Run animation'),
                );
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _statesList.length,
                itemBuilder: (context, index) => Text(_statesList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
