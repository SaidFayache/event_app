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
  String id;
  String name;
  String admin;
  String description;
  String location;
  DateTime startDate;
  DateTime endDate;

  Event({
    this.id,
    this.name,
    this.admin,
    this.description,
    this.location,
    this.startDate,
    this.endDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    name: json["name"],
    admin: json["admin"],
    description: json["description"],
    location: json["location"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "admin": admin,
    "description": description,
    "location": location,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
  };
}
