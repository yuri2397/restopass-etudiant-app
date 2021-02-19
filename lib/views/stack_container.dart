import 'package:flutter/material.dart';
import 'package:restopass/models/User.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/views/Code.dart';
import 'package:restopass/views/Profile.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class StackContainer extends StatefulWidget {
  final User user;

  const StackContainer({Key key, this.user}) : super(key: key);

  @override
  _StackContainerState createState() => _StackContainerState();
}

class _StackContainerState extends State<StackContainer> {
  SharedPref _pref;
  String _fullName;
  Widget _alert;
  Size size;
  bool _isReload = false;
  @override
  void initState() {
    super.initState();
    _alert = Container();
    _pref = SharedPref();
  }

  @override
  void didUpdateWidget(StackContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    onPayTop();
  }

  @override
  Widget build(BuildContext context) {
    String f = capitalize(widget.user.firstName);
    String l = capitalize(widget.user.lastName);
    if (f.length > 10) {
      f = f.substring(0, 1) + '.';
    }
    _fullName = f + ' ' + l;
    size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /* Prenom Nom et Solde */
                Container(
                  width: size.width,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Material(
                    borderRadius: BorderRadius.circular(8.0),
                    color: kPrimaryColor,
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                        onTap: () async {
                                          int number =
                                              await _pref.getUserNumber();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Code(
                                                        number:
                                                            number.toString(),
                                                      )));
                                        },
                                        child: CircleAvatar(
                                          child: Icon(Icons.qr_code,
                                              color: kPrimaryColor),
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      _fullName,
                                      style: TextStyle(
                                          fontFamily: 'Poppins Light',
                                          color: Colors.white,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () async {
                                      onPayTop();
                                    },
                                    child: Text(
                                      widget.user.pay.toString() + ' FCFA',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily: 'Poppins Meduim',
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ]),
                          _isReload ? progressBar() : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
                // Fin de Prenom Nom solde
                SizedBox(height: 10),
                _alert,
              ],
            ),
          ),
        ],
      ),
    );
  }

  onPayTop() async {
    setState(() {
      _isReload = true;
    });
    int pay = await reloadPay();
    if (pay == -1) {
      setState(() {
        _alert = Container(
          width: size.width,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              height: 100,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      child: Icon(
                        Icons.wifi_off_rounded,
                        color: Colors.white,
                      )),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Vous êtes actuellement hors ligne. Le solde de votre compte peut être obsoléte.",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins Light',
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        _isReload = false;
      });
    } else if (pay == -401) {
      SharedPref shar = new SharedPref();
      shar.removeSharedPrefs();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      return;
    } else if (pay <= -400) {
      setState(() {
        _alert = Container(
          width: size.width,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              height: 100,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      child: Icon(
                        Icons.error_outline_outlined,
                        color: Colors.white,
                      )),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Nous rencontrons quelques petits problèmes. Veuillez réessayer plus tard.",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins Light',
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        _isReload = false;
      });

      return;
    } else if (pay == -401) {
      SharedPref shar = new SharedPref();
      shar.removeSharedPrefs();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      return;
    } else
      setState(() {
        _pref.setUserPay(pay);
        widget.user.pay = pay;
        _alert = Container();
        _isReload = false;
      });
  }
} // fin de la class

String capitalize(String text) {
  return text.substring(0, 1).toUpperCase() +
      text.substring(1, text.length).toLowerCase();
}

Future<int> reloadPay() async {
  String url = BASE_URL + '/api/user/bay';
  SharedPref sharedPref = new SharedPref();
  String accessToken = await sharedPref.getUserAccessToken();

  Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  int pay;

  try {
    final response = await http.get(url, headers: requestHeaders);
    print("RESSSSS : " + response.statusCode.toString());
    if (response.statusCode == 200) {
      pay = int.parse(response.body);
    } else {
      pay = -response.statusCode;
    }
  } catch (e) {
    pay = -1;
  } finally {
    // ignore: control_flow_in_finally
    return pay;
  }
}
