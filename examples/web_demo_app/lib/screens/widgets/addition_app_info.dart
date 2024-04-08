import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:light_house/src/widgets/animated_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// Название приложения и дополнительная инфа
class AdditionInfo extends StatelessWidget {
  const AdditionInfo({super.key, required this.mqd});

  final MediaQueryData mqd;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Light house',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                ),
          ),
          Text(
            'Пример работы приложения',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedButton(
                onPressed: () => context.go('/widgetbook'),
                child: const Text('Верста элементов\nWidgetbook'),
              ),
              const SizedBox(width: 20),
              AnimatedButton(
                onPressed: () => launchUrl(Uri.parse('https://github.com/RossHS/light_house')),
                child: const Text('Исходники\nGitHub'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
