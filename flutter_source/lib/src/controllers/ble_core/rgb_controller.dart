import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/models/data_headers.dart';
import 'package:light_house/src/utils/extensions.dart';
import 'package:mobx/mobx.dart';

part 'rgb_controller.g.dart';

// ignore: library_private_types_in_public_api
class RGBController = _RGBControllerBase with _$RGBController;

/// Установка цвета RGB по специальному формату микроконтроллера
/// #cff00fe
abstract class _RGBControllerBase with Store {
  _RGBControllerBase() {
    reaction(
      // Чисто для срабатывания реакции, чтобы при смене этих переменных летел новый запрос
      (_) => color,
      (_) => sendColor(),
    );
  }

  @observable
  Color color = const Color(0xFF000000);

  @action
  Color withRed(int red) {
    color = color.withRed(red);
    return color;
  }

  @action
  Color withGreen(int green) {
    color = color.withGreen(green);
    return color;
  }

  @action
  Color withBlue(int blue) {
    color = color.withBlue(blue);
    return color;
  }

  void sendColor() {
    GetIt.I<SendDataController>().writeData(
      DataHeader.c,
      '${color.red.uint8HexFormat}${color.green.uint8HexFormat}${color.blue.uint8HexFormat}',
    );
  }
}
