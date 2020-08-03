import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hkinfo/BusNotifierApp/busNotifier.dart';
import 'package:hkinfo/CovidApp/covid.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

PageController globalPageController = PageController(initialPage: 1, keepPage: false);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HK Info',
        theme: ThemeData(
          canvasColor: Colors.transparent,
          
          fontFamily: 'Rubik',
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.deepOrange,
          iconTheme: IconThemeData(color: Colors.deepOrange),
          backgroundColor: Colors.blueGrey[50],
          scaffoldBackgroundColor: Colors.white,
          // buttonColor: ,
          buttonTheme: ButtonThemeData(buttonColor: Colors.deepOrange[300].withOpacity(0.5)),
          appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.deepOrange)),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.deepOrange),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: BusNotifierPage(),
        home: PageView(
          controller: globalPageController,
          children: <Widget>[BusNotifierPage(), CovidTracker()],
        ),
        debugShowCheckedModeBanner: false);
  }
}
