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
          primaryColor: Color(0xFF09B3A2),
          iconTheme: IconThemeData(color: Colors.white),
          // buttonColor: ,
          buttonTheme: ButtonThemeData(buttonColor: Colors.deepOrange[300].withOpacity(0.5)),
          appBarTheme: AppBarTheme(color: Colors.white),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: ,
        // ! For testing purposes
        home: BusNotifierPage(),
        debugShowCheckedModeBanner: false);
  }
}
