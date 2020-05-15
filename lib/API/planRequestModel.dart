// To parse this JSON data, do
//
//     final planReq = planReqFromJson(jsonString);

import 'dart:convert';

PlanReq planReqFromJson(String str) => PlanReq.fromJson(json.decode(str));

String planReqToJson(PlanReq data) => json.encode(data.toJson());

class PlanReq {
  String user;
  String event;
  String plan;

  PlanReq({
    this.user,
    this.event,
    this.plan,
  });

  factory PlanReq.fromJson(Map<String, dynamic> json) => PlanReq(
    user: json["user"],
    event: json["event"],
    plan: json["plan"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "event": event,
    "plan": plan,
  };
}
