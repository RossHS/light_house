import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:light_house/src/utils/mobx_async_value.dart';
import 'package:mobx/mobx.dart';

part 'my_colors_controller.g.dart';

// ignore: library_private_types_in_public_api
class MyColorsController = _MyColorsControllerBase with _$MyColorsController;

abstract class _MyColorsControllerBase with Store {
  _MyColorsControllerBase({ColorsControllerDelegator? delegator}) {
    ColorsControllerDelegator sourceDelegator = delegator ?? HiveColorsControllerDelegator();
    sourceDelegator.init().then(
      (value) {
        _delegator.complete(sourceDelegator);
        myColors = AsyncValue.value(value: value);
      },
      onError: (error) {
        _delegator.completeError(error);
        return myColors = const AsyncValue.error(
          error: AsyncError(errorMessage: 'Не удалось получить цвета'),
        );
      },
    );
  }

  final Completer<ColorsControllerDelegator> _delegator = Completer();

  @observable
  AsyncValue<List<Color>> myColors = const AsyncValue.loading();

  /// Запись текущего цвета
  @action
  Future<bool> saveColor(Color color) async {
    final savedColor = (await _delegator.future).saveColor(color);
    if (savedColor != null) {
      myColors = AsyncValue.value(value: [...?myColors.value, savedColor]);
      return true;
    }
    return false;
  }

  /// Удаление ненужного цвета. Сначала удаляем данные в исходной среде,
  /// а потом только в оперативной памяти
  @action
  Future<bool> deleteColor(Color color) async {
    final deletedColor = (await _delegator.future).deleteColor(color);
    if (deletedColor != null) {
      myColors.value?.remove(deletedColor);
      myColors = AsyncValue.value(value: [...?myColors.value]);
      return true;
    }
    return false;
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
