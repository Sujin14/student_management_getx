import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management_getx/controllers/student_controller.dart';
import 'package:student_management_getx/screens/student_list_page.dart';

void main() {
  Get.put(StudentController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: StudentListScreen(),
    );
  }
}
