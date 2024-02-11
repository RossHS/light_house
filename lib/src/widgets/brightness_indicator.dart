import 'package:flutter/material.dart';

// TODO 11.02.2024 - доделать, пока тут пусто
class BrightnessIndicator extends StatefulWidget {
  const BrightnessIndicator({
    super.key,
    required this.brightness,
  });

  final int brightness;

  @override
  State<BrightnessIndicator> createState() => _BrightnessIndicatorState();
}

class _BrightnessIndicatorState extends State<BrightnessIndicator> {
  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.lightbulb_outlined,
      fill: 1,
    );
  }
}
