import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restopass/constants.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/models/ApiResponse.dart';
import 'package:restopass/utils/SharedPref.dart';

class Emprunt extends StatefulWidget {
  Emprunt({Key key}) : super(key: key);

  @override
  _EmpruntState createState() => _EmpruntState();
}

class _EmpruntState extends State<Emprunt> {
  
  String _message, _montantErrorMessage;
  bool _hasErrors = false;
  bool _montantError = false;
  String _montant;
  bool _isLoad = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text("Emprunt de ticket",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: "Poppins Light",
                  fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
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
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              autofocus: false,
                              cursorColor: kPrimaryColor,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins Light",
                                  fontWeight: FontWeight.w300),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: "Montant",
                                errorText:
                                    _montantError ? _montantErrorMessage : null,
                              ),
                              onChanged: (value) {
                                _montant = value;
                              },
                            ),
                          ],
                        ),
                      )),
                  Container(
                    height: 45,
                    width: size.width,
                    margin: EdgeInsets.only(
                      top: 20,
                      left: 40,
                      right: 40,
                    ),
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
                          var res = await sendRequest(_montant);
                          print("IN  :" + res.message);
                          if (res.error == false) {
                            setState(() {
                              _isLoad = false;
                            });
                            await _showSuccessDialog(res.message);
                            Navigator.of(context).pop();
                          } else if (res.message != "500") {
                            setState(() {
                              _isLoad = false;
                              _hasErrors = true;
                              _message = res.message;
                            });
                          } else if (res.message == "500") {
                            setState(() {
                              _isLoad = false;
                              _hasErrors = true;
                              _message =
                                  "Vous étes hors ligne, connectez vous et réessayer.";
                            });
                          }
                        }
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ]),
          ),
        ));
  }

  bool _validator() {
    bool value = true;
    setState(() {
      _hasErrors = false;
      _montantError = false;

      if (_montant == null || _montant.isEmpty) {
        _montantError = true;
        _montantErrorMessage = "Montant requi.";
        value = false;
      }

      if (value)
        int.parse(_montant, onError: (string) {
          _montantError = true;
          _montantErrorMessage = "Veuillez saisir un nombre.";
          value = false;
          return 0;
        });
    });
    return value;
  }

  Widget _buttonLoginChild(BuildContext context) {
    if (_isLoad) {
      return CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
    return Text("Confirmer");
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

  Future<ApiResponse> sendRequest(String amount) async {
    String url = BASE_URL + '/api/user/emprunt';
    String accessToken = await new SharedPref().getUserAccessToken();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = jsonEncode({
      "amount": amount,
    });

    ApiResponse res;

    try {
      final response =
          await http.post(url, body: body, headers: requestHeaders);
      print(response.body);
      print("REQUEST CODE : " + response.statusCode.toString());

      final String responseString = response.body;
      res = apiResponseFromJson(responseString);
    } catch (e) {
      print("CATCHA---------------");
      res = ApiResponse(error: true, message: "500");
    } finally {
      // ignore: control_flow_in_finally
      return res;
    }
  }
}
