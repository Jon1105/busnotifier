import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'BusNotifierApp/busNotifier.dart';
import 'CovidApp/covid.dart';
import 'CovidApp/hk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Notifier App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: BusNotifierPage(),
        // ! For testing purposes
        home: CovidTracker(hk),
        debugShowCheckedModeBanner: false);
  }
}

