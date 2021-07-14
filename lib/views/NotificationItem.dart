import 'package:flutter/material.dart';
import 'package:restopass/constants.dart';
import 'package:restopass/models/Notification.dart';

class NotificationItem extends StatefulWidget {
  final Not notification;
  const NotificationItem({Key key, this.notification}) : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 2.0,
          ),
        ],
      ),
      alignment: Alignment.center,
      width: size.width - 60,
      height: 100,
      margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
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
              widget.notification.not,
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
    );
  }
}
