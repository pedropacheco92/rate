import 'package:flutter/material.dart';
import 'package:rate/rate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rate Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              const Text('Default Rate', style: TextStyle(fontSize: 20)),
              const Rate(),
              const Spacer(),
              const Text(
                'Different size and color',
                style: TextStyle(fontSize: 20),
              ),
              Rate(
                iconSize: 40,
                color: Colors.green,
                allowHalf: true,
                allowClear: true,
                initialValue: 3.5,
                readOnly: false,
                // ignore: avoid_print
                onChange: (value) => print(value),
              ),
              const Spacer(),
              const Text('Custom Icons', style: TextStyle(fontSize: 20)),
              Rate(iconBuilder: _customIconBuilder),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Icon _customIconBuilder(double value, int index) {
    var icon =
        value > index.toDouble() ? Icons.favorite : Icons.favorite_border;

    return Icon(icon, color: Colors.red);
  }
}
