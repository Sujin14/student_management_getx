import 'dart:io';
import 'package:flutter/material.dart';
import '../models/student_model.dart';

class StudentListView extends StatelessWidget {
  final List<Student> students;
  final void Function(Student student) onTap;
  final void Function(Student student) onEdit;
  final void Function(Student student) onDelete;

  const StudentListView({
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

    return ListView.separated(
      itemCount: students.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final student = students[index];

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: FileImage(File(student.imagePath)),
            radius: 25,
          ),
          title: Text(student.name),
          onTap: () => onTap(student),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(student),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () => onDelete(student),
              ),
            ],
          ),
        );
      },
    );
  }
}
