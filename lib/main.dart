import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:light_house/utils.dart';

void main() {
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
  DiscoveredDevice? device;

  String _red = '00';
  String _green = '00';
  String _blue = '00';

  // void _incrementCounter() async {
  //   final flutterReactiveBle = FlutterReactiveBle();
  //   final stream = flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
  //     if (device.name == 'HMSoft') {
  //       this.device = device;
  //       print(device);
  //       // flutterReactiveBle
  //     }
  //   });
  //   await Future.delayed(Duration(seconds: 2));
  //   stream.cancel();
  //   final stream2 = flutterReactiveBle.connectToDevice(id: device!.id, connectionTimeout: Duration(seconds: 5)).listen(
  //     (event) {
  //       print(event);
  //     },
  //     onError: (error) {
  //       print(error);
  //     },
  //   );
  //
  //   await Future.delayed(Duration(seconds: 10));
  //   final d = await flutterReactiveBle.writeCharacteristicWithoutResponse(
  //       QualifiedCharacteristic(
  //           characteristicId: Uuid.parse('0000ffe1-0000-1000-8000-00805f9b34fb'),
  //           serviceId: device!.serviceUuids.first,
  //           deviceId: device!.id),
  //       value: [0x64, 0x61, 0x73, 0x64, 0x66, 0x31]);
  // }

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
          child: Column(
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
              Text('$_red$_green$_blue x${calcHashSum('$_red$_green$_blue').toRadixString(16).padLeft(2, '0')}'),
              const SizedBox(height: 12),
              Slider(
                activeColor: Colors.red,
                value: int.parse(_red, radix: 16).toDouble(),
                min: 0,
                max: 255,
                onChanged: (value) {
                  setState(() {
                    _red = value.toInt().toRadixString(16).padLeft(2, '0');
                    _writeData('$_red$_green$_blue');
                  });
                },
              ),
              Slider(
                activeColor: Colors.green,
                value: int.parse(_green, radix: 16).toDouble(),
                min: 0,
                max: 255,
                onChanged: (value) {
                  setState(() {
                    _green = value.toInt().toRadixString(16).padLeft(2, '0');
                    _writeData('$_red$_green$_blue');
                  });
                },
              ),
              Slider(
                activeColor: Colors.blue,
                value: int.parse(_blue, radix: 16).toDouble(),
                min: 0,
                max: 255,
                onChanged: (value) {
                  setState(() {
                    _blue = value.toInt().toRadixString(16).padLeft(2, '0');
                    _writeData('$_red$_green$_blue');
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<int> stringToBytes(String input) {
  List<int> bytes = [];

  for (int i = 0; i < input.length; i++) {
    int byte = input.codeUnitAt(i);
    bytes.add(byte);
  }

  return bytes;
}

/// Структура уходящего пакета
/// # - начало строки
/// [data] - полезная нагрузка
/// x%hash_sum% - контрольная сумма пакета, отправляется в виде байта
/// $ - символ окончания строки
void _writeData(String data) {
  FlutterReactiveBle().writeCharacteristicWithoutResponse(
    QualifiedCharacteristic(
      characteristicId: Uuid.parse('0000ffe1-0000-1000-8000-00805f9b34fb'),
      serviceId: Uuid.parse('0000ffe0-0000-1000-8000-00805f9b34fb'),
      deviceId: 'F0:C7:7F:B0:9C:BE',
    ),
    value: stringToBytes('#${data}x${calcHashSum(data).toRadixString(16).padLeft(2, '0')}\$'),
  );
}
