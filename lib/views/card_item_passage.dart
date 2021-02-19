import 'package:flutter/material.dart';
import 'package:restopass/models/Passage.dart';
import 'package:intl/intl.dart';
class CardItemPassage extends StatefulWidget {
  final Passage passage;

  CardItemPassage({
    Key key,
    this.passage,
  }) : super(key: key);

  @override
  _CardItemPassageState createState() => _CardItemPassageState();
}

class _CardItemPassageState extends State<CardItemPassage> {
  @override
  Widget build(BuildContext context) {
    bool mode = widget.passage.amount == 50;
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
                    mode ? Icons.free_breakfast_rounded : Icons.fastfood,
                    size: 30,
                    color: mode ? Colors.blue : Colors.green,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.passage.resto,
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
                                .parse(widget.passage.date)),
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
                  widget.passage.amount.toString() + " FCFA",
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
