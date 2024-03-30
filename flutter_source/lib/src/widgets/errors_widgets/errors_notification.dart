import 'package:flutter/material.dart';
import 'package:light_house/src/widgets/animated_button.dart';
import 'package:light_house/src/widgets/glass_box.dart';

/// Плашка с текстом об ошибки, может быть как просто текстом, так и анимированной кнопкой
/// Для вызова просто текста используем [ErrorsNotification.text], для кнопки [ErrorsNotification.button]
class ErrorsNotification extends StatelessWidget {
  const ErrorsNotification({
    super.key,
    required this.isButton,
    this.onPressed,
    required this.child,
  });

  const ErrorsNotification.text({
    super.key,
    required this.child,
  })  : isButton = false,
        onPressed = null;

  const ErrorsNotification.button({
    super.key,
    required this.child,
    required this.onPressed,
  }) : isButton = true;

  final bool isButton;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isButton){
      return AnimatedButton(
        color: theme.colorScheme.error,
        onPressed: onPressed,
        child: child,
      );
    }
    return GlassBox(
      glassColor: theme.colorScheme.error,
      opacity: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium!,
          child: child,
        ),
      ),
    );
  }
}
