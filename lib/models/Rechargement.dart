import 'dart:convert';

Rechargement rechargementFromJson(String str) => Rechargement.fromJson(json.decode(str));

String rechargementToJson(Rechargement data) => json.encode(data.toJson());

class Rechargement {
  Rechargement({
      this.amount,
      this.date,
      this.phoneNumber
  });

  String phoneNumber;
  String date;
  String amount;

  factory Rechargement.fromJson(Map<String, dynamic> json) => Rechargement(
    amount: json["amont"],
    date: json["created_at"],
    phoneNumber: json["user_phone"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "date": date,
    "other": phoneNumber
  };

  @override
  String toString() {
    return "AMOUNT : " + amount.toString() + "\n"
            + "DATE : " + date + "\n"
            + "TEL : " + phoneNumber + "\n";
  }
}

