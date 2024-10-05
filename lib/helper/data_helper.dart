import 'package:schedule_meetings/model/schedule_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'schedule.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          start TEXT,
          durations INT
        )
      ''');
    });
  }

  Future<void> insertItem(String name, DateTime date, int durations) async {
    final db = await database;
    await db.insert('items', {
      'name': name,
      'start': date.toIso8601String(),
      'durations': durations,
    });
  }

  Future<List<ScheduleModel>> getItems() async {
    final db = await database;
    final data = await db.query('items', orderBy: 'start ASC');
    return data.map((e) => ScheduleModel.fromJson(e)).toList();
  }
}
