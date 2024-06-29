import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.number,
    this.email,
    this.firstName,
    this.lastName,
    this.pay
  });

  String? email;
  int? number;
  String? firstName;
  String? lastName;
  int? pay;

  int? get getPay{
    return pay;
  }

  set setPay(int pay){
    this.pay = pay;
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"],
    number: json["number"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    pay: json["pay"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "number": number,
    "first_name": firstName,
    "last_name": lastName,
    "pay": pay,
  };

  @override
  String toString() {
    return "NUMBER : " + number!.toString() + "\n"
            + "EMAIL : " + email! + "\n"
            + "FIRST_NAME : " + firstName! + "\n"
            + "LAST_NAME : " + lastName! + "\n"
            + "PAY : " + pay.toString() + "\n";
  }

}

