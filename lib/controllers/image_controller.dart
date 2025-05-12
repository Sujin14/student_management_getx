import 'dart:io';
import 'package:get/get.dart';

class ImageController extends GetxController {
  var image = Rx<File>(File(''));

  void setImage(File imageFile) {
    image.value = imageFile;
    update();
  }

  void clearImage() {
    image.value = File('');
    update();
  }
}
