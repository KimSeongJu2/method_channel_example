import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Method Channel Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Method Channel Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('kr.co.greendote/methodChannel');
  double _calucatedNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Battery level is :',
            ),
            Text(
              _batteryLevel,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'Calculated number is :',
            ),
            Text(
              '$_calucatedNumber',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: _getBatteryLevel,
            tooltip: 'Get Battery Level',
            child: const Icon(Icons.battery_3_bar),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: _getCalculateResult,
            tooltip: 'Add Number(3 + 4)',
            child: const Icon(Icons.calculate_outlined),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final result = await platform.invokeMethod<int>('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _getCalculateResult() async {
    double? result;
    try {
      result = await platform.invokeMethod<double>('getCalculateResult', {'first': 3.0, 'second': 4.0});
      // result = 'Calculated at $result % .';
    } on PlatformException catch (e) {
      print(e.message);
    }

    setState(() {
      _calucatedNumber = result!;
    });
  }
}
