import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
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
    }
    else if (response.statusCode == 422){
      return Recipient(error: true, firstName: "Le numéro de dossier saisi est invalide.", lastName: response.statusCode.toString());
    }
    else {
      return Recipient(error: true, firstName: response.body.toString(), lastName: response.statusCode.toString());
    }
  } catch (e) {
    return null;
  } 
}

Future<ApiResponse> transferConfirmation(String recipient, String amount) async {
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
      final String responseString = response.body;
      ApiResponse res = apiResponseFromJson(responseString);
      return res;
    } else if(response.statusCode == 422){
      return ApiResponse(error: true, message: "Le numéro de dossier saisi est invalide.");
    }
    else{
      final String responseString = response.body;
      ApiResponse res = apiResponseFromJson(responseString);
      return res;
    }
  } catch (e) {
    return null;
  } 
}

class _TransferState extends State<Transfer> {

  String _message, _desErrorMessage, _montantErrorMessage;
  bool _isLoad = false, _isconfirm = false;
  String _montant, _desNumber;
  bool _hasErrors = false, _numberError = false, _montantError = false;

  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black,),
        title: Text("Transfert", style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Poppins Light", fontWeight: FontWeight.bold)),
      ),
      body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * .30,
                      child: Image.asset("assets/images/transfer.jpg")
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 30,),
                      child: Text(
                        "Transfert",
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Poppins Meduim",
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                      child: _hasErrors ? Text(
                            _message,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontFamily: "Poppins Meduim",
                            ),
                          ) : null
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 5),
                      child: Form(
                        child: Column(
                          children: <Widget> [
                            TextFormField(
                              autofocus: false,
                              cursorColor: kPrimaryColor,
                              style: TextStyle(color: Colors.black, fontFamily: "Poppins Light", fontWeight: FontWeight.w300),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: "N° dossier destinataire",
                                  errorText: _numberError ? _desErrorMessage : null,
                              ),
                              onChanged: (value){
                                _desNumber = value;
                              },
                            ),
                            SizedBox(height: 30,),
                            TextFormField(
                              autofocus: false,
                              cursorColor: kPrimaryColor,
                              style: TextStyle(color: Colors.black, fontFamily: "Poppins Light", fontWeight: FontWeight.w300),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: "Montant",
                                  errorText: _montantError ? _montantErrorMessage : null,
                              ),
                              onChanged: (value){
                                _montant = value;
                              },
                            ),
                          ],
                        ),
                      )
                    ),
                    Container(
                      height: 45,
                      width: size.width,
                      margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
                      child: RaisedButton(
                        elevation: 3,
                        textColor: Colors.white,
                        color: kPrimaryColor,
                        child: _buttonLoginChild(context) ,
                        onPressed: () async {
                          if(_validator() == true){
                            setState(() {
                              _isLoad = true;
                            });
                            Recipient res = await transfer(_desNumber);
                          
                            setState(() {
                              _isLoad = false;
                            });
                            
                            if(res == null){
                              setState(() {
                                _hasErrors = true;
                                _message = 'Veuillez vérifier votre connexion et réessayer.';
                              });
                              return;
                            }

                            if(res.error == false){
                                _showMyDialog(res);
                            }
                            else{
                              setState(() {
                                _hasErrors = true;
                                _message = res.firstName;
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
                )
              ),
            ),
            _isconfirm ? Container(
              alignment: Alignment.center,
              color: Colors.white60,
              child: progressBar(),
            ) : Container()
          ] 
      ),
    );
  }

  bool _validator(){
    bool value = true;
    setState((){
      _hasErrors = false;
      _numberError = false;
      _montantError = false;
      if(_desNumber == null || _desNumber.isEmpty){
        _numberError = true;
        _desErrorMessage = "N° dossier destinataire requi.";
        value = false;
      }
      if(value)
        int.parse(_desNumber, onError: (string) {
          _numberError = true;
          _desErrorMessage = "Veuillez saisir un nombre.";
          value = false;
          return 0;
        });
      if(_montant == null || _montant.isEmpty){
        _montantError = true;
        _montantErrorMessage = "Montant requi.";
        value = false;
      }
      
      if(value)
      int.parse(_montant, onError: (string) {
        _montantError = true;
        _montantErrorMessage = "Veuillez saisir un nombre.";
        value = false;
        return 0;
      });
    });
    return value;
  }

  Widget _buttonLoginChild(BuildContext context){
    if(_isLoad){
      return CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
    return Text("Transferer");
  }

  Future<void> _showMyDialog(Recipient recipient) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "Détails du transfert",
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins Bold', fontSize: 15),
                    ),
                  Divider(),
                  SizedBox(height: 20,),
                  Text(
                      "Prénom",
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins Bold', fontSize: 13),
                    ),
                  SizedBox(height: 5,),
                  Text(
                      recipient.firstName.toUpperCase(),
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins Meduim', fontSize: 20),
                    ),
                  Divider(),
                  SizedBox(height: 20,),
                  Text(
                      "Nom",
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins Bold', fontSize: 13),
                    ),
                  SizedBox(height: 5,),
                  Text(
                      recipient.lastName.toUpperCase(),
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins Meduim', fontSize: 20),
                    ),
                  Divider(),
                  SizedBox(height: 20,),
                  Text(
                      "Montant",
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins Bold', fontSize: 13),
                    ),
                  SizedBox(height: 5,),
                  Text(
                      _montant.toUpperCase() + ' FCFA',
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins Meduim', fontSize: 20),
                    ),
                ],
              )
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirmer'),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _isconfirm = true;
                  _isLoad = false;
                });
                ApiResponse res = await transferConfirmation(_desNumber, _montant);

                if(res == null){
                  setState(() {
                    _hasErrors = true;
                    _isconfirm = false;
                    _message = 'Veuillez vérifier votre connexion et réessayer.';
                  });
                  return;
                }

                setState(() {
                  _isconfirm = false;
                });

                if(res.error == false){
                  await _showSuccessDialog(res.message);

                }
                else if(res.error == true){
                  setState(() {
                    _hasErrors = true;
                    _message = res.message;
                  });
                }
              },
            ),
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                  Align(alignment: Alignment.topCenter,child: Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 40,)),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left:10, right: 10),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins Light', fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  )
              ],
            )
          ),
          actions: <Widget>[
            TextButton(child: Text("Merci" ,style: TextStyle(color: Colors.black,)),
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