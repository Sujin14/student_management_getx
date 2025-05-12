import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dialogs {
  static Future<bool> showDeleteConfirmation(String name) async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete $name?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }
}
