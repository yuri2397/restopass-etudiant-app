import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/models/ApiResponse.dart';

import '../constants.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

Future<ApiResponse> sendLink(String email) async{
  String url = BASE_URL + '/api/forgot-password';

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  final body = jsonEncode({
    "email": email,
  });

  ApiResponse res;

  try{
    final response = await http.post(url, body: body, headers: requestHeaders);
    if(response.statusCode == 200){
      final String responseString = response.body;
      res = apiResponseFromJson(responseString);
    }
    else {
      res = ApiResponse(error: true, message: response.statusCode.toString());
    }
    
  }
  catch(e){
    res =  ApiResponse(error: true, message: "500");
  }
  finally{
    // ignore: control_flow_in_finally
    return res;
  }
}

class _ResetPasswordState extends State<ResetPassword> {

  String _message;
  var _image;
  String _text1 = "Mot de passe\nOublié";
  bool _hasErrors = false, _emailError = false, _isLoad = false;
  String _email;
  ApiResponse _apiResponse;

  @override
  void initState() {
    super.initState();
    _image = Image.asset("assets/images/forgot_password.jpg", fit: BoxFit.cover,);
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: height * .30,
                    margin: EdgeInsets.only(top: 50),
                    child: _image
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 30, bottom: 10),
                  child: Text(
                    _text1,
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
                    margin: EdgeInsets.only(left: 30, top: 10),
                    child: _hasErrors ?  Text(
                        _message,
                        style: TextStyle(
                          fontSize: 13,
                         color: Colors.red,
                          fontFamily: "Poppins Meduim",
                        ),
                        textAlign: TextAlign.left,
                    ) : null
                ),
                Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                    child: Form(
                      child: Column(
                        children: <Widget> [
                          TextFormField(
                            autofocus: false,
                            cursorColor: kPrimaryColor,
                            style: TextStyle(color: Colors.black, fontFamily: "Poppins Light", fontWeight: FontWeight.w300),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Adresse email",
                                errorText: _emailError ? "Veuillez saissir votre mot de passe" : null,
                                prefixIcon: Icon(Icons.email, color: kPrimaryColor,size: 30,),
                                border: OutlineInputBorder()
                            ),
                            onChanged: (value){
                              _email = value;
                            },
                          ),
                        ],
                      ),
                    )
                ),
                Container(
                  height: 45,
                  width: width,
                  margin: EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 30),
                  child: RaisedButton(
                    elevation: 3,
                    textColor: Colors.white,
                    color: kPrimaryColor,
                    child: _buttonLoginChild(context) ,
                    onPressed: () async {
                        if(_validator()){
                          setState((){
                            _isLoad = true;
                          });
                          final ApiResponse response = await sendLink(_email);
                          _apiResponse = response;
                          _afterResponse(_apiResponse);
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
    );
  }

  Widget _buttonLoginChild(BuildContext context){
    if(_isLoad){
      return CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
    return Text("Valider");
  }

  bool _validator(){
    bool value = true;
    setState(() {
      _hasErrors = false;
      _emailError = false;
      if(_email == null || _email.isEmpty ){
        _emailError = true;
        value = false;
      }
      else if(!_isMail(_email)){
        _hasErrors = true;
        _message = "Adresse email invalide.";
        value = false;
      }
    });
    return value;
  }

  bool _isMail(String str){
    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(str);
  }

  void _afterResponse(ApiResponse apiResponse) {
    if(apiResponse.error == false){
      _showMyDialog();
    }
    else if(apiResponse.message == "404"){
      _hasErrors = true;
      _message = "Oups, vérifier votre connexion internet." ;
    }
    else if(apiResponse.message == "500"){
      _hasErrors = true;
      _message = "Oups, nous rencontrons quelques problèmes. Veuillez réessayer plus tard.";
    }
    else if(apiResponse.message == "422"){
      _hasErrors = true;
      _message = "Votre adresse email est incorrect.";
    }
    setState((){
      _isLoad = false;
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  child: Icon(
                    Icons.info,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                Text('Un lien de réinitialisation de mot de passe vous a été envoyé par mail. Merci de verifier.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
