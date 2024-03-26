import 'package:flutter/material.dart';
import 'package:light_house/src/screens/home/widgets/home_widgets.dart';
import 'package:light_house/src/widgets/running_text_animation.dart';

/// Домашний экран приложения, на нем все необходимая информация для управления
/// Фон - [RunningTextAnimation]
/// Нижний бар - [BottomBar]
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Background(),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: AnimatedAppErrorsList(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: BLEConnectionStatesIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
