import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:light_house/main.dart' as lh;
import 'package:light_house_web_demo_app/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await lh.permissionRequest();
  await lh.diRegisters(isMock: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(fontFamily: 'JetBrains Mono'),
      routerConfig: router,
      title: 'Light House',
    );
  }
}
