import 'package:flutter/material.dart';

/// Кастомное меню, которое по сути является оверлеем [OverlayEntry]

class CustomPopupMenuController extends ChangeNotifier {
  bool menuIsShowing = false;

  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }
}

class CustomPopupMenu extends StatefulWidget {
  const CustomPopupMenu({
    super.key,
    required this.menuBuilder,
    this.controller,
    this.horizontalMargin = 10.0,
    this.verticalMargin = 20.0,
    this.menuOnChange,
    this.enablePassEvent = true,
    required this.child,
  });

  final double horizontalMargin;
  final double verticalMargin;
  final CustomPopupMenuController? controller;
  final Widget Function() menuBuilder;
  final void Function(bool)? menuOnChange;
  final bool enablePassEvent;
  final Widget child;

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> with SingleTickerProviderStateMixin {
  RenderBox? _childBox;
  RenderBox? _parentBox;
  OverlayEntry? _overlayEntry;
  CustomPopupMenuController? _popupController;
  late AnimationController _animationController;
  late Animation<double> _drawAnimation;
  late Animation<double> _opacityAnimation;

// Квадрат меню, по нему мы понимаем рамки нашего контента на экране
  var _menuScreenRect = Rect.zero;

  @override
  void initState() {
    super.initState();
    _popupController = widget.controller ?? CustomPopupMenuController();
    _popupController?.addListener(_updateView);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        _childBox = context.findRenderObject() as RenderBox?;
        _parentBox = Overlay.of(context).context.findRenderObject() as RenderBox?;
      }
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _drawAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.5)),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.5, 1.0)),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _popupController?.removeListener(_updateView);
    _popupController?.dispose();
    super.dispose();
  }

  void _showMenu() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        Widget menu = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _parentBox!.size.width - 2 * widget.horizontalMargin,
              minWidth: 0,
            ),
            child: CustomSingleChildLayout(
              delegate: _MenuLayoutDelegate(
                anchorSize: _childBox!.size,
                offset: _childBox!.localToGlobal(
                  Offset(-widget.horizontalMargin, 0),
                ),
                verticalMargin: widget.verticalMargin,
                onScreenRectCalculated: (rect) => _menuScreenRect = rect,
              ),
              // TODO 17.02.2024 - подумать о стиле, мб будем брать из темы контекста?
              child: RepaintBoundary(
                child: CustomPaint(
                  foregroundPainter: _CustomLinePainter(animation: _drawAnimation),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Material(
                      color: Colors.white,
                      child: widget.menuBuilder(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        return Listener(
          behavior: widget.enablePassEvent ? HitTestBehavior.translucent : HitTestBehavior.opaque,
          onPointerDown: (event) {
            Offset offset = event.localPosition;
            // Если мы кликнули внутри бокса оверлея
            if (_menuScreenRect.contains(Offset(offset.dx - widget.horizontalMargin, offset.dy))) {
              return;
            }
            _popupController?.hideMenu();
          },
          child: menu,
        );
      },
    );
    _animationController.forward();

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideMenu() {
    if (_overlayEntry != null) {
      _animationController.reverse().whenComplete(() {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  void _updateView() {
    bool menuIsShowing = _popupController?.menuIsShowing ?? false;
    widget.menuOnChange?.call(menuIsShowing);
    if (menuIsShowing) {
      _showMenu();
    } else {
      _hideMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        _hideMenu();
        Navigator.of(context).pop();
      },
      child: GestureDetector(
        onTap: () => _popupController?.showMenu(),
        child: widget.child,
      ),
    );
  }
}

enum _MenuPosition {
  bottomLeft,
  bottomCenter,
  bottomRight,
  topLeft,
  topCenter,
  topRight,
}

class _MenuLayoutDelegate extends SingleChildLayoutDelegate {
  _MenuLayoutDelegate({
    required this.anchorSize,
    required this.offset,
    required this.verticalMargin,
    required this.onScreenRectCalculated,
  });

  final Size anchorSize;
  final Offset offset;
  final double verticalMargin;
  final Function(Rect rect) onScreenRectCalculated;

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    Offset contentOffset = const Offset(0, 0);
    double anchorCenterX = offset.dx + anchorSize.width / 2;
    double anchorTopY = offset.dy;
    double anchorBottomY = anchorTopY + anchorSize.height;
    _MenuPosition menuPosition = _MenuPosition.bottomCenter;

    if (anchorCenterX - childSize.width / 2 < 0) {
      menuPosition = _MenuPosition.topLeft;
    } else if (anchorCenterX + childSize.width / 2 > size.width) {
      menuPosition = _MenuPosition.topRight;
    } else {
      menuPosition = _MenuPosition.topCenter;
    }

    contentOffset = switch (menuPosition) {
      _MenuPosition.bottomCenter => contentOffset = Offset(
          anchorCenterX - childSize.width / 2,
          anchorBottomY + verticalMargin,
        ),
      _MenuPosition.bottomLeft => contentOffset = Offset(
          0,
          anchorBottomY + verticalMargin,
        ),
      _MenuPosition.bottomRight => contentOffset = Offset(
          size.width - childSize.width,
          anchorBottomY + verticalMargin,
        ),
      _MenuPosition.topCenter => contentOffset = Offset(
          anchorCenterX - childSize.width / 2,
          anchorTopY - verticalMargin - childSize.height,
        ),
      _MenuPosition.topLeft => contentOffset = Offset(
          0,
          anchorTopY - verticalMargin - childSize.height,
        ),
      _MenuPosition.topRight => contentOffset = Offset(
          size.width - childSize.width,
          anchorTopY - verticalMargin - childSize.height,
        ),
    };

    // Отдаем размер бокса по обратному вызову
    onScreenRectCalculated(
      Rect.fromLTWH(
        contentOffset.dx,
        contentOffset.dy,
        childSize.width,
        childSize.height,
      ),
    );
    return Offset(contentOffset.dx, contentOffset.dy);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) => false;
}

/// Отрисовка контура при появлении [CustomPopupMenu] на экране
class _CustomLinePainter extends CustomPainter {
  _CustomLinePainter({
    required this.animation,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final _border = Paint()
    ..color = Colors.black
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Общая длина пути
    final totalPathLen = size.height + size.width;
    // Когда 0, анимация отключена, когда 1 - анимация завершена, значит мы прошли весь путь
    final currentPathLen = totalPathLen * animation.value;
    final rightPath = Path();
    final topPath = Path();
    rightPath.moveTo(0, size.height);
    topPath.moveTo(0, size.height);
    if (currentPathLen == 0) return;
    rightPath.lineTo(currentPathLen.clamp(0, size.width), size.height);
    topPath.lineTo(0, (size.height - currentPathLen).clamp(0, size.height));

    // Добавляем разворот для линий
    if (currentPathLen >= size.width) {
      rightPath.lineTo(size.width, (size.height - (currentPathLen-size.width)).clamp(0, size.height));
    }
    if (currentPathLen >= size.height) {
      topPath.lineTo((currentPathLen-size.height).clamp(0, size.width), 0);
    }

    canvas.drawPath(topPath, _border);
    canvas.drawPath(rightPath, _border);
  }

  @override
  bool shouldRepaint(_CustomLinePainter oldDelegate) {
    return false;
  }
}
