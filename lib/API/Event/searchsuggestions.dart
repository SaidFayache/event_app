// To parse this JSON data, do
//
//     final searchSuggestions = searchSuggestionsFromJson(jsonString);

import 'dart:convert';

SearchSuggestions searchSuggestionsFromJson(String str) => SearchSuggestions.fromJson(json.decode(str));

String searchSuggestionsToJson(SearchSuggestions data) => json.encode(data.toJson());

class SearchSuggestions {
  String message;
  List<Suggestion> data;

  SearchSuggestions({
    this.message,
    this.data,
  });

  factory SearchSuggestions.fromJson(Map<String, dynamic> json) => SearchSuggestions(
    message: json["message"],
    data: List<Suggestion>.from(json["data"].map((x) => Suggestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Suggestion {
  String id;
  String name;
  DateTime start;

  Suggestion({
    this.id,
    this.name,
    this.start,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
    id: json["id"],
    name: json["name"],
    start: DateTime.parse(json["start"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "start": start.toIso8601String(),
  };
}
