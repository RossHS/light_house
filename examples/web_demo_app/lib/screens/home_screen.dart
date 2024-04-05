import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:light_house/main.dart' as lh;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.black, width: 12),
              ),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(38.5),
                child: const lh.MyApp(),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.go('/widgetbook');
          },
          child: const Text('Widgetbook'),
        ),
      ],
    );
  }
}
