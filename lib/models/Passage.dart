import 'dart:convert';

Passage passageFromJson(String str) => Passage.fromJson(json.decode(str));

String transferToJson(Passage data) => json.encode(data.toJson());

class Passage {
  Passage({
      this.amount,
      this.date,
      this.resto
  });

  String resto;
  String date;
  int amount;

  factory Passage.fromJson(Map<String, dynamic> json) => Passage(
    amount: json["amount"],
    date: json["scan_date"],
    resto: json["resto"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "scan_date": date,
    "resto": resto,
  };

  @override
  String toString() {
    return "AMOUNT : " + amount.toString() + "\n"
            + "DATE : " + date + "\n"
            + "RESTO : " + resto + "\n";
  }
}

