import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/views/Login.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  List<PageViewModel> getPages() {
    double titleSize = 30;
    double descSize = 17;
    return [
      PageViewModel(
        image: Image.asset("assets/images/welcome.jpg"),
        titleWidget: Text(
          "RestoPass",
          style: TextStyle(
            fontSize: titleSize,
            fontFamily: "Poppins Meduim",
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        bodyWidget: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Bienvenue sur RestoPass.",
            style: TextStyle(
              fontFamily: "Poppins Light",
              fontSize: descSize,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      PageViewModel(
        image: Image.asset("assets/images/achat.jpg"),
        titleWidget: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Achetez vos tickets en ligne.",
            style: TextStyle(
              fontSize: titleSize,
              fontFamily: "Poppins Meduim",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bodyWidget: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Pas de file d'attente, rechargez votre compte et entrez au resto.",
            style: TextStyle(
              fontFamily: "Poppins Light",
              fontSize: descSize,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      PageViewModel(
        image: Image.asset("assets/images/qr-code.jpg"),
        titleWidget: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Votre QR code, votre meilleur ami.",
            style: TextStyle(
              fontSize: titleSize,
              fontFamily: "Poppins Meduim",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bodyWidget: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Utitlisez votre QR code pour accèder au resto.",
            style: TextStyle(
              fontFamily: "Poppins Light",
              fontSize: descSize,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      PageViewModel(
        image: Image.asset("assets/images/transfer.jpg"),
        titleWidget: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Partagez vos tickets avec vos amis.",
            style: TextStyle(
              fontSize: titleSize,
              fontFamily: "Poppins Meduim",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bodyWidget: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Vous avez la possibilité de transférer des tickets à vos amis.",
            style: TextStyle(
              fontFamily: "Poppins Light",
              fontSize: descSize,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      PageViewModel(
        image: Image.asset("assets/images/achat.jpg"),
        titleWidget: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Pas d'argent? Empruntez des tickets.",
            style: TextStyle(
              fontSize: titleSize,
              fontFamily: "Poppins Meduim",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bodyWidget: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Le rembourssement se fera au prochain rechargement.",
            style: TextStyle(
              fontFamily: "Poppins Light",
              fontSize: descSize,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    ];
  }

  SharedPref? _pref;

  @override
  void initState() {
    super.initState();
    _pref = SharedPref();
    _pref?.setFirstTime(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        next: Text("Suivant"),
        done: Text("Se connecter"),
        onDone: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        },
        skip: Icon(Icons.skip_next_rounded),
        onSkip: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        },
        pages: getPages(),
      ),
    );
  }
}
