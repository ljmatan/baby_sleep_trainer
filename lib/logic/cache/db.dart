import 'package:sqflite/sqflite.dart';

abstract class DB {
  static Database _db;
  static Database get db => _db;

  static Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'documents.db';
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the following tables
        await db.execute(
          'CREATE TABLE Logs ('
          'id INTEGER PRIMARY KEY, '
          'day INTEGER, '
          'type TEXT, '
          'note TEXT, '
          'totalTime INTEGER, '
          'cryTime INTEGER, '
          'awakeTime INTEGER'
          ')',
        );
        await db.execute(
          'CREATE TABLE CustomTimes ('
          'id INTEGER PRIMARY KEY, '
          'day INTEGER, '
          'session INTEGER, '
          'time INTEGER'
          ')',
        );
        await db.execute(
          'CREATE TABLE UserInfo ('
          'id INTEGER PRIMARY KEY, '
          'onboarded TEXT'
          ')',
        );
      },
    );
  }
}
