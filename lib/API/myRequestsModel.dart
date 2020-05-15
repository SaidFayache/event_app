// To parse this JSON data, do
//
//     final myRequests = myRequestsFromJson(jsonString);

import 'dart:convert';

MyRequests myRequestsFromJson(String str) => MyRequests.fromJson(json.decode(str));

String myRequestsToJson(MyRequests data) => json.encode(data.toJson());

class MyRequests {
  List<RequestElement> requests;

  MyRequests({
    this.requests,
  });

  factory MyRequests.fromJson(Map<String, dynamic> json) => MyRequests(
    requests: List<RequestElement>.from(json["requests"].map((x) => RequestElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "requests": List<dynamic>.from(requests.map((x) => x.toJson())),
  };
}

class RequestElement {
  RequestRequest request;
  Event event;
  Plan plan;

  RequestElement({
    this.request,
    this.event,
    this.plan,
  });

  factory RequestElement.fromJson(Map<String, dynamic> json) => RequestElement(
    request: RequestRequest.fromJson(json["request"]),
    event: Event.fromJson(json["event"]),
    plan: Plan.fromJson(json["plan"]),
  );

  Map<String, dynamic> toJson() => {
    "request": request.toJson(),
    "event": event.toJson(),
    "plan": plan.toJson(),
  };
}

class Event {
  String id;
  String name;
  String admin;
  DateTime startDate;
  DateTime endDate;
  String description;
  String location;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Event({
    this.id,
    this.name,
    this.admin,
    this.startDate,
    this.endDate,
    this.description,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["_id"],
    name: json["name"],
    admin: json["admin"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    description: json["description"],
    location: json["location"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "admin": admin,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "description": description,
    "location": location,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class Plan {
  String description;
  List<String> options;
  int cost;
  int color;
  String id;
  String name;
  String event;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Plan({
    this.description,
    this.options,
    this.cost,
    this.color,
    this.id,
    this.name,
    this.event,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    description: json["description"],
    options: List<String>.from(json["options"].map((x) => x)),
    cost: json["cost"],
    color: json["color"],
    id: json["_id"],
    name: json["name"],
    event: json["event"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "options": List<dynamic>.from(options.map((x) => x)),
    "cost": cost,
    "color": color,
    "_id": id,
    "name": name,
    "event": event,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class RequestRequest {
  int state;
  String id;
  String user;
  String event;
  String plan;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  RequestRequest({
    this.state,
    this.id,
    this.user,
    this.event,
    this.plan,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory RequestRequest.fromJson(Map<String, dynamic> json) => RequestRequest(
    state: json["state"],
    id: json["_id"],
    user: json["user"],
    event: json["event"],
    plan: json["plan"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "state": state,
    "_id": id,
    "user": user,
    "event": event,
    "plan": plan,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}