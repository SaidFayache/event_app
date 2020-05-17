// To parse this JSON data, do
//
//     final countings = countingsFromJson(jsonString);

import 'dart:convert';

Countings countingsFromJson(String str) => Countings.fromJson(json.decode(str));

String countingsToJson(Countings data) => json.encode(data.toJson());

class Countings {
  String message;
  List<Counting> data;

  Countings({
    this.message,
    this.data,
  });

  factory Countings.fromJson(Map<String, dynamic> json) => Countings(
    message: json["message"],
    data: List<Counting>.from(json["data"].map((x) => Counting.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Counting {
  String id;
  String name;
  bool state;
  int countIn;
  int countOut;
  CountingDetails details;


  Counting({
    this.id,
    this.name,
    this.state,
    this.countIn,
    this.countOut,
  });

  factory Counting.fromJson(Map<String, dynamic> json) => Counting(
    id: json["id"],
    name: json["name"],
    state: json["state"],
    countIn: json["count_in"],
    countOut: json["count_out"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "count_in": countIn,
    "count_out": countOut,
  };
}
// To parse this JSON data, do
//
//     final countingDetails = countingDetailsFromJson(jsonString);


CountingDetails countingDetailsFromJson(String str) => CountingDetails.fromJson(json.decode(str));

String countingDetailsToJson(CountingDetails data) => json.encode(data.toJson());

class CountingDetails {
  String message;
  List<ListInElement> listIn;
  List<ListInElement> listOut;

  CountingDetails({
    this.message,
    this.listIn,
    this.listOut,
  });

  factory CountingDetails.fromJson(Map<String, dynamic> json) => CountingDetails(
    message: json["message"],
    listIn: List<ListInElement>.from(json["list_in"].map((x) => ListInElement.fromJson(x))),
    listOut: List<ListInElement>.from(json["list_out"].map((x) => ListInElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "list_in": List<dynamic>.from(listIn.map((x) => x.toJson())),
    "list_out": List<dynamic>.from(listOut.map((x) => x.toJson())),
  };
}

class ListInElement {
  String id;
  String name;
  String password;
  String email;
  int v;

  ListInElement({
    this.id,
    this.name,
    this.password,
    this.email,
    this.v,
  });

  factory ListInElement.fromJson(Map<String, dynamic> json) => ListInElement(
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

