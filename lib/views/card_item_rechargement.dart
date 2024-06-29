import 'package:flutter/material.dart';
import 'package:restopass/constants.dart';
import 'package:restopass/models/Rechargement.dart';
import 'package:restopass/models/Rechargement.dart';
import 'package:intl/intl.dart';

class CardItemRechargement extends StatefulWidget {
  final   Rechargement rechargement;

  CardItemRechargement({
    Key? key,
    required  this.rechargement,
  }) : super(key: key);

  @override
  _CardItemRechargementState createState() => _CardItemRechargementState();
}

class _CardItemRechargementState extends State<CardItemRechargement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 5),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.credit_card_rounded,
                    size: 30,
                    color: kPrimaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.rechargement.phoneNumber!,
                        style: TextStyle(
                          fontFamily: "Poppins Light",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormat.yMMMMd('fr_FR').format(
                            DateFormat("yyyy-MM-dd")
                                .parse(widget.rechargement.date!)),
                        style: TextStyle(
                          fontFamily: "Poppins Light",
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                child: Text(
                  widget.rechargement.amount.toString() + " FCFA",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins Light",
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
