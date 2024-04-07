import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/services/ble_react_wrappers.dart';

/// Визуализация отправки данных
class DemoStand extends StatefulWidget {
  const DemoStand({
    super.key,
    required this.mqd,
  });

  final MediaQueryData mqd;

  @override
  State<DemoStand> createState() => _DemoStandState();
}

class _DemoStandState extends State<DemoStand> {
  final bleReactWrapperMock = GetIt.I<BleReactWrapperInterface>() as BleReactWrapperMock;

  @override
  void initState() {
    super.initState();
    bleReactWrapperMock.dataListener = (value) {
      // print(value);
    };
  }

  @override
  void dispose() {
    bleReactWrapperMock.dataListener = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      // т.к. картинка может быть не загружена,
      // а мы в рантайме (при ее загрузке) не знаем фактические размеры,
      // то необходимо задать ограничения
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: widget.mqd.size.width,
          maxHeight: widget.mqd.size.height,
        ),
        child: AspectRatio(
          aspectRatio: 2329 / 3093, // Хардкод соотношение сторон под фотку 🤡
          child: ClipRRect(
            clipBehavior: ui.Clip.antiAlias,
            borderRadius: const BorderRadius.all(ui.Radius.circular(38.5)),
            child: _GlitchShader(
              child: Image.asset(
                'assets/images/picture.jpg',
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(seconds: 2),
                    child: child,
                  );
                },
              ),
            ),
          ),
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
  final rgbController = GetIt.I<RGBController>();
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

  double _coordinateTranslation(int value) => value / 255.0;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'assets/shaders/cam_glitch.glsl',
      (context, shader, child) {
        return AnimatedSampler(
          child: child!,
          (ui.Image image, Size size, Canvas canvas) {
            final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
            final rbgColor = rgbController.color;
            shader
              ..setFloat(0, image.width.toDouble() / devicePixelRatio)
              ..setFloat(1, image.height.toDouble() / devicePixelRatio)
              ..setFloat(2, _time)
              ..setFloat(3, _coordinateTranslation(rbgColor.red))
              ..setFloat(4, _coordinateTranslation(rbgColor.green))
              ..setFloat(5, _coordinateTranslation(rbgColor.blue))
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
