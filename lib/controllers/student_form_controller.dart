import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management_getx/controllers/student_controller.dart';
import '../models/student_model.dart';

class StudentFormController extends GetxController {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxString imagePath = ''.obs;

  void setStudentData({
    required String? name,
    required int? age,
    required String? email,
    required int? phone,
    required String? imgPath,
  }) {
    nameController.text = name ?? '';
    ageController.text = age?.toString() ?? '';
    emailController.text = email ?? '';
    phoneController.text = phone?.toString() ?? '';
    imagePath.value = imgPath ?? '';
  }

  void pickImage(String path) {
    imagePath.value = path;
  }

  void saveStudent({StudentModel? existingStudent}) {
    if (!formKey.currentState!.validate() || imagePath.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields and select an image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final student = StudentModel(
      id: existingStudent?.id,
      name: nameController.text.trim(),
      age: int.parse(ageController.text.trim()),
      email: emailController.text.trim(),
      phone: int.parse(phoneController.text.trim()),
      imagePath: imagePath.value,
    );

    final studentController = Get.find<StudentController>();

    if (existingStudent == null) {
      studentController.addStudent(student);
    } else {
      studentController.updateStudent(student);
    }

    Get.snackbar(
      'Success',
      'Student saved successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
