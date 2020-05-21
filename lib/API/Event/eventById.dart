// To parse this JSON data, do
//
//     final eventById = eventByIdFromJson(jsonString);

import 'dart:convert';

import '../eventsModel.dart';

EventById eventByIdFromJson(String str) => EventById.fromJson(json.decode(str));

String eventByIdToJson(EventById data) => json.encode(data.toJson());

class EventById {
  String message;
  Event data;

  EventById({
    this.message,
    this.data,
  });

  factory EventById.fromJson(Map<String, dynamic> json) => EventById(
    message: json["message"],
    data: Event.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}


