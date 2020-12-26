import 'package:flutter/material.dart';

class Bay extends StatefulWidget {
  static const String routeName = '/bay';

  Bay({Key key}) : super(key: key);

  @override
  _BayState createState() => _BayState();
}

class _BayState extends State<Bay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black,),
        title: Text("Rechargement", style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Poppins Light", fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Text("Rechargement") 
      )
    );
  }
}