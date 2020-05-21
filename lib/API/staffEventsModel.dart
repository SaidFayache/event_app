// To parse this JSON data, do
//
//     final staffEvents = staffEventsFromJson(jsonString);

import 'dart:convert';

import 'eventsModel.dart';

StaffEvents staffEventsFromJson(String str) => StaffEvents.fromJson(json.decode(str));

String staffEventsToJson(StaffEvents data) => json.encode(data.toJson());

class StaffEvents {
  List<Event> events;

  StaffEvents({
    this.events,
  });

  factory StaffEvents.fromJson(Map<String, dynamic> json) => StaffEvents(
    events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}


