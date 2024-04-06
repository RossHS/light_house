import 'package:flutter/material.dart';
import 'package:light_house/main.dart' as lh;
import 'package:light_house_web_demo_app/screens/widgets/home_screen_widgets.dart';

/// Главный экран приложения примера
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Overlay.wrap(child: const lh.MyApp());
    return Scaffold(
      body: MediaQuery.of(context).size.width > 600 ? WideScreenLayout(device: app) : app,
    );
  }
}
