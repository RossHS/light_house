import 'package:flutter/material.dart';
import 'package:light_house/src/screens/home/widgets/home_widgets.dart';
import 'package:light_house/src/widgets/object_fly_animation.dart';
import 'package:light_house/src/widgets/running_text_animation.dart';

/// Ключ конечной точки виджета [ObjectFlyAnimation], куда будет совершен полет
final GlobalKey flyingDestKey = GlobalKey(debugLabel: 'flying_animation_dest_key');

/// Домашний экран приложения, на нем все необходимая информация для управления
/// Фон - [RunningTextAnimation]
/// Нижний бар - [BottomBar]
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Добавил свой слой с оверлеем, т.к. есть переходы на другие
    // экраны и оверлей перейдет и на них, ведь ближайший оверлей
    // стоит на самом верху дерева виджетов
    return ObjectFlyAnimation(
      destinationGlobalKey: flyingDestKey,
      child: Overlay.wrap(
        child: const Scaffold(
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
        ),
      ),
    );
  }
}
