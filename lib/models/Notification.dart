import 'dart:convert';

Not notFromJson(String str) =>
    Not.fromJson(json.decode(str));

class Not {
  Not({this.not, this.type, this.state});

  String? not;
  String? type;
  bool? state;

  factory Not.fromJson(Map<String, dynamic> json) => Not(
      not: json["notification"],
      type: json["type"],
      state: json['state']);
}
