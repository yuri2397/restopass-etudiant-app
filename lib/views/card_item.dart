import 'package:flutter/material.dart';
import 'package:restopass/models/Tranfer.dart';

class CardItem extends StatefulWidget {
  final Transfer transfer;
  
  CardItem({
    Key key, this.transfer,
  }) : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    bool mode = widget.transfer.amount < 0;
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
                        Icon(mode ? Icons.call_made : Icons.call_received_sharp, size: 20,color: mode ? Colors.red : Colors.green,),
                        SizedBox(width: 10,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.transfer.other,
                              style: TextStyle(
                                fontFamily: "Poppins Light",
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              widget.transfer.date,
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
                        widget.transfer.amount.toString() + " FCFA",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Poppins Light",
                          fontWeight: FontWeight.bold,
                          color: mode ? Colors.red : Colors.green
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

}
