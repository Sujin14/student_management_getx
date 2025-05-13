import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management_getx/controllers/student_controller.dart';
import 'package:student_management_getx/models/student_model.dart';
import 'package:student_management_getx/screens/student_details_screen.dart';
import 'package:student_management_getx/utils/dialogs.dart';
import 'package:student_management_getx/widgets/student_form.dart';
import 'package:student_management_getx/widgets/student_gridview.dart';
import 'package:student_management_getx/widgets/student_listview.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final StudentController _controller = Get.find<StudentController>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentController>(
      builder: (controller) {
        final students =
            controller.isSearching.value
                ? controller.searchResults
                : controller.students;

        return Scaffold(
          appBar: AppBar(
            title:
                controller.isSearching.value
                    ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Search by name',
                        border: InputBorder.none,
                      ),
                      onChanged: (query) {
                        controller.searchStudent(query);
                      },
                    )
                    : const Text('Student Records'),
            actions: [
              IconButton(
                icon: Icon(
                  controller.isGridView.value ? Icons.list : Icons.grid_view,
                ),
                onPressed: controller.toggleViewMode,
              ),
              IconButton(
                icon: Icon(
                  controller.isSearching.value ? Icons.close : Icons.search,
                ),
                onPressed: () {
                  if (controller.isSearching.value) {
                    _searchController.clear();
                    controller.clearSearch();
                  } else {
                    controller.toggleSearch(true);
                  }
                },
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.amber],
              ),
            ),
            child:
                controller.isGridView.value
                    ? StudentGridView(
                      students: students,
                      onTap: (student) => _viewStudentDetails(student),
                      onEdit: (student) => _editStudent(student),
                      onDelete: (student) => _deleteStudent(student),
                    )
                    : StudentListView(
                      students: students,
                      onTap: (student) => _viewStudentDetails(student),
                      onEdit: (student) => _editStudent(student),
                      onDelete: (student) => _deleteStudent(student),
                    ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _addStudent,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _viewStudentDetails(Student student) {
    Get.to(() => StudentDetailScreen(student: student));
  }

  void _editStudent(Student student) {
    Get.to(() => StudentFormScreen(student: student));
  }

  void _addStudent() {
    Get.to(() => const StudentFormScreen());
  }

  void _deleteStudent(Student student) async {
    final confirm = await Dialogs.showDeleteConfirmation(student.name);

    if (confirm) {
      await _controller.deleteStudent(student.id!);
    }
  }
}
