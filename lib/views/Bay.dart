import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restopass/constants.dart';
import 'package:restopass/models/ApiResponse.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/models/PaydunyaResponse.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/views/paydunya.dart';

class Bay extends StatefulWidget {
  static const String routeName = '/bay';

  Bay({Key key}) : super(key: key);

  @override
  _BayState createState() => _BayState();
}

class _BayState extends State<Bay> {
  String _message, _montantErrorMessage;
  bool _hasErrors = false;
  bool _montantError = false;
  String _montant;
  bool _isLoad = false;
  final double _cardRadius = 15.0;
  String _telErrorMessage = "Tel Error";
  bool _telHasErrors = false;
  String _tel;
  final _formKey = GlobalKey<FormState>();
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
          title: Text("Rechargement",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: "Poppins Light",
                  fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(child: Image.asset("assets/images/achat.jpg")),
              Container(
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Text(
                  "Recharger\nVotre compte",
                  style: TextStyle(fontFamily: "Poppins Bold", fontSize: 20),
                ),
              ),
              Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 20.0, bottom: 10.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              autofocus: false,
                              cursorColor: kPrimaryColor,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins Light",
                                  fontWeight: FontWeight.w300),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Numéro de téléphone",
                                errorText:
                                    _telHasErrors ? _telErrorMessage : null,
                              ),
                              onChanged: (value) {
                                _tel = value;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              autofocus: false,
                              cursorColor: kPrimaryColor,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins Light",
                                  fontWeight: FontWeight.w300),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Montant de rechargement",
                                errorText:
                                    _montantError ? _montantErrorMessage : null,
                              ),
                              onChanged: (value) {
                                _montant = value;
                              },
                            ),
                          ],
                        )),
                  )),
              Container(
                height: 45,
                width: size.width,
                margin:
                    EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
                child: RaisedButton(
                  elevation: 3,
                  textColor: Colors.white,
                  color: kPrimaryColor,
                  child: _buttonLoginChild(context),
                  onPressed: () async {
                    if (_validate()) {
                      setState(() {
                        _isLoad = true;
                      });
                      print("SEND REQUEST");
                      PayDunyaResponse res = await _sendRequest(_tel, _montant);
                      setState(() {
                        _isLoad = false;
                      });
                      print("RES : " + res.toString());
                      if (res.responseText == "error") {
                        final snackBar =
                            SnackBar(content: Text(res.responseText));
                        Scaffold.of(context).showSnackBar(snackBar);
                      } else
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (contenxt) => PayDunya(res.responseText)));
                    }
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  bool _validate() {
    setState(() {
      _telHasErrors = _montantError = false;
    });
    bool value = true;
    Pattern pattern = r'^(7?)[0-9]{9}$';
    RegExp regex = new RegExp(pattern);
    if (_montant == null || _montant.length == 0) {
      setState(() {
        _montantError = true;
        _montantErrorMessage = "Montant requis.";
      });
      value = false;
    } else
      int.parse(_montant, onError: (string) {
        setState(() {
          _montantError = true;
          _montantErrorMessage = "Montant invalide.";
        });
        value = false;
        return -1;
      });
    if (_tel == null || _tel.length == 0) {
      setState(() {
        _telHasErrors = true;
        _telErrorMessage = "Téléphone requis.";
      });
      value = false;
    } else if (!regex.hasMatch(_tel) || _tel.length != 9) {
      setState(() {
        _telHasErrors = true;
        _telErrorMessage = "Téléphone invalide.";
      });
      value = false;
    }
    return value;
  }

  Future<PayDunyaResponse> _sendRequest(String tel, String montant) async {
    String url = BASE_URL + '/api/pay';
    String accessToken = await new SharedPref().getUserAccessToken();

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = jsonEncode({
      "tel": tel,
      "amount": montant,
    });

    PayDunyaResponse res;

    try {
      final response =
          await http.post(url, body: body, headers: requestHeaders);
      print("RRRR : " + response.body);
      if (response.statusCode == 200) {
        final String responseString = response.body;
        res = payDunyaResponseFromJson(responseString);
      }
    } catch (e) {
      res = PayDunyaResponse(
          description: 'error',
          responseCode: 'error',
          responseText: 'error',
          token: 'error');
    } finally {
      // ignore: control_flow_in_finally
      return res;
    }
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
}
