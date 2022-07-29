import 'dart:collection';

import 'package:countdown_timer/src/countdown/data/countdown_timer.dart';
import 'package:flutter/cupertino.dart';

class CountdownTimerProvider extends ChangeNotifier {
  // Placeholder
  final List<CountdownTimer> _timers = [
    CountdownTimer(
        id: 1, name: "Christmas 2022", startTime: DateTime(2022, 12, 24))
  ];

  UnmodifiableListView<CountdownTimer> get timers =>
      UnmodifiableListView(_timers);

  void add(CountdownTimer timer) {
    _timers.add(timer);
    notifyListeners();
  }

  Future<CountdownTimer> getCountdownTimer(int id) async {
    return Future<CountdownTimer>(() {
      return _timers.firstWhere((element) => element.id == id);
    });
  }
}
