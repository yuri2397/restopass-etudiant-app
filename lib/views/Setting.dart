import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restopass/constants.dart';
import 'package:restopass/models/AccessToken.dart';
import 'package:restopass/models/ApiResponse.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:http/http.dart' as http;


class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String _message;
  var _isLoad = false;
  String _newPassword, _exPassword, _newPasswordConf;
  String _exMessage, _newMessage, _newConfMessage;
  String _text1 = "Connectez-vous";
  bool _hasErrors = false, _exPasswordError = false, _passwordError = false, _passwordConfError = false;
  static SharedPref _sharedPref;


   @override
  void initState() {
    super.initState();
    _sharedPref = new SharedPref();
  }


  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black,),
        title: Text("Mot de Passe", style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Poppins Light", fontWeight: FontWeight.bold)),
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
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 30, bottom: 5, top: 10),
                child: Text(
                  'Modifier\nMot de passe.',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Poppins Meduim",
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: _hasErrors ? Text(
                      _message,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontFamily: "Poppins Meduim",
                      ),
                      textAlign: TextAlign.left,
                    ) : null
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Form(
                  child: Column(
                    children: <Widget> [
                      TextFormField(
                        autofocus: false,
                        cursorColor: kPrimaryColor,
                        style: TextStyle(color: Colors.black, fontFamily: "Poppins Light", fontWeight: FontWeight.w300),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Mot de passe actuel",
                          errorText: _exPasswordError ? _exMessage : null,
                        ),
                        onChanged: (value){
                          _exPassword = value;
                        },
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        autofocus: false,
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        style: TextStyle(color: Colors.black, fontFamily: "Poppins Light", fontWeight: FontWeight.w300),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelText: "Nouveau mot de passe",
                            errorText: _passwordError ? _newMessage : null,
                        ),
                        onChanged: (value){
                          _newPassword = value;
                        },
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        autofocus: false,
                        obscureText: true,
                        cursorColor: kPrimaryColor,
                        style: TextStyle(color: Colors.black, fontFamily: "Poppins Light", fontWeight: FontWeight.w300),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelText: "Confirmer le nouveau mot de passe",
                            errorText: _passwordConfError ? _newConfMessage : null,
                        ),
                        onChanged: (value){
                          _newPasswordConf = value;
                        },
                      ),
                    ],
                  ),
                )
              ),
            Container(
                height: 45,
                width: width,
                margin: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 20),
                child: RaisedButton(
                  elevation: 3,
                  textColor: Colors.white,
                  color: kPrimaryColor,
                  child: _buttonLoginChild(context) ,
                  onPressed: () async {
                    setState(() {
                      _isLoad = true;
                    });

                    if(_validator()){
                      ApiResponse res = await sendRequest(_exPassword, _newPassword);
                      
                      if(res.error == false){
                        _showSuccessDialog(res.message);
                        setState(() {
                          _isLoad = false;
                        });
                      }
                      else if (res.message == '400'){
                        setState(() {
                          _isLoad = false;
                          _exPasswordError = true;
                          _exMessage = 'Le mot de passe actuel est incorrect.';
                        });
                      }
                      else if( res.message == "401"){
                        _sharedPref.removeSharedPrefs();
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
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
    );
  }


  Widget _buttonLoginChild(BuildContext context){
    if(_isLoad){
      return CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
    return Text("Changer le mot de passe");
  }

  bool _validator(){
    bool value = true;
    setState((){
      _hasErrors = false;
      _passwordError = false;
      _exPasswordError = false;
      _passwordConfError = false;
      if(_exPassword == null || _exPassword.isEmpty){
        _exPasswordError = true;
        _exMessage = 'Donner le mot de passe actuel.';
        value = false;
      }
      else if(_newPassword == null || _newPassword.length < 6){
        _passwordError = true;
        _newMessage = 'Donner un mot de passe d\'au moins 6 caractères.';
        value = false;
      }
      else if(_newPasswordConf == null || _newPasswordConf.length < 6){
        _passwordConfError = true;
        _newConfMessage = 'Donner un mot de passe d\'au moins 6 caractères.';
        value = false;
      }
      else if(_newPasswordConf != _newPassword){
        _passwordConfError = true;
        _newConfMessage = 'Les mots passe ne sont passe identiques.';
        value = false;
      }
    });
    return value;
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



Future<ApiResponse> sendRequest(String currentPassword, String newPassword) async{
  String url = BASE_URL + '/api/user/password/update';
  SharedPref sharedPref = new SharedPref();
  String accessToken = await sharedPref.getUserAccessToken();

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final body = jsonEncode({
    "password": currentPassword,
    'new_password': newPassword,
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