import 'package:get_it/get_it.dart';
import 'package:light_house/controllers/send_data_controller.dart';
import 'package:light_house/models/data_headers.dart';
import 'package:mobx/mobx.dart';

part 'play_mode_controller.g.dart';

// ignore: library_private_types_in_public_api
class PlayModeController = _PlayModeControllerBase with _$PlayModeController;

// TODO подумать как лучше сделать, пока нравится вариант с установкой базы
/// Переключение режима проигрывания
abstract class _PlayModeControllerBase with Store {
  String lightMode = '0';

  void sendPlayMode() {
    GetIt.I<SendDataController>().writeData(
      DataHeader.m,
      lightMode,
    );
  }
}
