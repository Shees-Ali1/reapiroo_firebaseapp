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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceController extends GetxController {
  var imageFile = Rx<File?>(null); // Observable for the selected image
  var videoFile = Rx<File?>(null); // Observable for the selected video
  var voiceNoteUrl = Rx<String?>(null); // Observable for voice note URL
  var taskDescription = Rx<String>(""); // Observable for task description
  var uploadSpareParts = Rx<bool>(false); // Observable for spare parts upload status
  var location = ''.obs; // Use '.obs' to make it reactive
  var isRecording = false.obs; // Observable boolean for recording state
  var progressValue = 0.0.obs; // Observable double for progress value
  var isLoading = false.obs;

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

  // Pick a video from the gallery
  Future<void> pickVideoFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        videoFile.value = File(pickedFile.path); // Update observable
      } else {
        Get.snackbar("Info", "No video selected.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick a video.");
    }
  }

  // Remove the selected image
  void removeImage() {
    imageFile.value = null; // Clear the observable
  }

  // Remove the selected video
  void removeVideo() {
    videoFile.value = null; // Clear the observable
  }

  // Save data to Firestore
  Future<bool> saveDataToCollection({
    required String title,
    required File? imageFile,
    required File? videoFile,
    DateTime? selectedDateTime,
  }) async {
    try {
      // Generate a 4-digit random ID
      String randomId = _generateRandomId();

      // Handle DateTime (use current time if null)
      DateTime dateToSave = selectedDateTime ?? DateTime.now();

      // Get the current user's UID
      String userUid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the user's name from the 'userDetails' collection using the user's UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(userUid)
          .get();

      // Extract the username from the document
      String userName = userDoc.exists ? userDoc['userName'] : 'Unknown User';

      // Create a new map of the data to be saved
      Map<String, dynamic> newData = {
        "taskDescription": taskDescription.value,
        "imageUrl": imageFile != null
            ? await _uploadImage(imageFile, title)
            : null, // Upload image if available
        "videoUrl": videoFile != null
            ? await _uploadVideo(videoFile, title)
            : null, // Upload video if available
        "secondImageUrl": null,
        "dateTime": Timestamp.fromDate(dateToSave), // Save dateTime as Firestore Timestamp
        "voiceNoteUrl": voiceNoteUrl.value,
        "uploadSpareParts": uploadSpareParts.value,
        "location": Get.find<LocationController>().location.value, // Use location.value here
        "randomId": randomId,
        "userUid": userUid,
        "selectedDateTime": dateToSave.toIso8601String(), // Store the selected date-time as ISO string
        "userName": userName, // Add the logged-in user's name here
        "title": title, // Add the logged-in user's name here
      };

      // Reference to the Firestore tasks collection
      CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks');

      // Query to check if any document contains the current user's UID
      QuerySnapshot querySnapshot = await tasksCollection
          .where("userUid", isEqualTo: userUid) // Check for the UID in the "userUid" field
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If a document exists with the current user's UID
        DocumentReference existingDocRef = querySnapshot.docs.first.reference;

        // Query bids collection to fetch offers for the task (related to the randomId and title)
        QuerySnapshot bidSnapshot = await FirebaseFirestore.instance
            .collection('bids')
            .where('taskId', isEqualTo: randomId)  // Match the task using randomId
            .where('title', isEqualTo: title) // Match by title as well
            .get();

        List<Map<String, dynamic>> bids = bidSnapshot.docs.map((bidDoc) {
          final bidData = bidDoc.data() as Map<String, dynamic>;
          return {
            "bidAmount": bidData['bidAmount'] ?? "N/A",
            "bidderId": bidData['bidderId'] ?? "",
            "bidderName": bidData['firstName'] ?? "Unknown",
          };
        }).toList();

        // Add bids to newData if any bids are found
        if (bids.isNotEmpty) {
          newData["bids"] = bids; // Store the bids in the task document
        }

        // Use Firestore's arrayUnion to append the new data to the existing array
        await existingDocRef.update({
          title: FieldValue.arrayUnion([newData]), // Append the new object to the array
        });
      } else {
        // If no document exists with the current user's UID, create a new document
        DocumentReference newDocRef = tasksCollection.doc(); // Firestore generates a random ID

        // Initialize the new document with the userUid and the array for the given title
        await newDocRef.set({
          "userUid": userUid, // Store the current user's UID inside the document
          title: [newData], // Create a new array field with the title as key
        });
      }

      // Show success message with black and white theme
      Get.snackbar(
        "Success",
        "Data saved successfully.",
        backgroundColor: Colors.black,  // Black background
        colorText: Colors.white,        // White text color
      );
      return true;
    } catch (e) {
      // Show error message with black and white theme
      Get.snackbar(
        "Error",
        "Failed to save data: $e",
        backgroundColor: Colors.black,  // Black background
        colorText: Colors.white,        // White text color
      );
      return false;
    }
  }


  // Generate a 4-digit random ID
  String _generateRandomId() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString(); // Generates a 4-digit number
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

  // Upload the video to Firebase Storage and return the URL
  Future<String> _uploadVideo(File video, String title) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('$title/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = await storageRef.putFile(video);
      return await storageRef.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", "Failed to upload video.");
      return "";
    }
  }

  // Record voice note
  Future<void> recordVoiceNote() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _recorder.openRecorder();

    String path = await _getRecordingPath();
    _audioFilePath = path;

    await _recorder.startRecorder(toFile: path);

    _isRecording = true;
    _progressValue = 0.0;

    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _progressValue += 100 / 60000; // Increment progress for 1 minute
      if (_progressValue >= 1.0) {
        stopRecording(); // Call stopRecording instead of _stopRecording
      }
    });
  }

  // Method to stop recording (public)
  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    _progressTimer?.cancel();
    _isRecording = false;
    _progressValue = 0.0;

    if (_audioFilePath != null) {
      String downloadUrl = await _uploadVoiceNote(File(_audioFilePath!));
      voiceNoteUrl.value = downloadUrl;
    }
  }

  // Helper methods for uploading and getting file path are unchanged
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

  Future<String> _getRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/audio_recording.aac';
  }
}

// Example location controller
class LocationController extends GetxController {
  var location = ''.obs;

  void updateLocation(String newLocation) {
    location.value = newLocation;
  }
}


