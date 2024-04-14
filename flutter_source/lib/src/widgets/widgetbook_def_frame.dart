import 'package:flutter/material.dart';

class WidgetbookDefFrame extends StatelessWidget {
  const WidgetbookDefFrame({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return ColoredBox(
      color: brightness == Brightness.light ? Colors.white : Colors.blueGrey,
      child: Center(child: child),
    );
  }
}
