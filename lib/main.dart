import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:light_house/controllers/brightness_controller.dart';
import 'package:light_house/controllers/rgb_controller.dart';
import 'package:light_house/controllers/send_data_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _diRegisters();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Observer(
            builder: (context) {
              final rgbController = GetIt.I<RGBController>();
              final brightnessController = GetIt.I<BrightnessController>();
              return Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                //
                // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
                // action in the IDE, or press "p" in the console), to see the
                // wireframe for each widget.
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 12),
                  // Text('0x$_red, 0x$_green, 0x$_blue; hash -0x${calcHashSum([_red, _green, _blue]).toRadixString(16)}'),
                  const SizedBox(height: 12),
                  Slider(
                    activeColor: Colors.red,
                    value: rgbController.red.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) {
                      rgbController.red = value.toInt();
                    },
                  ),
                  Slider(
                    activeColor: Colors.green,
                    value: rgbController.green.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) {
                      rgbController.green = value.toInt();
                    },
                  ),
                  Slider(
                    activeColor: Colors.blue,
                    value: rgbController.blue.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) {
                      rgbController.blue = value.toInt();
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Яркость'),
                  Slider(
                    activeColor: Colors.yellow,
                    value: brightnessController.brightness.toDouble(),
                    min: 0,
                    max: 255,
                    onChanged: (value) {
                      brightnessController.brightness = value.toInt();
                    },
                  ),
                  // Slider(
                  //   activeColor: Colors.green,
                  //   value: int.parse(_green, radix: 16).toDouble(),
                  //   min: 0,
                  //   max: 255,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _green = value.toInt().toRadixString(16).padLeft(2, '0');
                  //       _writeData('$_red$_green$_blue');
                  //     });
                  //   },
                  // ),
                  // Slider(
                  //   activeColor: Colors.blue,
                  //   value: int.parse(_blue, radix: 16).toDouble(),
                  //   min: 0,
                  //   max: 255,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _blue = value.toInt().toRadixString(16).padLeft(2, '0');
                  //       _writeData('$_red$_green$_blue');
                  //     });
                  //   },
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Регистрация данных в сервис для контроллеров через GetIt
void _diRegisters() {
  GetIt.I.registerSingleton(SendDataController());
  GetIt.I.registerSingleton(RGBController());
  GetIt.I.registerSingleton(BrightnessController());
}
