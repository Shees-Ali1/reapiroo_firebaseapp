import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class ServiceController extends GetxController {
  var imageFile = Rx<File?>(null); // Observable for the selected image
  var dateTime = Rx<DateTime?>(null); // Observable for selected date and time
  var voiceNoteUrl = Rx<String?>(null); // Observable for voice note URL
  var taskDescription = Rx<String>(""); // Observable for task description
  var uploadSpareParts = Rx<bool>(false); // Observable for spare parts upload status

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder(); // Initialize FlutterSoundRecorder
  bool _isRecording = false;
  Timer? _progressTimer;
  double _progressValue = 0.0;
  String? _audioFilePath; // Store the path to the recording file

  // Pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path); // Update observable
      } else {
        Get.snackbar("Info", "No image selected.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick an image.");
    }
  }

  // Remove the selected image
  void removeImage() {
    imageFile.value = null; // Clear the observable
  }

  // Pick date and time
  Future<void> _pickDateTime() async {
    DateTime? selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (selectedTime != null) {
        dateTime.value = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
            selectedTime.hour, selectedTime.minute);
      }
    }
  }

  // Save the data to Firestore dynamically based on the title
  // Modify saveDataToCollection to match the expected usage
  Future<bool> saveDataToCollection({
    required String title,
    required File? imageFile,  // Direct parameter for imageFile
  }) async {
    try {
      // Create a new map of the data to be saved
      Map<String, dynamic> data = {
        "taskDescription": taskDescription.value,
        "timestamp": FieldValue.serverTimestamp(),
        "imageUrl": imageFile != null ? await _uploadImage(imageFile, title) : null,
        "secondImageUrl": null,  // You can add second image logic here if needed
        "dateTime": dateTime.value,
        "voiceNoteUrl": voiceNoteUrl.value,
        "uploadSpareParts": uploadSpareParts.value,
      };

      // Save data in Firestore
      await FirebaseFirestore.instance.collection(title).add(data);
      Get.snackbar("Success", "Data saved successfully.");
      return true;
    } catch (e) {
      Get.snackbar("Error", "Failed to save data: $e");
      return false;
    }
  }


  // Upload the image to Firebase Storage and return the URL
  Future<String> _uploadImage(File image, String title) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('$title/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image.");
      return "";
    }
  }

  // Record voice note and save URL
  Future<void> recordVoiceNote() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    // Ensure recorder is initialized
    await _recorder.openRecorder();

    String path = await _getRecordingPath();
    _audioFilePath = path; // Store the file path

    await _recorder.startRecorder(toFile: path);

    _isRecording = true;
    _progressValue = 0.0;

    // Start a timer that updates the progress every 100 milliseconds over 1 minute
    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _progressValue += 100 / 60000; // Increment progress based on 1 minute (60,000 ms)
      if (_progressValue >= 1.0) {
        _stopRecording(); // Automatically stop recording when time is up
      }
    });
  }

  // Stop the voice recording
  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    _progressTimer?.cancel();
    _isRecording = false;
    _progressValue = 0.0;

    if (_audioFilePath != null) {
      // Upload the voice note to Firebase and get the URL
      String downloadUrl = await _uploadVoiceNote(File(_audioFilePath!));
      voiceNoteUrl.value = downloadUrl;

      Get.snackbar("Recording", "Recording stopped, voice note uploaded.");
    }
  }

  // Upload the voice note file to Firebase Storage and return the download URL
  Future<String> _uploadVoiceNote(File voiceNoteFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('voiceNotes/${DateTime.now().millisecondsSinceEpoch}.aac');
      final uploadTask = await storageRef.putFile(voiceNoteFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", "Failed to upload voice note.");
      return "";
    }
  }

  // Get the path to store the recording
  Future<String> _getRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/audio_recording.aac';
  }
}
