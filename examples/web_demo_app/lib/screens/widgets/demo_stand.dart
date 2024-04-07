import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/rgb_controller.dart';
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
      print(value);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SizedBox.square(
          dimension: widget.mqd.size.longestSide,
          child: Observer(
            builder: (context) {
              final rgbController = GetIt.I<RGBController>();
              return _GlitchShader(
                child: Image.asset('assets/images/picture.jpg'
                    // color: rgbController.color,
                    // child: Text('pepega'),
                    ),
              );
            },
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
    final rgbController = GetIt.I<RGBController>();
    // rgbController.color.blue
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
