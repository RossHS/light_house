import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/ble_core/ble_controllers.dart';
import 'package:light_house/src/screens/home/widgets/home_widgets.dart';
import 'package:light_house/src/utils/color_names/color_names.dart';
import 'package:light_house/src/utils/extensions.dart';
import 'package:light_house/src/widgets/running_text_animation.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'dart:ui' as ui;

/// Домашний экран приложения, на нем все необходимая информация для управления
/// Фон - [RunningTextAnimation]
/// Нижний бар - [BottomBar]
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  var _time = 0.0;

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      _time += 0.015;
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
    return Scaffold(
      body: Stack(
        children: [
          ShaderBuilder(
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
            child: Center(
              child: Observer(
                builder: (context) {
                  final color = GetIt.I<RGBController>().color;
                  final closestColor = color.getColorName;
                  return RunningTextAnimation(
                    text: '${closestColor.colorName}\n'
                        'Похожий - 0x${(closestColor.closestColor.value & 0xFFFFFF).uint24HexFormat}\n'
                        'Текущий - 0x${color.red.uint8HexFormat}${color.green.uint8HexFormat}${color.blue.uint8HexFormat}',
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                        ),
                  );
                },
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(),
          ),
        ],
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader});

  ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
