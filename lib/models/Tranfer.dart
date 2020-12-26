import 'dart:convert';

Transfer transferFromJson(String str) => Transfer.fromJson(json.decode(str));

String transferToJson(Transfer data) => json.encode(data.toJson());

class Transfer {
  Transfer({
      this.amount,
      this.date,
      this.other
  });

  String other;
  String date;
  int amount;

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
    amount: json["amount"],
    date: json["date"],
    other: json["other"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "date": date,
    "other": other
  };

  @override
  String toString() {
    return "AMOUNT : " + amount.toString() + "\n"
            + "DATE : " + date + "\n"
            + "OTHER : " + other + "\n";
  }
}

