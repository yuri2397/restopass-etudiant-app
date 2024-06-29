import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:restopass/constants.dart';
import 'package:restopass/models/ApiResponse.dart';
import 'package:http/http.dart' as http;
import 'package:restopass/models/PaydunyaResponse.dart';
import 'package:restopass/utils/SharedPref.dart';
import 'package:restopass/views/paydunya.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Bay extends StatefulWidget {
  static const String routeName = '/bay';
  Bay({Key? key}) : super(key: key);

  @override
  _BayState createState() => _BayState();
}

class _BayState extends State<Bay> {
  bool isLoading = true;
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  double lineProgress = 0.0;
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        bottom: PreferredSize(
          child: _progressBar(lineProgress, context),
          preferredSize: Size.fromHeight(3.0),
        ),
        title: Text("Recharger votre compte"),
      ),
      withZoom: false,
      withJavascript: true,
      url: BASE_URL + '/pay',
    );
  }

  Widget _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: kPrimaryColor,
      value: progress == 1.0 ? 0 : progress,
      valueColor: new AlwaysStoppedAnimation<Color>(kAccent),
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

  bool firstTime = true;
  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    flutterWebviewPlugin.onProgressChanged.listen((progress) {
      print(progress);

      setState(() {
        lineProgress = progress;
      });
    });
  }
}
