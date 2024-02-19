import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:light_house/src/screens/home/widgets/bottom_bar/bottom_bar.dart';
import 'package:light_house/src/widgets/custom_popup_menu.dart';
import 'package:light_house/src/widgets/rotation_switch_widget.dart';

/// Универсальный виджет, который сильно упрощает рутинный код для [BottomBar],
/// что он делает, вызывает под капотом [CustomPopupMenu], с возможностью кастомизации
/// иконки неактивности - [iconWidget],
/// и передача тела кастомного тела меню [menuWidget], который и будет показан в оверлее
class BottomCustomPopupButton extends StatefulWidget {
  const BottomCustomPopupButton({
    super.key,
    required this.iconWidget,
    required this.menuWidget,
  });

  final Widget iconWidget;
  final Widget menuWidget;

  @override
  State<BottomCustomPopupButton> createState() => _BottomCustomPopupButtonState();
}

class _BottomCustomPopupButtonState extends State<BottomCustomPopupButton> {
  var _menuIsShowing = false;
  final _customPopupController = CustomPopupMenuController();

  @override
  void dispose() {
    super.dispose();
    _customPopupController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      controller: _customPopupController,
      menuBuilder: () {
        return  BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: widget.menuWidget,
        );
      },
      child: IconButton(
        onPressed: () {
          _menuIsShowing ? _customPopupController.hideMenu() : _customPopupController.showMenu();
          setState(() {
            _menuIsShowing = !_menuIsShowing;
          });
        },
        icon: RotationSwitchWidget(
          child: _menuIsShowing
              ? Icon(key: ValueKey(_menuIsShowing), Icons.close)
              : KeyedSubtree(key: ValueKey(_menuIsShowing), child: widget.iconWidget),
        ),
      ),
      menuOnChanged: (menuIsShowing) => setState(() => _menuIsShowing = menuIsShowing),
    );
  }
}
