import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT,
        major TEXT NOT NULL,
        origin TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertStudent(Map<String, dynamic> student) async {
    final db = await database;
    await db.insert('students', student);
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await database;
    return await db.query('students', orderBy: 'name');
  }

  Future<void> updateStudent(Map<String, dynamic> student) async {
    final db = await database;
    final int id = student['id'] as int;

    await db.update(
      'students',
      student,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteStudent(int id) async {
    final db = await database;
    await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
