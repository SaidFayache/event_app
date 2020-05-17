// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String message;
  String token;
  String name;
  String id;

  LoginResponse({
    this.message,
    this.token,
    this.name,
    this.id,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    message: json["message"],
    token: json["token"],
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "name": name,
    "id": id,
  };
}
