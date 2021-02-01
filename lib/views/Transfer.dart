import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:restopass/models/ApiResponse.dart';
import 'package:restopass/models/Recipient.dart';
import 'package:restopass/utils/SharedPref.dart';

import '../constants.dart';
import 'Profile.dart';

class Transfer extends StatefulWidget {
  static const String routeName = '/transfer';

  Transfer({Key key}) : super(key: key);

  @override
  _TransferState createState() => _TransferState();
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

class _TransferState extends State<Transfer> {
  String _desErrorMessage, _montantErrorMessage;
  bool _isLoad = false, _isconfirm = false;
  String _montant, _desNumber;
  bool _numberError = false, _montantError = false;
  static bool _isConf = false;
  SharedPref _pref;

  @override
  void initState() {
    super.initState();
    this._pref = SharedPref();
  }

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
        title: Text("Transfert",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: "Poppins Light",
                fontWeight: FontWeight.bold)),
      ),
      body: Stack(children: [
        Container(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
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
                            labelText: "N° dossier destinataire",
                            errorText: _numberError ? _desErrorMessage : null,
                          ),
                          onChanged: (value) {
                            _desNumber = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                child: RaisedButton(
                  elevation: 3,
                  textColor: Colors.white,
                  color: kPrimaryColor,
                  child: _buttonLoginChild(context),
                  onPressed: () async {
                    bool val = await _validator();
                    if (val == true) {
                      setState(() {
                        _isLoad = true;
                      });
                      Recipient res = await transfer(_desNumber);

                      setState(() {
                        _isLoad = false;
                      });
                      // Error de connexion internet
                      if (res == null) {
                        Fluttertoast.showToast(
                            msg: "Veuillez vérifier votre connexion.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 13.0);
                        return;
                      }

                      if (res.error == false) {
                        await showMaterialModalBottomSheet<void>(
                          isDismissible: false,
                          enableDrag: false,
                          elevation: 10,
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: Container(child: recipientInfo(res)),
                            );
                          },
                        );
                        if (_isConf) transferConf();
                      } else {
                        setState(() {
                          _desErrorMessage = res.firstName;
                          _numberError = true;
                        });
                      }
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
        _isconfirm
            ? Container(
                alignment: Alignment.center,
                color: Colors.white60,
                child: progressBar(),
              )
            : Container()
      ]),
    );
  }

// VALIDATION DES DONNEES
  Future<bool> _validator() async {
    bool value = true;

    String currentUserNumber = (await _pref.getUserNumber()).toString();
    int amount = (await _pref.getUserPay());
    setState(() {
      _numberError = false;
      _montantError = false;
      if (_desNumber == null || _desNumber.isEmpty) {
        _numberError = true;
        _desErrorMessage = "N° dossier destinataire requi.";
        value = false;
      } else if (_desNumber == currentUserNumber) {
        _numberError = true;
        _desErrorMessage = "Ce numéro est le votre.";
        value = false;
      }
      if (value)
        int.parse(_desNumber, onError: (string) {
          _numberError = true;
          _desErrorMessage = "Veuillez saisir un nombre.";
          value = false;
          return 0;
        });
      if (_montant == null || _montant.isEmpty) {
        _montantError = true;
        _montantErrorMessage = "Montant requi.";
        value = false;
      }
      int m = 0;

      if (value)
        m = int.parse(_montant, onError: (string) {
          _montantError = true;
          _montantErrorMessage = "Veuillez saisir un nombre.";
          value = false;
          return 0;
        });
      if (m > amount) {
        _montantError = true;
        _montantErrorMessage = "Solde insuffisant.";
        value = false;
      }
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
    return Text("Transferer");
  }

  Future<void> transferConf() async {
    setState(() {
      _isconfirm = true;
      _isLoad = false;
    });
    ApiResponse res = await transferConfirmation(_desNumber, _montant);

    setState(() {
      _isconfirm = false;
    });

    if (res == null) {
      Fluttertoast.showToast(
          msg: "Veuillez vérifier votre connexion.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      _isconfirm = false;
      return;
    }

    if (res.error == false) {
      Navigator.of(context).pop();
    } else if (res.error == true) {
      Fluttertoast.showToast(
          msg: "Veuillez vérifier votre connexion.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget recipientInfo(
    Recipient res,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              width: 80,
              height: 15,
              alignment: Alignment.center,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                "Transferer",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins Bold",
                ),
                textAlign: TextAlign.center,
              )),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
            child: Text(
              "À",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Poppins Light",
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            width: double.infinity,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 0, left: 20.0, right: 20.0),
            child: Text(
              res.firstName + ' ' + res.lastName,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Poppins Meduim",
                color: Colors.black38,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
            child: Text(
              "Montant",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Poppins Light",
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
            child: Text(
              _montant + " FCFA",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Poppins Meduim",
                color: Colors.black38,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: RaisedButton(
                    color: kPrimaryColor,
                    child: Text("Je confirme",
                        style: TextStyle(
                            color: Colors.white, fontFamily: "Poppins Light")),
                    onPressed: () {
                      setState(() {
                        _isConf = true;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: FlatButton(
                    child: Text("Annuler",
                        style: TextStyle(
                          fontFamily: 'Poppins Light',
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () {
                      setState(() {
                        _isConf = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
