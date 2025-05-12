import 'package:flutter/material.dart';
import '../models/student_model.dart';
import 'dart:io';

class StudentGridView extends StatelessWidget {
  final List<Student> students;
  final void Function(Student student) onTap;
  final void Function(Student student) onEdit;
  final void Function(Student student) onDelete;

  const StudentGridView({
    super.key,
    required this.students,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const Center(child: Text('No students found.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: students.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (_, index) {
        final student = students[index];

        return GestureDetector(
          onTap: () => onTap(student),
          child: Card(
            elevation: 4,
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Fixing the issue by converting the image path to a File
                CircleAvatar(
                  backgroundImage:
                      student.imagePath.isEmpty
                          ? const AssetImage(
                            'assets/images/default_image.png',
                          ) // Default image if no path
                          : FileImage(File(student.imagePath)),
                  radius: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  student.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.amber,
                      ),
                      onPressed: () => onEdit(student),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: () => onDelete(student),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
