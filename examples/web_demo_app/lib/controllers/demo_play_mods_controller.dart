import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/models/play_mode_models.dart';
import 'package:mobx/mobx.dart';

part 'demo_play_mods_controller.g.dart';

// ignore: library_private_types_in_public_api
class DemoPlayModeController = _DemoPlayModeControllerBase with _$DemoPlayModeController;

/// Демо переключатель режимов проигрывания
abstract class _DemoPlayModeControllerBase with Store {
  _DemoPlayModeControllerBase() {
    reaction(
      (_) => currentMode,
      (playMode) {
        currentPlayer?.dispose();
        currentPlayer = switch (playMode) {
          DisabledPlayMode() => _DisabledPlayer(),
          BrightnessPlayMode() => _BrightnessPlayer(),
          ChangeColorPlayMode() => _ChangeColorPlayer(),
        };
      },
    );
  }

  final playModeController = GetIt.I<PlayModeController>();

  _AbstractPlayer? currentPlayer;

  /// Текущий режим проигрывания
  @computed
  PlayModeBase get currentMode => playModeController.playMode;
}

/// Демо режимы проигрывания, нужны только для демонстрации работы приложения
sealed class _AbstractPlayer {
  @protected
  void dispose() {}
}

/// Проигрывание отключено
class _DisabledPlayer extends _AbstractPlayer {}

/// Режим проигрывания яркости
class _BrightnessPlayer extends _AbstractPlayer with _TimeAndColor {
  _BrightnessPlayer() {
    initTimerAndColorReaction();
  }

  /// Сохраненный цвет установленный пользователем
  late Color cachedColor = rgbController.color;

  /// Текущий рассчитываемый цвет
  late Color currentProceedColor = rgbController.color;

  /// Текущая яркость, диапазон от 0 до 255, т.е. один байт
  late int currentBrightness = diapason.max;

  /// Диапазон в рамках которого может гулять яркость
  final diapason = (min: 10, max: 255);

  /// Направление "движения" яркости
  var dir = false;

  int _calcColorChannel(int color) {
    return math.max(0, color - ((color / diapason.max) * (diapason.max - currentBrightness)).toInt());
  }

  @override
  void timerCallback(Timer timer) {
    if (currentBrightness >= diapason.max) {
      dir = false;
    } else if (currentBrightness <= diapason.min) {
      dir = true;
    }

    dir ? currentBrightness++ : currentBrightness--;
    currentProceedColor = Color.fromRGBO(
      _calcColorChannel(cachedColor.red),
      _calcColorChannel(cachedColor.green),
      _calcColorChannel(cachedColor.blue),
      1,
    );
    if (currentProceedColor != rgbController.color) {
      rgbController.color = currentProceedColor;
    }
  }

  @override
  void colorCallback(Color color) {
    if (color != currentProceedColor) {
      cachedColor = color;
      currentBrightness = diapason.max;
    }
  }
}

/// Режим "кругового" вращения цвета
class _ChangeColorPlayer extends _AbstractPlayer with _TimeAndColor {
  _ChangeColorPlayer() {
    initTimerAndColorReaction();
  }

  /// Сохраненный цвет установленный пользователем
  late HSLColor cachedColor = HSLColor.fromColor(rgbController.color);

  /// Текущий рассчитываемый цвет
  late Color currentProceedColor = rgbController.color;

  var currentHue = 0.0;

  final fadeSpeed = 1;

  @override
  void timerCallback(Timer timer) {
    currentHue += 0.5;
    currentProceedColor = cachedColor.withHue(currentHue % 360).toColor();
    if (currentProceedColor != rgbController.color) {
      rgbController.color = currentProceedColor;
    }
  }

  @override
  void colorCallback(Color color) {
    if (color != currentProceedColor) {
      cachedColor = HSLColor.fromColor(color);
      currentHue = cachedColor.hue;
    }
  }
}

//-------------------------------mixin-------------------------------//
/// Таймер и контроль цвета для классов [_AbstractPlayer]
mixin _TimeAndColor on _AbstractPlayer {
  final rgbController = GetIt.I<RGBController>();
  Timer? timer;
  ReactionDisposer? colorReaction;

  void initTimerAndColorReaction() {
    timer = Timer.periodic(
      const Duration(milliseconds: 16),
      timerCallback,
    );
    colorReaction = reaction(
      (_) => rgbController.color,
      colorCallback,
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    colorReaction?.call();
  }

  /// Тик времени таймера [timer]
  @protected
  void timerCallback(Timer timer);

  /// Передача текущего цвета с контроллера [rgbController]
  /// Здесь совершать проверку, на которой мы смотрим, у нас действительно
  /// новый цвет или тот, что мы установили сами, необходимо для
  /// быстрой подстройки под новый цвет пользователя
  @protected
  void colorCallback(Color color);
}
