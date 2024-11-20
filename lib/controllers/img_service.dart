import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:repairoo/controllers/servicecontroller.dart';

class ImageService {
  final ServiceController serviceController;

  ImageService({required this.serviceController});

  // Pick an image from the gallery
  Future<File?> openGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Pick a video from the gallery
  Future<File?> openVideoGallery() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Remove image or video
  Future<void> removeMedia() async {
    // Reset both image and video files to null
    serviceController.imageFile.value = null;
    serviceController.videoFile.value = null;
  }

  // Save data (image and/or video)
  Future<void> saveData({
    required String title,
    required File? imageFile,
    required File? videoFile,
  }) async {
    if (imageFile != null || videoFile != null) {
      await serviceController.saveDataToCollection(
        title: title,
        imageFile: imageFile,
        videoFile: videoFile,
      );
    } else {
      Get.snackbar("Error", "Please select an image or video before saving.");
    }
  }
}
