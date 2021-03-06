// To parse this JSON data, do
//
//     final events = eventsFromJson(jsonString);

import 'dart:convert';

Events eventsFromJson(String str) => Events.fromJson(json.decode(str));

String eventsToJson(Events data) => json.encode(data.toJson());

class Events {
  String status;
  String message;
  List<Event> data;

  Events({
    this.status,
    this.message,
    this.data,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
    status: json["status"],
    message: json["message"],
    data: List<Event>.from(json["data"].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Event {
  List<String> tags;
  String id;
  String name;
  String admin;
  String imageLink;
  DateTime startDate;
  DateTime endDate;
  String description;
  String location;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Event({
    this.tags,
    this.id,
    this.name,
    this.admin,
    this.imageLink,
    this.startDate,
    this.endDate,
    this.description,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    tags: List<String>.from(json["tags"].map((x) => x)),
    id: json["_id"],
    name: json["name"],
    admin: json["admin"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    description: json["description"],
    location: json["location"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    imageLink : json["imageLink"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "_id": id,
    "name": name,
    "admin": admin,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "description": description,
    "location": location,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "imageLink": imageLink  ,
    "__v": v,
  };
}
