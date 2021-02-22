import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restopass/constants.dart';
import 'package:restopass/views/Bay.dart';
import 'package:restopass/views/Code.dart';
import 'package:restopass/views/List.dart';
import 'package:restopass/views/Login.dart';
import 'package:restopass/views/Setting.dart';
import 'package:restopass/views/Transfer.dart';
import 'package:restopass/views/Profile.dart';
import 'package:restopass/views/SplashScreen.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() {
  initializeDateFormatting('fr_FR', null).then((value) => runApp(MyApp()));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/profile': (context) => Profile(),
        '/transfer': (context) => Transfer(),
        '/settings': (context) => Setting(),
        '/bay': (context) => Bay(),
        '/code': (context) => Code(),
        '/historic': (context) => ListTransfer(),
        '/login': (context) => Login(),
      },
      debugShowCheckedModeBanner: false,
      title: 'RestoPass',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.transparent,
      ),
    );
  }
}
