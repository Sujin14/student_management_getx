import 'package:get/get.dart';
import 'package:student_management_getx/models/student_model.dart';
import 'package:student_management_getx/services/db_helper.dart';

class StudentController extends GetxController {
  var students = <StudentModel>[].obs;

  // Fetch all students from the database
  Future<void> fetchStudents() async {
    final dataList = await DBHelper.getStudents();
    students.assignAll(dataList);
  }

  // Add a new student to database and list
  Future<void> addStudent(StudentModel student) async {
    final id = await DBHelper.insertStudent(student);
    student.id = id;
    students.add(student);
  }

  // Update student data
  Future<void> updateStudent(StudentModel student) async {
    await DBHelper.updateStudent(student);
    final index = students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      students[index] = student;
      students.refresh(); // Trigger update
    }
  }

  // Delete student
  Future<void> deleteStudent(int id) async {
    await DBHelper.deleteStudent(id);
    students.removeWhere((student) => student.id == id);
  }

  // Get student by ID
  StudentModel? getStudentById(int id) {
    return students.firstWhereOrNull((s) => s.id == id);
  }

  // Filtered list based on search query
  List<StudentModel> searchStudents(String query) {
    if (query.isEmpty) return students;
    return students
        .where(
          (student) =>
              student.name.toLowerCase().contains(query.toLowerCase()) ||
              student.email.toLowerCase().contains(query.toLowerCase()) ||
              student.phone.toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
  }
}
