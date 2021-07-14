import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restopass/constants.dart';
import 'package:restopass/models/AccessToken.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/utils/SharedPref.dart';

import 'Profile.dart';
import 'ResetPassword.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

Future<AccessToken> loginRequest(String number, String password) async {
  String url = BASE_URL + '/api/user/login';

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  final body = jsonEncode({
    "number": number,
    "password": password,
  });

  try {
    final response = await http.post(url, body: body, headers: requestHeaders);
    if (response.statusCode == 200) {
      final String responseString = response.body;
      return accessTokenFromJson(responseString);
    } else {
      return AccessToken(
          tokenType: "error",
          expiresIn: -1,
          accessToken: response.statusCode.toString(),
          refreshToken: response.statusCode.toString());
    }
  } catch (e) {
    return AccessToken(
        tokenType: "error",
        expiresIn: -2,
        accessToken: "500",
        refreshToken: "500");
  }
}

class _LoginState extends State<Login> {
  var _image;
  AccessToken _accessToken;
  String _message;
  var _isLoad = false;
  String _password, _number;
  bool _hasErrors = false, _numberError = false, _passwordError = false;
  static SharedPref _sharedPref;

  @override
  void initState() {
    super.initState();
    _sharedPref = new SharedPref();
    _image = Image.asset(
      "assets/images/login.jpg",
      fit: BoxFit.cover,
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: height * .35,
                margin: EdgeInsets.only(top: 20),
                child: _image),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 30, bottom: 10),
              child: Text(
                "Connectez-vous !",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Poppins Meduim",
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: _hasErrors
                    ? Text(
                        _message,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                          fontFamily: "Poppins Meduim",
                        ),
                      )
                    : null),
            Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autofocus: false,
                        cursorColor: kPrimaryColor,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins Light",
                            fontWeight: FontWeight.w300),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Numéro de dossier",
                            errorText:
                                _numberError ? "N° de dossier requi" : null,
                            prefixIcon: Icon(
                              Icons.person_outline_sharp,
                              color: kPrimaryColor,
                              size: 30,
                            ),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          _number = value;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autofocus: false,
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins Light",
                            fontWeight: FontWeight.w300),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelText: "Mot de passe",
                            errorText:
                                _passwordError ? "Mot de passe requi" : null,
                            prefixIcon: Icon(
                              Icons.lock_open,
                              color: kPrimaryColor,
                              size: 30,
                            ),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                    ],
                  ),
                )),
            Container(
              width: width,
              margin: EdgeInsets.only(left: 30, right: 30),
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ResetPassword()));
                },
                child: Text(
                  "Mot de passe oublié?",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 13,
                    fontFamily: "Poppins Light",
                    decoration: TextDecoration.underline
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              height: 45,
              width: width,
              margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
              child: RaisedButton(
                elevation: 3,
                textColor: Colors.white,
                color: kPrimaryColor,
                child: _buttonLoginChild(context),
                onPressed: () async {
                  if (_validator()) {
                    setState(() {
                      _isLoad = true;
                    });
                    final AccessToken tmp =
                        await loginRequest(_number, _password);
                    _accessToken = tmp;
                    _login(_accessToken);
                  }
                },
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  bool _validator() {
    bool value = true;
    setState(() {
      _hasErrors = false;
      _numberError = false;
      _passwordError = false;
      if (_number == null || _number.isEmpty) {
        _numberError = true;
        value = false;
      } else if (_password == null || _password.isEmpty) {
        _passwordError = true;
        value = false;
      }
    });
    return value;
  }

  void _login(AccessToken accessToken) {
    if (accessToken.expiresIn >= 0) {
      _sharedPref.addUserAccessToken(accessToken.accessToken);
      _sharedPref.addUserRefreshToken(accessToken.refreshToken);
      _sharedPref.addUserExpireIn(accessToken.expiresIn);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Profile()));
    } else if (accessToken.tokenType == "error") {
      if (accessToken.accessToken == "400" ||
          accessToken.accessToken == "422") {
        _hasErrors = true;
        _message = "N° de dossier ou mot passe invalide";
      } else if (int.parse(accessToken.refreshToken) >= 500 ||
          accessToken.accessToken == "400" ||
          accessToken.accessToken == "404") {
        _hasErrors = true;
        _message = "Vérifier votre connexion internet.";
      }
    }

    setState(() {
      _isLoad = false;
    });
  }

  Widget _buttonLoginChild(BuildContext context) {
    if (_isLoad) {
      return CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
    return Text("Se connecter");
  }
}
