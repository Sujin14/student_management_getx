import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management_getx/controllers/student.controller.dart';
import 'package:student_management_getx/models/student_model.dart';
import 'package:student_management_getx/screens/add_edit_student_page.dart';
import 'package:student_management_getx/widgets/confirm_dialog.dart';

class StudentDetailScreen extends StatelessWidget {
  final StudentModel student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFded93e),
        title: const Text("Student Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            tooltip: 'Edit',
            onPressed: () {
              Get.to(() => AddEditStudentScreen(student: student));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showConfirmDialog(
                context: context,
                onConfirm: () {
                  Get.find<StudentController>().deleteStudent(student.id!);
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 218, 232, 18),
              Color.fromARGB(255, 235, 130, 9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GetX<StudentController>(
          init: StudentController(),
          builder: (controller) {
            final updatedStudent = controller.getStudentById(student.id!);

            if (updatedStudent == null) {
              return const Center(child: Text('Student not found.'));
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(File(updatedStudent.imagePath)),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow("Name", updatedStudent.name),
                  _buildDetailRow("Age", updatedStudent.age.toString()),
                  _buildDetailRow("Email", updatedStudent.email),
                  _buildDetailRow("Phone", updatedStudent.phone.toString()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color.fromARGB(255, 17, 195, 17),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color.fromARGB(255, 17, 195, 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
