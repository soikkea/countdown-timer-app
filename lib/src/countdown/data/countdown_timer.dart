import 'package:countdown_timer/src/countdown/countdown_text_utils.dart';
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

  DateTime get finalTarget => endTime ?? startTime;

  Duration getRelevantTargetDuration(DateTime currentTimeInLocal) {
    CountdownState state = getCountdownState(currentTimeInLocal);
    if (state == CountdownState.before) {
      return getDurationInLocal(startTime, currentTimeInLocal);
    }
    if (state == CountdownState.during) {
      return getDurationInLocal(endTime!, currentTimeInLocal);
    }
    return getDurationInLocal(finalTarget, currentTimeInLocal);
  }

  Duration? getReferenceDuration(DateTime currentTimeInLocal) {
    CountdownState state = getCountdownState(currentTimeInLocal);
    if (state == CountdownState.before) {
      return getDurationInLocal(startTime, createdAt.toLocal());
    }
    if (state == CountdownState.during) {
      return getDurationInLocal(endTime!, startTime);
    }
    return null;
  }

  CountdownState getCountdownState(DateTime currentTimeInLocal) {
    DateTime currentTimeUtc = currentTimeInLocal.toUtc();
    if (currentTimeUtc.isBefore(startTime)) {
      return CountdownState.before;
    }
    if (endTime != null &&
        !(currentTimeUtc.isBefore(startTime)) &&
        !(currentTimeUtc.isAfter(endTime!))) {
      return CountdownState.during;
    }
    return CountdownState.after;
  }
}

enum CountdownState { before, during, after }
