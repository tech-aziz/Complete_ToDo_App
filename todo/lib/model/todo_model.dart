// To parse this JSON data, do
//
//     final toModel = toModelFromJson(jsonString);

import 'dart:convert';

ToModel toModelFromJson(String str) => ToModel.fromJson(json.decode(str));

String toModelToJson(ToModel data) => json.encode(data.toJson());

class ToModel {
    ToModel({
        this.id,
        this.title,
        this.description,
        this.dateTime,
    });

    int? id;
    String? title;
    String ?description;
    String ?dateTime;

    factory ToModel.fromJson(Map<String, dynamic> json) => ToModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        dateTime: json["dateTime"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "dateTime": dateTime,
    };
}
