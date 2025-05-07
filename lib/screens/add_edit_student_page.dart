import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_management_getx/controllers/student_form_controller.dart';
import 'package:student_management_getx/models/student_model.dart';

class AddEditStudentScreen extends StatelessWidget {
  final StudentModel? student;
  AddEditStudentScreen({super.key, this.student});

  final formController = Get.put(StudentFormController());

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      formController.pickImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = student != null;
    formController.setStudentData(
      name: student?.name,
      age: student?.age,
      email: student?.email,
      phone: student?.phone,
      imgPath: student?.imagePath ?? '',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Student' : 'Add Student'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<StudentFormController>(
          builder:
              (_) => Form(
                key: formController.formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Obx(() {
                        final path = formController.imagePath.value;
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              path.isNotEmpty ? FileImage(File(path)) : null,
                          child:
                              path.isEmpty
                                  ? const Icon(Icons.add_a_photo, size: 30)
                                  : null,
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: formController.nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                            validator: Validators.validateName,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: formController.ageController,
                            decoration: const InputDecoration(labelText: 'Age'),
                            keyboardType: TextInputType.number,
                            validator: Validators.validateAge,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: formController.emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.validateEmail,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: formController.phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                            ),
                            keyboardType: TextInputType.phone,
                            validator: Validators.validatePhone,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed:
                                () => formController.saveStudent(
                                  existingStudent: student,
                                ),
                            child: Text(
                              isEditing ? 'Update Student' : 'Add Student',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
