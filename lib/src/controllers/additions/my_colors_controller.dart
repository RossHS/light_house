import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:light_house/src/utils/mobx_async_value.dart';
import 'package:mobx/mobx.dart';

part 'my_colors_controller.g.dart';

// ignore: library_private_types_in_public_api
class MyColorsController = _MyColorsControllerBase with _$MyColorsController;

abstract class _MyColorsControllerBase with Store {
  _MyColorsControllerBase({ColorsControllerDelegator? delegator}) {
    // Код небезопасный, т.к. можно вызывать методы до первичный инициализации [delegator],
    // Но в рамках этого проекта - это простительно, не вижу смысла переусложнять
    this.delegator = delegator ?? HiveColorsControllerDelegator();
    this.delegator.init().then(
          (value) => myColors = AsyncValue.value(value: value),
          onError: (error) => myColors = const AsyncValue.error(
            error: AsyncError(errorMessage: 'Не удалось получить цвета'),
          ),
        );
  }

  late final ColorsControllerDelegator delegator;

  @observable
  AsyncValue<List<Color>> myColors = const AsyncValue.loading();

  /// Запись текущего цвета
  @action
  void saveColor(Color color) {
    final savedColor = delegator.saveColor(color);
    if (savedColor != null) {
      myColors = AsyncValue.value(value: [...?myColors.value, savedColor]);
    }
  }

  /// Удаление ненужного цвета. Сначала удаляем данные в исходной среде,
  /// а потом только в оперативной памяти
  @action
  void deleteColor(Color color) {
    final deletedColor = delegator.deleteColor(color);
    if (deletedColor != null) {
      myColors.value?.remove(deletedColor);
      myColors = AsyncValue.value(value: [...?myColors.value]);
    }
  }
}

/// Делегатор [MyColorsController], нужен для развязывания кода и мок данных,
/// таким образом мы можем не давать прямой доступ к хранилищу,
/// а лишь используем интерфейс
abstract class ColorsControllerDelegator {
  /// Первичные работы необходимые для инициализации делегатора
  Future<List<Color>> init();

  Color? saveColor(Color color);

  Color? deleteColor(Color color);
}

/// Делегатор на основе работы Hive
class HiveColorsControllerDelegator extends ColorsControllerDelegator {
  Box<int>? box;

  @override
  Future<List<Color>> init() async {
    box = await Hive.openBox<int>('my_colors');
    return box!.values.map(Color.new).toList();
  }

  @override
  Color? saveColor(Color color) {
    final box = this.box;
    // Если box не был проинициализирован
    if (box == null) return null;
    final index = _findColorIndexInDB(color);
    if (index < 0) {
      box.add(color.value);
      return color;
    }
    return null;
  }

  @override
  Color? deleteColor(Color color) {
    final box = this.box;
    // Если box не был проинициализирован
    if (box == null) return null;
    final index = _findColorIndexInDB(color);
    if (index >= 0) {
      box.deleteAt(index);
      return color;
    }
    return null;
  }

  int _findColorIndexInDB(Color color) => box!.values.toList().indexWhere((element) => element == color.value);
}
