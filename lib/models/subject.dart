import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import "../widgets/app.dart";

class Subject {
  final String id;
  final String? name;
  final String? room;
  final IconData? icon;
  final Color? color;

  Subject({
    required this.name,
    required this.icon,
    required this.color,
    required this.room,
    id,
  }) : id = id == null ? Uuid().v4() : id;

  static final noSubject = Subject(
      id: "0",
      name: "Divers",
      icon: Icons.more_horiz_rounded,
      color: Color(App.defaultColorThemeValue),
      room: "");

  Map<String, dynamic> toMapDb() {
    return {
      "id": id,
      "name": name,
      "room": room,
      "iconCode": icon!.codePoint,
      "colorValue": color!.value,
    };
  }
}
