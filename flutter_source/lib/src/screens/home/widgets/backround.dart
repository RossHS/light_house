import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/additions/settings_controller.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/utils/color_names/color_names.dart';
import 'package:light_house/src/utils/extensions.dart';
import 'package:light_house/src/widgets/running_text_animation.dart';

/// Виджет фона, который используется для главной страницы приложения
class Background extends StatefulWidget {
  const Background({super.key});

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  /// Необходим для добавления виджетов в уже существующее дерево
  /// т.е. мы по факту ПЕРЕИСПОЛЬЗУЕМ [_TextBackgroundWidget] и
  /// в лайве добавляем и удаляем виджет [_GlitchShader],
  /// не пересоздавая [_TextBackgroundWidget]
  final _key = GlobalKey(debugLabel: 'background widget');

  @override
  Widget build(BuildContext context) {
    final settings = GetIt.I<SettingsController>();
    final background = _TextBackgroundWidget(key: _key);
    return Observer(
      builder: (context) {
        return settings.glitchOn ? _GlitchShader(child: background) : background;
      },
    );
  }
}

class _TextBackgroundWidget extends StatelessWidget {
  const _TextBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Observer(
          builder: (context) {
            final color = GetIt.I<RGBController>().color;
            final closestColor = color.getColorName;
            return RunningTextAnimation(
              text: '${closestColor.colorName}\n'
                  'Похожий - 0x${(closestColor.closestColor.value & 0xFFFFFF).uint24HexFormat}\n'
                  'Текущий - 0x${color.red.uint8HexFormat}${color.green.uint8HexFormat}${color.blue.uint8HexFormat}',
              textStyle: theme.textTheme.bodyLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w100,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Glitch виджет, который использует шейдер
class _GlitchShader extends StatefulWidget {
  const _GlitchShader({
    required this.child,
  });

  final Widget child;

  @override
  State<_GlitchShader> createState() => _GlitchShaderState();
}

class _GlitchShaderState extends State<_GlitchShader> with SingleTickerProviderStateMixin {
  var _time = 0.0;

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      _time = elapsed.inMilliseconds / 1000;
      setState(() {});
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'assets/shaders/glitch.glsl',
      (context, shader, child) {
        return AnimatedSampler(
          child: child!,
          (ui.Image image, Size size, Canvas canvas) {
            final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
            shader
              ..setFloat(0, image.width.toDouble() / devicePixelRatio)
              ..setFloat(1, image.height.toDouble() / devicePixelRatio)
              ..setFloat(2, _time)
              ..setImageSampler(0, image);

            canvas.drawRect(
              Offset.zero & size,
              Paint()..shader = shader,
            );
          },
        );
      },
      child: widget.child,
    );
  }
}
