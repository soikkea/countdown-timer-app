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
}