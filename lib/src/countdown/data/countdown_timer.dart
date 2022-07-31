import 'package:flutter/material.dart';

@immutable
class CountdownTimer {
  final int id;
  final String name;
  final DateTime startTime;
  final DateTime? endTime;
  final bool archived;
  final DateTime createdAt;

  const CountdownTimer(
      {required this.id,
      required this.name,
      required this.startTime,
      this.endTime,
      this.archived = false,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'archived': archived ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch
    };
    if (id > 0) {
      map['id'] = id;
    }
    return map;
  }

  CountdownTimer.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        startTime =
            DateTime.fromMillisecondsSinceEpoch(map['startTime'], isUtc: true),
        endTime = map['endTime'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['endTime'], isUtc: true),
        archived = map['archived'] == 1,
        createdAt =
            DateTime.fromMillisecondsSinceEpoch(map['createdAt'], isUtc: true);

  @override
  String toString() {
    return 'CountdownTimer(id: $id, name: $name, startTime: $startTime, endTime: $endTime, archived: $archived, createdAt: $createdAt)';
  }
}
