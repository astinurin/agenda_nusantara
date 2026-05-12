import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('agenda_nusantara.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _buatDatabase,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE tugas ADD COLUMN tanggalSelesai TEXT');
        }
      },
    );
  }

  Future _buatDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tugas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        deskripsi TEXT NOT NULL,
        tanggal TEXT NOT NULL,
        isPenting INTEGER NOT NULL,
        isSelesai INTEGER NOT NULL,
        tanggalSelesai TEXT
      )
    ''');
  }

  Future<int> tambahTask(Task task) async {
    final db = await instance.database;

    return await db.insert('tugas', task.toMap());
  }

  Future<List<Task>> getSemuaTask() async {
    final db = await instance.database;

    final result = await db.query('tugas');

    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;

    return await db.update(
      'tugas',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> hapusTask(int id) async {
    final db = await instance.database;

    return await db.delete('tugas', where: 'id = ?', whereArgs: [id]);
  }
}
