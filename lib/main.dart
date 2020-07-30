import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hkinfo/BusNotifierApp/busNotifier.dart';

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
        title: 'HK Info',
        theme: ThemeData(
          fontFamily: 'Rubik',
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.deepOrange,
          iconTheme: IconThemeData(color: Colors.deepOrange),
          backgroundColor: Colors.blueGrey[50],
          // buttonColor: ,
          buttonTheme: ButtonThemeData(buttonColor: Colors.deepOrange[300].withOpacity(0.5)),
          appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.deepOrange)),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BusNotifierPage(),
        debugShowCheckedModeBanner: false);
  }
}
