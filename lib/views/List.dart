import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restopass/models/Passage.dart';
import 'package:restopass/models/Rechargement.dart';
import 'package:restopass/models/Tranfer.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/views/card_item_passage.dart';
import 'package:restopass/views/card_item_rechargement.dart';
import 'Profile.dart';

import '../constants.dart';
import 'card_item.dart';

class ListTransfer extends StatefulWidget {
  ListTransfer({
    Key key,
  }) : super(key: key);

  @override
  _ListTransferState createState() => _ListTransferState();
}

Future<List<Transfer>> getList() async {
  String url = BASE_URL + '/api/user/history';
  String accessToken = await new SharedPref().getUserAccessToken();

  Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      List<Transfer> t = (json.decode(response.body) as List)
          .map((i) => Transfer.fromJson(i))
          .toList();
      return t;
    } else {
      List<Transfer> transfer = new List<Transfer>();
      transfer.add(new Transfer(
          amount: response.statusCode,
          other: response.statusCode.toString(),
          date: response.statusCode.toString()));
      return transfer;
    }
  } catch (e) {
    List<Transfer> transfer = new List<Transfer>();
    transfer.add(new Transfer(amount: 0, other: "error", date: "error"));
    return transfer;
  }
}

Future<List<Passage>> getPassage() async {
  String url = BASE_URL + '/api/user/passage';
  String accessToken = await new SharedPref().getUserAccessToken();

  Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      List<Passage> t = (json.decode(response.body) as List)
          .map((i) => Passage.fromJson(i))
          .toList();
      return t;
    } else {
      List<Passage> passage = new List<Passage>();
      passage.add(new Passage(
          amount: response.statusCode, date: response.statusCode.toString()));
      return passage;
    }
  } catch (e) {
    List<Passage> passage = List<Passage>();
    passage.add(new Passage(amount: 0, date: "error"));
    return passage;
  }
}
Future<List<Rechargement>> getRechargement() async {
  String url = BASE_URL + '/api/user/pays';
  String accessToken = await new SharedPref().getUserAccessToken();

  Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  try {
    final response = await http.get(url, headers: requestHeaders);
    print("RESPONSE RECHARGEMENT : $response");
    if (response.statusCode == 200) {
      List<Rechargement> t = (json.decode(response.body) as List)
          .map((i) => Rechargement.fromJson(i))
          .toList();
      return t;
    } else {
      print("ELSE");
      return null;
    }
  } catch (e) {
    print("CATCH : $e");
    return null;
  }
}

class _ListTransferState extends State<ListTransfer>
    with SingleTickerProviderStateMixin {
  Future<List<Transfer>> myFuture;
  Future<List<Passage>> myPassage;
  Future<List<Rechargement>> myRechargement;
  AnimationController _controller;
  Animation _animation;
  Widget transfertTab, passageTab, rechargementTab;

  List<Widget> tabs;

  @override
  void initState() {
    myFuture = getList();
    myPassage = getPassage();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    transfertTab = _transferList();
    passageTab = _passageList();
    rechargementTab = _rechargementList();
    tabs = [
      transfertTab,
      passageTab,
      rechargementTab,
    ];
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 5,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text("Transactions",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Poppins Light",
                  fontWeight: FontWeight.bold)),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(child: Text("Transfert")),
              Tab(child: Text("Historique")),
              Tab(child: Text("Achat")),
            ],
          ),
        ),
        body: TabBarView(
          children: tabs,
        ),
      ),
    );
  }

  Widget _afficherListTransfert(context, List<Transfer> list) {
    bool state = list.length == 0;
    if(list.length == 1 && list[0].date == list[0].other && list[0].date == "error"){
      return Align(
        alignment: Alignment.center,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 60, color: Colors.grey),
              RaisedButton(
                color: kPrimaryColor,
                onPressed: () { 
                  setState(() {
                    myFuture = getList();
                  });
                 },
                child: Text(
                  "Réesseyer",
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins Light',
                ),
              ))
            ],
          )
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: state
              ? Center(
                  child: Text("Aucune transactions effectuer."),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      CardItem(transfer: list[index])),
        ),
      ],
    );
  }

  Widget _transferList() {
    return FutureBuilder(
      future: myFuture,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            _controller.forward(from: 0.0);
            return Material(
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
                            size: 30,
                          ),
                          SizedBox(height: 15),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                myFuture = getList();
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
            return _afficherListTransfert(context, snapshot.data);
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
      },
    );
  }

  Widget _passageList() {
    return FutureBuilder(
      future: myPassage,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            _controller.forward(from: 0.0);
            return Material(
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
                            size: 30,
                          ),
                          SizedBox(height: 15),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                myPassage = getPassage();
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
            return _afficherListPassage(context, snapshot.data);
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
      },
    );
  }

  Widget _rechargementList() {
    return FutureBuilder(
      future: myRechargement,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            _controller.forward(from: 0.0);
            return Material(
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
                            size: 30,
                          ),
                          SizedBox(height: 15),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                myPassage = getPassage();
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
            return _afficherListRechargement(context, snapshot.data);
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
      },
    );
  }

  Widget _afficherListPassage(BuildContext context, List<Passage> list) {
    bool state = list.length == 0;
    print(list);
    return Column(
      children: [
        Expanded(
          child: state
              ? Center(
                  child: Text("Vous n'avez jamais utilisé votre compte RestoPass."),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      CardItemPassage(passage: list[index])),
        ),
      ],
    );
  }

  Widget _afficherListRechargement(BuildContext context, List<Rechargement> list) {
    bool state = list.length == 0;
    print(list);
    return Column(
      children: [
        Expanded(
          child: state
              ? Center(
                  child: Text("Vous n'avez jamais utilisé votre compte RestoPass."),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      CardItemRechargement(rechargement: list[index])),
        ),
      ],
    );
  }


}
