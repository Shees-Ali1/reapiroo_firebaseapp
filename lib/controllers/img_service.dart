import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:repairoo/controllers/servicecontroller.dart';

class ImageService {
  final ServiceController serviceController;

  ImageService({required this.serviceController});

  Future<File?> openGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> removeImage() async {
    // This can be managed directly by setting the imageFile to null in the state.
  }

  Future<void> saveData({
    required String title,
    required File? imageFile,
  }) async {
    if (imageFile != null) {
      await serviceController.saveDataToCollection(
        title: title,
        imageFile: imageFile,
      );
    } else {
      Get.snackbar("Error", "Please select an image before saving.");
    }
  }
}
