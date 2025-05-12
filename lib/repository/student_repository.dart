import '../db/student_database.dart';
import '../models/student_model.dart';

class StudentRepository {
  final StudentDatabase _db = StudentDatabase.instance;

  Future<List<Student>> fetchStudents() async {
    return await _db.getAllStudents();
  }

  Future<void> addStudent(Student student) async {
    await _db.insertStudent(student);
  }

  Future<void> updateStudent(Student student) async {
    await _db.updateStudent(student);
  }

  Future<void> deleteStudent(int id) async {
    await _db.deleteStudent(id);
  }

  Future<List<Student>> searchStudents(String query) async {
    return await _db.searchStudents(query);
  }
}
