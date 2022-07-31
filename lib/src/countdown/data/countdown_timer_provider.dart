import 'dart:collection';

import 'package:countdown_timer/src/countdown/data/countdown_timer.dart';
import 'package:countdown_timer/src/countdown/data/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CountdownTimerProvider extends ChangeNotifier {
  final DBHelper dbHelper = DBHelper();

  Future<UnmodifiableListView<CountdownTimer>> get timers async {
    return UnmodifiableListView(await dbHelper.countdownTimers());
  }

  void add(CountdownTimer timer) {
    dbHelper.insertCountdownTimer(timer);
    notifyListeners();
  }

  Future<CountdownTimer> getCountdownTimer(int id) async {
    final timer = await dbHelper.getCountdownTimer(id);
    return timer!;
  }
}
