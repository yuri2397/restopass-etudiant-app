import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/views/Bay.dart';
import 'package:restopass/views/Emprunt.dart';
import 'package:restopass/views/Login.dart';
import 'package:restopass/views/Code.dart';
import 'package:restopass/views/Options.dart';
import 'package:restopass/views/Setting.dart';
import 'package:restopass/views/Transfer.dart';
import 'package:restopass/views/stack_container.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../constants.dart';
import 'List.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  
  SharedPref _pref;
  Future<User> myFuture;
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    myFuture = getUser();
    _controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _pref = new SharedPref();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => getUserData();

  FutureBuilder getUserData() => FutureBuilder(
        future: myFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              _controller.forward(from: 0.0);
              return Material(
                child: Container(
                  margin: const EdgeInsets.only(top: 36.0),
                  width: double.infinity,
                  child: FadeTransition(
                    opacity: _animation,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Icon(Icons.perm_scan_wifi, color: Colors.black, size: 35, ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 30),
                            child: Text("Veuillez vérifier votre connexion internet et réessayer.",
                              style: TextStyle(color: Colors.black38, fontFamily: 'Poppins Light', fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 15),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                myFuture = getUser();
                              });
                            },
                            child: Text(
                              "Réessayer",
                            ),
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              );
            }
            else if(snapshot.hasData){
              return _mainWidget(snapshot.data, context);
            }
            else{
              return Center(child: Text("VIDE"),);
            }
          } else {
            return Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: progressBar(),
              ),
            );
          }
        }
      );

  Widget _mainWidget(User user, context) {
    _pref.addUserEmail(user.email);
    _pref.addUserFirstName(user.firstName);
    _pref.addUserLastName(user.lastName);
    _pref.addUserNubmer(user.number);
    _pref.addUserPay(user.pay);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu_open_rounded),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Option()));
              },
            );
          },
        ),
        iconTheme: IconThemeData(color: kPrimaryColor,),
        title: Text("RestoPass", style: TextStyle(color: kPrimaryColor, fontSize: 25, fontFamily: "Poppins Light", fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StackContainer(
                user: user,
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _createCardButton(
                    context: context,
                    text: "Emprunt",
                    imagePath: "assets/images/lifeguard.svg",
                    onTap: ()  {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Emprunt()));
                    },
                  ),
                  SizedBox(width: 20),
                  _createCardButton(
                    context: context,
                    text: "Rechargement",
                    imagePath: "assets/images/wallet.svg",
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Bay()));
                    },
                  ),
                ]
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _createCardButton(
                    context: context,
                    text: "Transfet",
                    imagePath: "assets/images/money-transfer.svg",
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Transfer()));
                    },
                  ),
                  SizedBox(width: 20),
                  _createCardButton(
                    context: context,
                    text: "Historique",
                    imagePath: "assets/images/list.svg",
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListTransfer()));
                    },
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createCardButton({context, String text, String imagePath, GestureTapCallback onTap}){
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height / 5.5,
        width: size.width / 2.5,
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(imagePath, width: 40, color: kPrimaryColor,), 
              ),
              SizedBox(height: 10,),
              Text(
                text,
                style: TextStyle(color: kPrimaryColor, fontFamily: "Poppins Meduim", fontSize: 13),
              ),
            ]
            ),
          ),
        ),
      ),
    );
  }
}

Widget progressBar() {
  return Container(
    height: 50,
    width: 50,
    alignment: Alignment.center,
    child: SleekCircularSlider(
      initialValue: 10,
      max: 100,
      appearance: CircularSliderAppearance(
          angleRange: 360,
          spinnerMode: true,
          startAngle: 90,
          size: 40,
          customColors: CustomSliderColors(
            hideShadow: true,
            progressBarColor: kPrimaryColor,
          )),
    ),
  );
}

Future<User> getUser() async {
  String url = BASE_URL + '/api/user/profile';
  
  SharedPref sharedPref = new SharedPref();
  String email = await sharedPref.getUserEmail();
  
  if(email != null){
    String f = await sharedPref.getUserFirstName();
    String l = await sharedPref.getUserLastName();
    int n = await sharedPref.getUserNumber();
    int p = await sharedPref.getUserPay();
    User s = new User(email: email, firstName: f, lastName: l, number: n, pay: p);
    return s;
  }

  String accessToken = await sharedPref.getUserAccessToken();

  Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  User user;

  try {
    final response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      final String responseString = response.body;
      user = userFromJson(responseString);
    
    } else {
      String code = response.statusCode.toString();
      user = User(
          email: code,
          number: response.statusCode,
          firstName: code,
          lastName: code,
          pay: response.statusCode);
    }
  } catch (e) {
    user = User();
  } finally {
    // ignore: control_flow_in_finally
    return user;
  }

}


