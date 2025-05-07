import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_management_getx/models/student_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'students.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER,
            email TEXT,
            phone INTEGER,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  // Insert student
  static Future<int> insertStudent(StudentModel student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }

  // Get all students
  static Future<List<StudentModel>> getStudents() async {
    final db = await database;
    final result = await db.query('students');
    return result.map((json) => StudentModel.fromMap(json)).toList();
  }

  // Update student
  static Future<int> updateStudent(StudentModel student) async {
    final db = await database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // Delete student
  static Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }
}
