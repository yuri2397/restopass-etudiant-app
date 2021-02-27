import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'Setting.dart';

class Option extends StatefulWidget {
  Option({Key key}) : super(key: key);

  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {
  static const String serviceNumber = "+221771234567";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins Meduim',
                fontWeight: FontWeight.bold)),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            alignment: Alignment.topLeft,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => UrlLauncher.launch('tel://' + serviceNumber),
                    child: Row(
                      children: [
                        Icon(Icons.support_agent_rounded),
                        SizedBox(width: 15),
                        Text(
                          'Appelez le service client',
                          style: TextStyle(
                              fontFamily: 'Poppins Light',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Setting()));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.security_rounded),
                        SizedBox(width: 15),
                        Text(
                          'Changer votre mot de passe',
                          style: TextStyle(
                              fontFamily: 'Poppins Light',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text("Confirmation"),
                                content: Text("Voulez-vous vous déconnecter?"),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Non"),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      SharedPref shar = new SharedPref();
                                      shar.removeSharedPrefs();
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/login',
                                              (Route<dynamic> route) => false);
                                    },
                                    child: Text("Oui"),
                                  )
                                ],
                                elevation: 25.0,
                              ));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 15),
                        Text(
                          'Se déconnecter',
                          style: TextStyle(
                              fontFamily: 'Poppins Light',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ])),
        Container(
            padding: EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Created by iris softech'),
                Text('Version 1.0.0'),
              ],
            ))
      ]),
    );
  }
}
