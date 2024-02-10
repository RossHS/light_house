import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/send_data_controller.dart';
import 'package:light_house/src/models/data_headers.dart';
import 'package:light_house/src/models/play_mode_models.dart';
import 'package:mobx/mobx.dart';

part 'play_mode_controller.g.dart';

// ignore: library_private_types_in_public_api
class PlayModeController = _PlayModeControllerBase with _$PlayModeController;

/// Переключение режима проигрывания, т.е. как будет себя вести светодиод
abstract class _PlayModeControllerBase with Store {
  _PlayModeControllerBase() {
    reaction(
      (_) => playMode,
      (_) => sendPlayMode(),
    );
  }

  /// Текущий режим проигрывания
  @observable
  PlayModeBase playMode = const DisabledPlayMode();

  void sendPlayMode() {
    GetIt.I<SendDataController>().writeData(
      DataHeader.m,
      playMode.genData,
    );
  }
}
