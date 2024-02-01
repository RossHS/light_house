import 'package:get_it/get_it.dart';
import 'package:light_house/controllers/send_data_controller.dart';
import 'package:light_house/models/data_headers.dart';
import 'package:light_house/utils/extension.dart';
import 'package:mobx/mobx.dart';

part 'brightness_controller.g.dart';

// ignore: library_private_types_in_public_api
class BrightnessController = _BrightnessControllerBase with _$BrightnessController;

/// Установка яркости по специальному формату микроконтроллера
/// #bfe
abstract class _BrightnessControllerBase with Store {
  _BrightnessControllerBase() {
    reaction(
      (_) => brightness,
      (_) => sendBrightness(),
    );
  }

  @observable
  int brightness = 0;

  void sendBrightness() {
    GetIt.I<SendDataController>().writeData(
      DataHeader.b,
      brightness.uint8HexFormat,
    );
  }
}
