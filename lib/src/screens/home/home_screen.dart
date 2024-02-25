import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/core/rgb_controller.dart';
import 'package:light_house/src/screens/home/widgets/home_widgets.dart';
import 'package:light_house/src/utils/color_names/color_names.dart';
import 'package:light_house/src/utils/extension.dart';
import 'package:light_house/src/widgets/running_text_animation.dart';

/// Домашний экран приложения, на нем все необходимая информация для управления
/// Фон - [RunningTextAnimation]
/// Нижний бар - [BottomBar]
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
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
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(),
          ),
        ],
      ),
    );
  }
}
