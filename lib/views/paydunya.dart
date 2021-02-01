import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayDunya extends StatefulWidget {
  String url;
  PayDunya(this.url, {Key key}) : super(key: key);

  @override
  _PayDunyaState createState() => _PayDunyaState();
}

class _PayDunyaState extends State<PayDunya> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payement"),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
