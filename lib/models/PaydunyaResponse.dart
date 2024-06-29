import 'dart:convert';

PayDunyaResponse payDunyaResponseFromJson(String str) => PayDunyaResponse.fromJson(json.decode(str));

class PayDunyaResponse {
  PayDunyaResponse({
    this.responseCode,
    this.token,
    this.responseText,
    this.description,
  });

  String? responseCode;
  String? responseText;
  String? token;
  String? description;

  factory PayDunyaResponse.fromJson(Map<String, dynamic> json) => PayDunyaResponse(
    responseCode: json["response_code"],
    responseText: json["response_text"],
    description: json["description"],
    token: json["token"],
  );
}

