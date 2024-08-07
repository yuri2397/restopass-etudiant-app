import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class Code extends StatefulWidget {
  static const String routeName = '/qrcode';
  final String number;
  const Code({Key? key,required this.number}) : super(key: key);

  @override
  _CodeState createState() => _CodeState();
}

class _CodeState extends State<Code> {
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
          title: Text("Qr code",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: "Poppins Light",
                  fontWeight: FontWeight.bold)),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Text(
                'Code QR',
                style: TextStyle(fontFamily: 'Poppins Light', fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: Text(
                'RestoPass',
                style: TextStyle(fontFamily: 'Poppins Bold', fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 10,
              child: Container(
                  width: size.width * 0.6,
                  height: size.width * 0.6,
                  alignment: Alignment.center,
                  child: PrettyQr(
                    data: widget.number,
                    typeNumber: 3,
                    image: AssetImage("assets/images/app_icon_black.png"),
                    roundEdges: true,
                    size: 200,
                  )),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: Text(
                'Votre QR code est privé. Si vous le partagez avec quelqu\'un, il peut l\'utiliser pour accéder au resto.',
                style: TextStyle(fontFamily: 'Poppins Light', fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )));
  }
}
