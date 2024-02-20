import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_house/src/controllers/additions/my_colors_controller.dart';
import 'package:light_house/src/utils/mobx_async_value.dart';

/// Тестирование контроллера сохранения цвета [MyColorsController]
Future<void> main() async {
  final controller = MyColorsController(delegator: _MockDelegator());
  group('MyColorsController group test', () {
    test('init controller', () async {
      final controller = MyColorsController(delegator: _MockDelegator());
      expect(controller.myColors.status, AsyncStatus.loading);
      await Future.delayed(Duration.zero);
      expect(controller.myColors.status, AsyncStatus.value);
    });
    test('save delete colors', () async {
      expect(controller.myColors.status, AsyncStatus.value);
      await controller.saveColor(Colors.black);
      expect(controller.myColors.value, {Colors.black});
      // Сохранение уже существующего элемента
      await controller.saveColor(Colors.black);
      expect(controller.myColors.value, {Colors.black});
      // Сохранение нового цвета
      await controller.saveColor(Colors.red);
      expect(controller.myColors.value, {Colors.black, Colors.red});
      // Удаление нового цвета
      await controller.deleteColor(Colors.red);
      expect(controller.myColors.value, {Colors.black});
      // Удаление уже удаленного цвета
      await controller.deleteColor(Colors.red);
      expect(controller.myColors.value, {Colors.black});
      // Удаление последнего цвета
      await controller.deleteColor(Colors.black);
      expect(controller.myColors.value, <Color>{});
    });
  });
}

class _MockDelegator extends ColorsControllerDelegator {
  final Set<Color> _colors = {};

  @override
  Future<Set<Color>> init() async {
    return _colors;
  }

  @override
  Color? deleteColor(Color color) {
    final res = _colors.remove(color);
    return res ? color : null;
  }

  @override
  Color? saveColor(Color color) {
    final res = _colors.add(color);
    return res ? color : null;
  }
}
