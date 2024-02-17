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

Rect _menuRect = Rect.zero;

class CustomPopupMenu extends StatefulWidget {
  const CustomPopupMenu({
    super.key,
    required this.menuBuilder,
    this.controller,
    this.horizontalMargin = 10.0,
    this.verticalMargin = 10.0,
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
  CustomPopupMenuController? _controller;
  late AnimationController _animationController;

  void _showMenu() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        Widget menu = AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _animationController.value,
              child: child,
            );
          },
          child: Center(
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
                ),
                // TODO 17.02.2024 - подумать о стиле, мб будем брать из темы контекста?
                child: Material(
                  color: Colors.white,
                  shape: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  child: RepaintBoundary(
                    child: widget.menuBuilder(),
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
            // If tap position in menu
            if (_menuRect.contains(Offset(offset.dx - widget.horizontalMargin, offset.dy))) {
              return;
            }
            _controller?.hideMenu();
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
    bool menuIsShowing = _controller?.menuIsShowing ?? false;
    widget.menuOnChange?.call(menuIsShowing);
    if (menuIsShowing) {
      _showMenu();
    } else {
      _hideMenu();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? CustomPopupMenuController();
    _controller?.addListener(_updateView);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        _childBox = context.findRenderObject() as RenderBox?;
        _parentBox = Overlay.of(context).context.findRenderObject() as RenderBox?;
      }
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _controller?.removeListener(_updateView);
    _controller?.dispose();
    super.dispose();
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
        onTap: () => _controller?.showMenu(),
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
  });

  final Size anchorSize;
  final Offset offset;
  final double verticalMargin;

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

    return Offset(contentOffset.dx, contentOffset.dy);
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) => false;
}
