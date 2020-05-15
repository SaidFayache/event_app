// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  String password;
  String email;

  Login({
    this.password,
    this.email,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    password: json["password"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "password": password,
    "email": email,
  };
}
