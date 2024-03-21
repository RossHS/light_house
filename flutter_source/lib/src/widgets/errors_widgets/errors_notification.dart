import 'package:flutter/material.dart';
import 'package:light_house/src/widgets/errors_widgets/errors_widgets.dart';
import 'package:light_house/src/widgets/glass_box.dart';

/// Плашка с текстом об ошибки, может быть как просто текстом, так и анимированной кнопкой
/// Для вызова просто текста используем [ErrorsNotification.text], для кнопки [ErrorsNotification.button]
class ErrorsNotification extends StatelessWidget {
  const ErrorsNotification({
    super.key,
    required this.text,
    required this.isButton,
    this.onPressed,
  });

  const ErrorsNotification.text({
    super.key,
    required this.text,
  })  : isButton = false,
        onPressed = null;

  const ErrorsNotification.button({
    super.key,
    required this.text,
    required this.onPressed,
  }) : isButton = true;

  final String text;
  final bool isButton;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final child = GlassBox(
      glassColor: colorScheme.error,
      opacity: 1,
      boxBorderSides: const BoxBorderSides.all(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
    return isButton
        ? ErrorsAnimatedButton(
            onPressed: onPressed,
            child: child,
          )
        : child;
  }
}
