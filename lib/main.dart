import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management_getx/controllers/image_controller.dart';
import 'package:student_management_getx/controllers/student_controller.dart';
import 'package:student_management_getx/screens/student_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StudentController());
    Get.put(ImageController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Record Manager',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const StudentListScreen(),
    );
  }
}
