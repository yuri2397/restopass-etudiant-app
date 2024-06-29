import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/views/Login.dart';
import 'package:restopass/views/Profile.dart';
import 'package:restopass/views/Welcome.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPref? _pref;

  @override
  void initState() {
    super.initState();
    _pref = new SharedPref();
  }

  @override
  Widget build(BuildContext context) {

    Timer(Duration(seconds: 2), () async{
      bool firstTime = await _pref!.getFirstTime();
      bool login = await _pref!.isLogin();
      Widget w = Login();
      if(login){
        w = Profile();
      }
      else if(!firstTime){
        w = Intro();
      }
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => w
          )
      );
    }
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/logo.jpg', ),
      ),
    );
  }
}
