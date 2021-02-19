import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restopass/constants.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class PayDunya extends StatefulWidget {
  String url;
  PayDunya(this.url, {Key key}) : super(key: key);

  @override
  _PayDunyaState createState() => _PayDunyaState();
}

class _PayDunyaState extends State<PayDunya> {
  bool isLoading = true;
  final _key = UniqueKey();
  final String script =
      "var one = document.getElementsByClassName('right')[0];one.parentNode.removeChild(one);var two = document.getElementsByClassName('highlight_paragraph visible-xs')[0];two.parentNode.removeChild(two);var countries_ssd = document.getElementById('countries_msdd');if (countries_ssd.style.display !== 'none') {countries_ssd.style.display = 'none';} else {countries_ssd.style.display = 'block';}var text = document.getElementsByTagName('h1')[0];text.innerHTML = 'Choisissez un moyen de paiement.';text.style = 'font-size: 20px; margin: auto; background-color: #5C01CA; padding: 10px;border-radius: 5px; color: white';";
  WebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    print("URL : " + widget.url);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        title: Text("Recharger compte"),
      ),
      body: Stack(
        children: [
          WebView(
              key: _key,
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish) async {
                setState(() {
                  isLoading = false;
                });
                String res =
                    await _webViewController.evaluateJavascript(script);
                print("RES JS : $res");
              },
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              }),
          isLoading
              ? Container(
                  color: Colors.white,
                  child: Center(child: progressBar()),
                )
              : Stack(),
        ],
      ),
    );
  }

  Widget progressBar() {
    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      child: SleekCircularSlider(
        initialValue: 10,
        max: 100,
        appearance: CircularSliderAppearance(
            angleRange: 360,
            spinnerMode: true,
            startAngle: 90,
            size: 40,
            customColors: CustomSliderColors(
              hideShadow: true,
              progressBarColor: kPrimaryColor,
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
