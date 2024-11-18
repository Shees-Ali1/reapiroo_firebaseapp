import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var location = ''.obs;  // Use '.obs' to make it reactive

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
  Future<bool> saveDataToCollection({
    required String title,
    required File? imageFile, // Direct parameter for imageFile
    DateTime? selectedDateTime, // DateTime parameter, now nullable
  }) async {
    try {
      // Generate a 4-digit random ID
      String randomId = _generateRandomId();

      // Handle DateTime (use current time if null)
      DateTime dateToSave = selectedDateTime ?? DateTime.now();

      // Create a new map of the data to be saved
      Map<String, dynamic> data = {
        "taskDescription": taskDescription.value,
        "imageUrl": imageFile != null
            ? await _uploadImage(imageFile, title)
            : null, // Upload image if available
        "secondImageUrl": null,
        "dateTime": Timestamp.fromDate(dateToSave), // Save dateTime as Firestore Timestamp
        "voiceNoteUrl": voiceNoteUrl.value,
        "uploadSpareParts": uploadSpareParts.value,
        "location": Get.find<LocationController>().location.value, // Use location.value here
        "randomId": randomId,
        "selectedDateTime": dateToSave.toIso8601String(), // Store the selected date-time as ISO string
      };

      // Get the current user's UID
      String userUid = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the Firestore tasks collection
      CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks');

      // Query to check if any document contains the current user's UID
      QuerySnapshot querySnapshot = await tasksCollection
          .where("userUid", isEqualTo: userUid) // Check for the UID in the "userUid" field
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If a document exists with the current user's UID
        DocumentReference existingDocRef = querySnapshot.docs.first.reference;

        // Add a new array for the given title in the existing document
        await existingDocRef.update({
          title: [data], // Create a new array field with the title as key
        });
      } else {
        // If no document exists with the current user's UID, create a new document
        DocumentReference newDocRef = tasksCollection.doc(); // Firestore generates a random ID

        // Initialize the new document with the userUid and the array for the given title
        await newDocRef.set({
          "userUid": userUid, // Store the current user's UID inside the document
          title: [data], // Create a new array field with the title as key
        });
      }

      // Show success message
      Get.snackbar("Success", "Data saved successfully.");
      return true;
    } catch (e) {
      // Show error message in case of failure
      Get.snackbar("Error", "Failed to save data: $e");
      return false;
    }
  }



// Method to generate a 4-digit random ID
  String _generateRandomId() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();  // Generates a 4-digit number
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

class LocationController extends GetxController {
  // Observable variable for the location
  var location = ''.obs;

  // Method to update the location value
  void updateLocation(String newLocation) {
    location.value = newLocation;
  }
}
