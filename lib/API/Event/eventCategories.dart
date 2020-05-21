// To parse this JSON data, do
//
//     final eventCategories = eventCategoriesFromJson(jsonString);

import 'dart:convert';

import '../eventsModel.dart';
import 'allTags.dart';

EventCategories eventCategoriesFromJson(String str) => EventCategories.fromJson(json.decode(str));

String eventCategoriesToJson(EventCategories data) => json.encode(data.toJson());

class EventCategories {
  String message;
  List<EventCategoryItem> data;

  EventCategories({
    this.message,
    this.data,
  });

  factory EventCategories.fromJson(Map<String, dynamic> json) => EventCategories(
    message: json["message"],
    data: List<EventCategoryItem>.from(json["data"].map((x) => EventCategoryItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EventCategoryItem {
  TagItem tag;
  List<Event> events;

  EventCategoryItem({
    this.tag,
    this.events,
  });

  factory EventCategoryItem.fromJson(Map<String, dynamic> json) => EventCategoryItem(
    tag: TagItem.fromJson(json["tag"]),
    events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tag": tag.toJson(),
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

