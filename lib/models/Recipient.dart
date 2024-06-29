import 'dart:convert';

Recipient recipientFromJson(String str) => Recipient.fromJson(json.decode(str));

String recipientToJson(Recipient data) => json.encode(data.toJson());

class Recipient {
    Recipient({
        this.firstName,
        this.lastName,
        this.error,
    });

    String? firstName;
    String? lastName;
    bool? error;

    factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        firstName: json["first_name"],
        lastName: json["last_name"],
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "error": error,
    };
}

