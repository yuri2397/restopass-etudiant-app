import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restopass/constants.dart';
import 'package:restopass/models/ApiResponse.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:http/http.dart' as http;

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  var _isLoad = false;
  String? _newPassword, _exPassword;
  String? _exMessage, _newMessage, _newConfMessage;
  bool _exPasswordError = false,
      _passwordError = false,
      _passwordConfError = false;
  static SharedPref? _sharedPref;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _sharedPref = new SharedPref();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Mot de Passe",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: "Poppins Light",
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
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
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Donner le mot de passe actuel.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Mot de passe actuel",
                          errorText: _exPasswordError ? _exMessage : null,
                        ),
                        onChanged: (value) {
                          _exPassword = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
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
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Nouveau mot de passe required.";
                          }
                          if (value != null && value.length < 6) {
                            return "Longueur minimum 6 caracteres.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Nouveau mot de passe",
                          errorText: _passwordError ? _newMessage : null,
                        ),
                        onChanged: (value) {
                          _newPassword = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
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
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Confirmation required.";
                          }
                          if (value != _newPassword) {
                            return "Les mot passes sont différents.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Confirmer votre mot de passe",
                          errorText:
                              _passwordConfError ? _newConfMessage : null,
                        ),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                )),
            Container(
              height: 45,
              width: width,
              margin: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  foregroundColor: Colors.white,
                  backgroundColor: kPrimaryColor,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                ),
                child: _buttonLoginChild(context),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    print("VALIDE");
                    setState(() {
                      _isLoad = true;
                      _exPasswordError = false;
                      _exMessage = "";
                    });
                    ApiResponse? res =
                        await sendRequest(_exPassword!, _newPassword!);

                    if (res != null && res.error == false) {
                      await _showSuccessDialog(res.message!);
                      setState(() {
                        _isLoad = false;
                      });
                      Navigator.pop(context);
                    } else if (res != null && res.message == '400') {
                      setState(() {
                        _isLoad = false;
                        _exPasswordError = true;
                        _exMessage = 'Le mot de passe actuel est incorrect.';
                      });
                    } else if (res != null && res.message == "401") {
                      _sharedPref!.removeSharedPrefs();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false);
                    }
                  }
                },
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buttonLoginChild(BuildContext context) {
    if (_isLoad) {
      return CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
    return Text("Valider");
  }

  Future<void> _showSuccessDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          content: Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.green,
                        size: 40,
                      )),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      message,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins Light',
                          fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )),
          actions: <Widget>[
            TextButton(
              child: Text("Merci",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

Future<ApiResponse?> sendRequest(
    String currentPassword, String newPassword) async {
  String url = BASE_URL + '/api/user/password/update';
  SharedPref sharedPref = new SharedPref();
  String? accessToken = await sharedPref.getUserAccessToken();

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode({
    "password": currentPassword,
    'new_password': newPassword,
  });

  ApiResponse? res;

  try {
    final response =
        await http.post(Uri.parse(url), body: body, headers: requestHeaders);
    if (response.statusCode == 200) {
      final String responseString = response.body;
      res = apiResponseFromJson(responseString);
    } else {
      res = ApiResponse(error: true, message: response.statusCode.toString());
    }
  } catch (e) {
    res = ApiResponse(error: true, message: "500");
  } finally {
    // ignore: control_flow_in_finally
    return res;
  }
}
