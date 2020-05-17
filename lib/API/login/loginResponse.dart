// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String message;
  UserResp id;

  LoginResponse({
    this.message,
    this.id,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    message: json["message"],
    id: UserResp.fromJson(json["id"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "id": id.toJson(),
  };
}

class UserResp {
  String id;
  String name;
  String password;
  String email;
  int v;

  UserResp({
    this.id,
    this.name,
    this.password,
    this.email,
    this.v,
  });

  factory UserResp.fromJson(Map<String, dynamic> json) => UserResp(
    id: json["_id"],
    name: json["name"],
    password: json["password"],
    email: json["email"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "password": password,
    "email": email,
    "__v": v,
  };
}
