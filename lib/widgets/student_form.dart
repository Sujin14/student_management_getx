import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/student_controller.dart';
import '../controllers/image_controller.dart';
import '../models/student_model.dart';
import '../utils/validators.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _ageController = TextEditingController(
      text: widget.student?.age.toString() ?? '',
    );
    _emailController = TextEditingController(text: widget.student?.email ?? '');
    _phoneController = TextEditingController(text: widget.student?.phone ?? '');

    // Pre-fill image if editing
    if (widget.student != null) {
      Get.find<ImageController>().setImage(File(widget.student!.imagePath));
    } else {
      Get.find<ImageController>().clearImage();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Get.find<ImageController>().setImage(File(pickedFile.path));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No image selected')));
    }
  }

  void _saveStudent() {
    final imageFile = Get.find<ImageController>().image.value;

    if (_formKey.currentState?.validate() ?? false) {
      if (imageFile.path.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a profile image')),
        );
        return;
      }

      final newStudent = Student(
        id: widget.student?.id,
        name: _nameController.text,
        age: int.parse(_ageController.text),
        email: _emailController.text,
        phone: _phoneController.text,
        imagePath: imageFile.path,
      );

      final controller = Get.find<StudentController>();
      if (widget.student == null) {
        controller.addStudent(newStudent);
      } else {
        controller.updateStudent(newStudent);
      }

      Get.back(); // Close the form screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageController = Get.find<ImageController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveStudent),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() {
                final imageFile = imageController.image.value;
                return GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        imageFile.path.isNotEmpty ? FileImage(imageFile) : null,
                    child:
                        imageFile.path.isEmpty
                            ? const Icon(Icons.account_circle, size: 60)
                            : null,
                  ),
                );
              }),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: Validators.validateName,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: Validators.validateAge,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
