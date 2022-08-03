import 'dart:async';

import 'package:countdown_timer/src/countdown/data/countdown_timer.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String databaseName = 'countdown_database.db';
  static const String tableName = 'countdowns';

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    // From: https://docs.flutter.dev/cookbook/persistence/sqlite
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, startTime INTEGER, endTime INTEGER, archived INTEGER, createdAt INTEGER)',
        );
      },
      version: 1,
    );

    return database;
  }

  Future<int> insertCountdownTimer(CountdownTimer countdownTimer) async {
    final db = await database;

    final id = await db.insert(tableName, countdownTimer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<List<CountdownTimer>> countdownTimers() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'startTime ASC',
    );

    return List.generate(
        maps.length, (index) => CountdownTimer.fromMap(maps[index]));
  }

  Future<CountdownTimer?> getCountdownTimer(int id) async {
    final db = await database;

    List<Map<String, dynamic>> maps =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return CountdownTimer.fromMap(maps.first);
    }

    return null;
  }

  Future<void> updateCountdownTimer(CountdownTimer timer) async {
    final db = await database;

    await db.update(
      tableName,
      timer.toMap(),
      where: 'id = ?',
      whereArgs: [timer.id],
    );
  }

  Future<void> deleteCountdownTimer(int id) async {
    final db = await database;

    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
