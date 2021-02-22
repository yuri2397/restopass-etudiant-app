import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/models/ApiResponse.dart';
import 'package:restopass/models/Recipient.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/CustomDialog.dart';
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

  // VARIABLE POUR LE BOTTOMSHEET TRANSFER
  String _montant, _desNumber;
  bool _close = false;
  TextEditingController numberController = TextEditingController();
  User _user;
  bool _montantError;
  String _montantErrorMessage;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    myFuture = getUser();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
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
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            _controller.forward(from: 0.0);
            return Material(
              color: Colors.white,
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
                        children: [
                          Icon(
                            Icons.perm_scan_wifi,
                            color: Colors.black,
                            size: 35,
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 30),
                            child: Text(
                              "Veuillez vérifier votre connexion internet et réessayer.",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontFamily: 'Poppins Light',
                                  fontSize: 15),
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
                        ]),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return _mainWidget(snapshot.data, context);
          } else {
            return Center(
              child: Text("VIDE"),
            );
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
      });

  Widget _mainWidget(User user, context) {
    _pref.addUserEmail(user.email);
    _pref.addUserFirstName(user.firstName);
    _pref.addUserLastName(user.lastName);
    _pref.addUserNubmer(user.number);
    _pref.addUserPay(user.pay);
    _user = user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu_open_rounded),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Option()));
              },
            );
          },
        ),
        iconTheme: IconThemeData(
          color: kPrimaryColor,
        ),
        title: Text("RestoPass",
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 25,
                fontFamily: "Poppins Light",
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StackContainer(
                user: user,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _createCardButton(
                      context: context,
                      text: "Emprunt",
                      imagePath: "assets/images/lifeguard.svg",
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Emprunt()));
                      },
                    ),
                    SizedBox(width: 20),
                    _createCardButton(
                      context: context,
                      text: "Rechargement",
                      imagePath: "assets/images/wallet.svg",
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Bay()));
                      },
                    ),
                  ]),
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
                      onTap: () {
                        _showBottomSheetTransfer(context);
                      },
                    ),
                    SizedBox(width: 20),
                    _createCardButton(
                      context: context,
                      text: "Historique",
                      imagePath: "assets/images/list.svg",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListTransfer()));
                      },
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createCardButton(
      {context, String text, String imagePath, GestureTapCallback onTap}) {
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
                    child: SvgPicture.asset(
                      imagePath,
                      width: 40,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontFamily: "Poppins Meduim",
                        fontSize: 13),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  void _showBottomSheetTransfer(context) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Text("Transfert",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: "Poppins Light",
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      cursorColor: kPrimaryColor,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Poppins Light",
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(hintText: 'Déstinataire'),
                      autofocus: false,
                      validator: (String value) {
                        Pattern pattern = r'^[0-9]{11}$';
                        RegExp regex = new RegExp(pattern);
                        if (value.isEmpty) {
                          return 'N° de dossier requis.';
                        }
                        if (!regex.hasMatch(value)) {
                          return "N° de dossier invalide.";
                        }
                        if (_user.number.toString() == value) {
                          return "Donner un autre numéro.";
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        _desNumber = value;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      cursorColor: kPrimaryColor,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Poppins Light",
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(hintText: 'Montant'),
                      autofocus: false,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Montant requis.';
                        }
                        int test = int.parse(value, onError: (string) {
                          return -1;
                        });
                        print("TEST : $test");
                        if (test <= -1) {
                          return "Montant invalide.";
                        }
                        if (test < 50) {
                          return "Montant minimum est 50f";
                        }
                        if (test % 50 != 0) {
                          return "Montant n'est pas un multiple de 50";
                        }
                        if (_user.pay < test) {
                          return "Montant insiffusant";
                        }
                        return null;
                      },
                      onChanged: (String value) {
                        _montant = value;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        margin: EdgeInsets.only(top: 15, bottom: 20),
                        child: RaisedButton(
                          color: kPrimaryColor,
                          child: Text("Valider",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins Light")),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              showLoaderDialog(context);
                              Recipient recipient = await transfer(_desNumber);
                              Navigator.pop(context);
                              if (recipient == null) {
                                print("NULLLLLLLLLLLLLLLLLLLLLL");
                                Fluttertoast.showToast(
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                    msg: "Vérifier votre connexion internet.",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1);
                              } else
                                _transferConfDialog(
                                    context, recipient, _montant);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  bool _validateTransferForm() {
    _montantError = false;
    _montantErrorMessage = "";
  }

  static shrink(Animation<double> _animation,
      Animation<double> _secondaryAnimation, Widget _child) {
    return ScaleTransition(
      child: _child,
      scale: Tween<double>(end: 1.0, begin: 1.2).animate(CurvedAnimation(
          parent: _animation,
          curve: Interval(0.50, 1.00, curve: Curves.linear))),
    );
  }

  _transferConfDialog(context, Recipient recipient, String amount) {
    return showGeneralDialog(
      context: context,
      barrierLabel: '',
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, _animation, _secondaryAnimation, _child) {
        return shrink(_animation, _secondaryAnimation, _child);
      },
      pageBuilder: (_animation, _secondaryAnimation, _child) {
        return CustomDialog(
          onClick: (bool response) async {
            if (response) {
              ApiResponse res =
                  await transferConfirmation(_desNumber, _montant);
              return res;
            }
          },
          recipient: recipient,
          amount: amount,
        );
      },
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          progressBar(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text("Traitement en cour...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: _close,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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

Future<Recipient> transfer(String recipient) async {
  String url = BASE_URL + '/api/user/transfer';
  String accessToken = await new SharedPref().getUserAccessToken();

  Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode({
    "recipient": recipient,
  });

  try {
    final response = await http.post(url, body: body, headers: requestHeaders);

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Recipient res = recipientFromJson(responseString);
      return res;
    } else if (response.statusCode == 422) {
      return Recipient(
          error: true,
          firstName: "Ce numero n'existe pas.",
          lastName: response.statusCode.toString());
    } else if (response.statusCode == 404) {
      return null;
    } else {
      return Recipient(
          error: true,
          firstName: response.body.toString(),
          lastName: response.statusCode.toString());
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<ApiResponse> transferConfirmation(
    String recipient, String amount) async {
  String url = BASE_URL + '/api/user/confirm';
  String accessToken = await new SharedPref().getUserAccessToken();

  Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode({
    "recipient": recipient,
    "amount": amount,
  });

  try {
    final response = await http.post(url, body: body, headers: requestHeaders);
    if (response.statusCode == 200) {
      print("RES CONF : " + response.body);
      final String responseString = response.body;
      ApiResponse res = apiResponseFromJson(responseString);
      return res;
    } else if (response.statusCode == 422) {
      return ApiResponse(
          error: true, message: "Le numéro de dossier saisi est invalide.");
    } else if (response.statusCode == 404) {
      return null;
    } else {
      final String responseString = response.body;
      ApiResponse res = apiResponseFromJson(responseString);
      return res;
    }
  } catch (e) {
    return null;
  }
}

Future<User> getUser() async {
  String url = BASE_URL + '/api/user/profile';

  SharedPref sharedPref = new SharedPref();
  String email = await sharedPref.getUserEmail();

  if (email != null) {
    String f = await sharedPref.getUserFirstName();
    String l = await sharedPref.getUserLastName();
    int n = await sharedPref.getUserNumber();
    int p = await sharedPref.getUserPay();
    User s =
        new User(email: email, firstName: f, lastName: l, number: n, pay: p);
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
