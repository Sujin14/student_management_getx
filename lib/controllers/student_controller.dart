import 'package:get/get.dart';
import '../models/student_model.dart';
import '../repository/student_repository.dart';

class StudentController extends GetxController {
  final StudentRepository _repository = StudentRepository();

  var students = <Student>[].obs;
  var searchResults = <Student>[].obs;

  var isGridView = false.obs;
  var isSearching = false.obs;
  var lastQuery = '';

  @override
  void onInit() {
    super.onInit();
    loadStudents();
  }

  Future<void> loadStudents() async {
    final fetched = await _repository.fetchStudents();
    students.value = fetched;

    if (isSearching.value && lastQuery.isNotEmpty) {
      searchResults.value =
          students
              .where(
                (student) => student.name.toLowerCase().startsWith(
                  lastQuery.toLowerCase(),
                ),
              )
              .toList();
    }
    update();
  }

  Future<void> addStudent(Student student) async {
    await _repository.addStudent(student);
    await loadStudents();
  }

  Future<void> updateStudent(Student student) async {
    await _repository.updateStudent(student);
    await loadStudents();
  }

  Future<void> deleteStudent(int id) async {
    await _repository.deleteStudent(id);
    await loadStudents();
  }

  void searchStudent(String query) {
    lastQuery = query;

    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
    } else {
      searchResults.value =
          students
              .where(
                (student) =>
                    student.name.toLowerCase().startsWith(query.toLowerCase()),
              )
              .toList();
      isSearching.value = true;
    }

    update();
  }

  void clearSearch() {
    searchResults.clear();
    lastQuery = '';
    isSearching.value = false;
    update();
  }

  void toggleViewMode() {
    isGridView.value = !isGridView.value;
    update();
  }

  void toggleSearch(bool value) {
    isSearching.value = value;
    update();
  }
}
