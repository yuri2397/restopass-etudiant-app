import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restopass/constants.dart';
import 'package:restopass/models/ApiResponse.dart';
import 'package:restopass/models/Recipient.dart';
import 'package:restopass/views/Profile.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CustomDialog extends StatefulWidget {
  final Recipient? recipient;
  final amount;
  final Function? onClick;

  const CustomDialog({Key? key, this.onClick, this.recipient, this.amount})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool? _isLoad = false;
  Widget? _icon;
  String? _content;

  @override
  void initState() {
    super.initState();
    _icon = progressBar();
    _content = "Transferer ${widget.amount} FCFA à " +
        widget.recipient!.firstName! +
        " " +
        widget.recipient!.lastName!;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 70),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0))
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Transfert",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                _content!,
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !_isLoad!
                      ? TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: kPrimaryColor),
                          child: Text("Annuler"),
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onClick!(false);
                          },
                        )
                      : Container(),
                  !_isLoad!
                      ? TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: kPrimaryColor),
                          child: Text("Je confirme"),
                          onPressed: () async {
                            setState(() {
                              _isLoad = true;
                            });
                            ApiResponse res = await widget.onClick!(true);
                            if (res == null) {
                              Fluttertoast.showToast(
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  msg: "Vérifier votre connexion internet.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1);
                              return;
                            }
                            if (res.error == true) {
                              setState(() {
                                _content = res.message;
                                _icon = Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.red,
                                );
                              });
                            } else {
                              setState(() {
                                _content = res.message;
                                _icon = Image.asset(
                                    'assets/images/success_check.gif');
                              });
                            }
                            Future.delayed(const Duration(seconds: 2),
                                () => Navigator.pop(context));
                          },
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30.0,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: !_isLoad!
                      ? Image.asset('assets/images/transfer.jpg')
                      : _icon)),
        )
      ],
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
}
