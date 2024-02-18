import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/src/controllers/rgb_controller.dart';
import 'package:light_house/src/screens/home/widgets/home_widgets.dart';
import 'package:light_house/src/utils/extension.dart';
import 'package:light_house/src/widgets/animated_text_background.dart';

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
                return RunningTextAnimation(
                  text: '0x${color.red.uint8HexFormat}${color.green.uint8HexFormat}${color.blue.uint8HexFormat}_',
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
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
