import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management_getx/controllers/student.controller.dart';
import 'package:student_management_getx/models/student_model.dart';
import 'package:student_management_getx/screens/add_edit_student_page.dart';
import 'package:student_management_getx/screens/student_details_page.dart';
import 'package:student_management_getx/widgets/custom_search_bar.dart';
import 'package:student_management_getx/widgets/empty_message.dart';
import 'package:student_management_getx/widgets/student_grid_card.dart';
import 'package:student_management_getx/widgets/student_list_card.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentController controller = Get.find<StudentController>();
  bool isGrid = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    controller.fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Records'),
        backgroundColor: const Color.fromARGB(255, 235, 130, 9),
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() => isGrid = !isGrid);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddEditStudentScreen()),
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 235, 130, 9),
              Color.fromARGB(255, 218, 232, 18),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: CustomSearchBar(
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                final students = controller.searchStudents(_searchQuery);

                if (students.isEmpty) {
                  return const EmptyMessage();
                }

                return isGrid
                    ? GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.9,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return StudentGridCard(
                          student: student,
                          onTap: () => _openDetail(student),
                          onEdit:
                              () => Get.to(
                                () => AddEditStudentScreen(student: student),
                              ),
                          onDelete: () => controller.deleteStudent(student.id!),
                        );
                      },
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: StudentListCard(
                            student: student,
                            onTap: () => _openDetail(student),
                            onEdit:
                                () => Get.to(
                                  () => AddEditStudentScreen(student: student),
                                ),
                            onDelete:
                                () => controller.deleteStudent(student.id!),
                          ),
                        );
                      },
                    );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(StudentModel student) {
    Get.to(() => StudentDetailScreen(student: student));
  }
}
