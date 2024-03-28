import 'package:light_house/src/utils/sp_keys.dart' as sp;
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_controller.g.dart';

// ignore: library_private_types_in_public_api
class SettingsController = _SettingsControllerBase with _$SettingsController;

/// Контроллер отвечающий за тему приложения. Меняя [themeMode] мы меняем тему - светлая/темная
abstract class _SettingsControllerBase with Store {
  _SettingsControllerBase(this._prefs) {
    _parseSPSettings();
  }

  final SharedPreferences _prefs;

  @observable
  bool _glitchOn = false;

  bool get glitchOn => _glitchOn;

  set glitchOn(bool isOn) {
    _glitchOn = isOn;
    _prefs.setBool(sp.settingsGlitchOnKey, isOn);
  }

  /// Первичная загрузка данных из [SharedPreferences]
  @action
  void _parseSPSettings() {
    _glitchOn = _prefs.getBool(sp.settingsGlitchOnKey) ?? _glitchOn;
  }
}
