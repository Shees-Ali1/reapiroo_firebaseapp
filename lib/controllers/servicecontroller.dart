// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class ServiceController extends GetxController {
//   var imageFile = Rx<File?>(null); // Observable for the selected image
//   var videoFile = Rx<File?>(null); // Observable for the selected video
//   var voiceNoteUrl = Rx<String?>(null); // Observable for voice note URL
//   var taskDescription = Rx<String>(""); // Observable for task description
//   var uploadSpareParts = Rx<bool>(false); // Observable for spare parts upload status
//   var location = ''.obs; // Use '.obs' to make it reactive
//   var isRecording = false.obs; // Observable boolean for recording state
//   var progressValue = 0.0.obs; // Observable double for progress value
//   var isLoading = false.obs;
//
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder(); // Initialize FlutterSoundRecorder
//   bool _isRecording = false;
//   Timer? _progressTimer;
//   double _progressValue = 0.0;
//   String? _audioFilePath; // Store the path to the recording file
//
//   // Pick an image from the gallery
//   Future<void> pickImageFromGallery() async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         imageFile.value = File(pickedFile.path); // Update observable
//       } else {
//         Get.snackbar("Info", "No image selected.");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to pick an image.");
//     }
//   }
//
//   // Pick a video from the gallery
//   Future<void> pickVideoFromGallery() async {
//     try {
//       final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         videoFile.value = File(pickedFile.path); // Update observable
//       } else {
//         Get.snackbar("Info", "No video selected.");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to pick a video.");
//     }
//   }
//
//   // Remove the selected image
//   void removeImage() {
//     imageFile.value = null; // Clear the observable
//   }
//
//   // Remove the selected video
//   void removeVideo() {
//     videoFile.value = null; // Clear the observable
//   }
//
//   // Save data to Firestore
//   Future<bool> saveDataToCollection({
//     required String title,
//     required File? imageFile,
//     required File? videoFile,
//     DateTime? selectedDateTime,
//   }) async {
//     try {
//       // Generate a 4-digit random ID
//       String randomId = _generateRandomId();
//
//       // Handle DateTime (use current time if null)
//       DateTime dateToSave = selectedDateTime ?? DateTime.now();
//
//       // Get the current user's UID
//       String userUid = FirebaseAuth.instance.currentUser!.uid;
//
//       // Fetch the user's name from the 'userDetails' collection using the user's UID
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('userDetails')
//           .doc(userUid)
//           .get();
//
//       // Extract the username from the document
//       String userName = userDoc.exists ? userDoc['userName'] : 'Unknown User';
//
//       // Create a new map of the data to be saved
//       Map<String, dynamic> newData = {
//         "taskDescription": taskDescription.value,
//         "imageUrl": imageFile != null
//             ? await _uploadImage(imageFile, title)
//             : null, // Upload image if available
//         "videoUrl": videoFile != null
//             ? await _uploadVideo(videoFile, title)
//             : null, // Upload video if available
//         "secondImageUrl": null,
//         "dateTime": Timestamp.fromDate(dateToSave), // Save dateTime as Firestore Timestamp
//         "voiceNoteUrl": voiceNoteUrl.value,
//         "uploadSpareParts": uploadSpareParts.value,
//         "location": Get.find<LocationController>().location.value, // Use location.value here
//         "randomId": randomId,
//         "userUid": userUid,
//         "selectedDateTime": dateToSave.toIso8601String(), // Store the selected date-time as ISO string
//         "userName": userName, // Add the logged-in user's name here
//         "title": title, // Add the logged-in user's name here
//       };
//
//       // Reference to the Firestore tasks collection
//       CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks');
//
//       // Query to check if any document contains the current user's UID
//       QuerySnapshot querySnapshot = await tasksCollection
//           .where("userUid", isEqualTo: userUid) // Check for the UID in the "userUid" field
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         // If a document exists with the current user's UID
//         DocumentReference existingDocRef = querySnapshot.docs.first.reference;
//
//         // Query bids collection to fetch offers for the task (related to the randomId and title)
//         QuerySnapshot bidSnapshot = await FirebaseFirestore.instance
//             .collection('bids')
//             .where('taskId', isEqualTo: randomId)  // Match the task using randomId
//             .where('title', isEqualTo: title) // Match by title as well
//             .get();
//
//         List<Map<String, dynamic>> bids = bidSnapshot.docs.map((bidDoc) {
//           final bidData = bidDoc.data() as Map<String, dynamic>;
//           return {
//             "bidAmount": bidData['bidAmount'] ?? "N/A",
//             "bidderId": bidData['bidderId'] ?? "",
//             "bidderName": bidData['firstName'] ?? "Unknown",
//           };
//         }).toList();
//
//         // Add bids to newData if any bids are found
//         if (bids.isNotEmpty) {
//           newData["bids"] = bids; // Store the bids in the task document
//         }
//
//         // Use Firestore's arrayUnion to append the new data to the existing array
//         await existingDocRef.update({
//           title: FieldValue.arrayUnion([newData]), // Append the new object to the array
//         });
//       } else {
//         // If no document exists with the current user's UID, create a new document
//         DocumentReference newDocRef = tasksCollection.doc(); // Firestore generates a random ID
//
//         // Initialize the new document with the userUid and the array for the given title
//         await newDocRef.set({
//           "userUid": userUid, // Store the current user's UID inside the document
//           title: [newData], // Create a new array field with the title as key
//         });
//       }
//
//       // Show success message with black and white theme
//       Get.snackbar(
//         "Success",
//         "Data saved successfully.",
//         backgroundColor: Colors.black,  // Black background
//         colorText: Colors.white,        // White text color
//       );
//       return true;
//     } catch (e) {
//       // Show error message with black and white theme
//       Get.snackbar(
//         "Error",
//         "Failed to save data: $e",
//         backgroundColor: Colors.black,  // Black background
//         colorText: Colors.white,        // White text color
//       );
//       return false;
//     }
//   }
//
//
//   // Generate a 4-digit random ID
//   String _generateRandomId() {
//     final random = Random();
//     return (1000 + random.nextInt(9000)).toString(); // Generates a 4-digit number
//   }
//
//   // Upload the image to Firebase Storage and return the URL
//   Future<String> _uploadImage(File image, String title) async {
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('$title/${DateTime.now().millisecondsSinceEpoch}');
//       final uploadTask = await storageRef.putFile(image);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       Get.snackbar("Error", "Failed to upload image.");
//       return "";
//     }
//   }
//
//   // Upload the video to Firebase Storage and return the URL
//   Future<String> _uploadVideo(File video, String title) async {
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('$title/${DateTime.now().millisecondsSinceEpoch}');
//       final uploadTask = await storageRef.putFile(video);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       Get.snackbar("Error", "Failed to upload video.");
//       return "";
//     }
//   }
//
//   // Record voice note
//   Future<void> recordVoiceNote() async {
//     var status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException('Microphone permission not granted');
//     }
//
//     await _recorder.openRecorder();
//
//     String path = await _getRecordingPath();
//     _audioFilePath = path;
//
//     await _recorder.startRecorder(toFile: path);
//
//     _isRecording = true;
//     _progressValue = 0.0;
//
//     _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
//       _progressValue += 100 / 60000; // Increment progress for 1 minute
//       if (_progressValue >= 1.0) {
//         stopRecording(); // Call stopRecording instead of _stopRecording
//       }
//     });
//   }
//
//   // Method to stop recording (public)
//   Future<void> stopRecording() async {
//     await _recorder.stopRecorder();
//     _progressTimer?.cancel();
//     _isRecording = false;
//     _progressValue = 0.0;
//
//     if (_audioFilePath != null) {
//       String downloadUrl = await _uploadVoiceNote(File(_audioFilePath!));
//       voiceNoteUrl.value = downloadUrl;
//     }
//   }
//
//   // Helper methods for uploading and getting file path are unchanged
//   Future<String> _uploadVoiceNote(File voiceNoteFile) async {
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('voiceNotes/${DateTime.now().millisecondsSinceEpoch}.aac');
//       final uploadTask = await storageRef.putFile(voiceNoteFile);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       Get.snackbar("Error", "Failed to upload voice note.");
//       return "";
//     }
//   }
//
//   Future<String> _getRecordingPath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return '${directory.path}/audio_recording.aac';
//   }
// }
//
// // Example location controller
// class LocationController extends GetxController {
//   var location = ''.obs;
//
//   void updateLocation(String newLocation) {
//     location.value = newLocation;
//   }
// }






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
  var images = RxList<File>(); // List of selected images
  var videos = RxList<File>(); // List of selected videos
  var voiceNoteUrl = Rx<String?>(null); // Observable for voice note URL
  var taskDescription = Rx<String>(""); // Observable for task description
  var uploadSpareParts = Rx<bool>(false); // Observable for spare parts upload status
  var location = ''.obs; // Observable location
  var isRecording = false.obs; // Observable for recording state
  var progressValue = 0.0.obs; // Observable for progress value
  var isLoading = false.obs; // Observable for loading state

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  Timer? _progressTimer;
  String? _audioFilePath; // Path to the recorded audio file
// Observable for recording state
  var recordingDuration = 0.obs; // Observable for recording time in seconds

  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  Timer? _recordingTimer; // Timer for recording duration
  @override
  void onInit() {
    super.onInit();
    _initializeRecorder();
    _initializePlayer();
  }

  @override
  void onClose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    _progressTimer?.cancel();
    _recordingTimer?.cancel();
    super.onClose();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> _initializePlayer() async {
    await _player.openPlayer();
  }

  // Record a voice note
  Future<void> recordVoiceNote() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    _audioFilePath = await _getRecordingPath();

    await _recorder.startRecorder(toFile: _audioFilePath);
    isRecording.value = true;
    progressValue.value = 0.0;
    recordingDuration.value = 0;

    // Timer for updating recording duration
    _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      recordingDuration.value++;
    });

    // Timer for progress indicator
    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      progressValue.value += 0.1 / 60;
    });
  }

  // Stop recording
  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    _progressTimer?.cancel();
    _recordingTimer?.cancel();
    isRecording.value = false;
    progressValue.value = 0.0;

    if (_audioFilePath != null) {
      voiceNoteUrl.value = await _uploadVoiceNote(File(_audioFilePath!));
    }
  }

  // Upload a voice note to Firebase Storage
  Future<String> _uploadVoiceNote(File voiceNoteFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('voiceNotes/${DateTime.now().millisecondsSinceEpoch}.aac');
      final uploadTask = await storageRef.putFile(voiceNoteFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", "Failed to upload voice note: $e");
      return "";
    }
  }

  // Get the path for the recorded file
  Future<String> _getRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/audio_recording.aac';
  }

  // Play the recorded voice note
  Future<void> playVoiceNote() async {
    if (voiceNoteUrl.value != null) {
      await _player.startPlayer(fromURI: voiceNoteUrl.value!);
    } else {
      Get.snackbar("Error", "No voice note to play.");
    }
  }

  // Delete the recorded voice note
  void deleteVoiceNote() {
    voiceNoteUrl.value = null;
    _audioFilePath = null;
  }
// Inside ServiceController
// Take a photo with the camera
  Future<void> takePhoto() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        images.add(File(pickedFile.path)); // Add the captured photo to the list
      } else {
        Get.snackbar("Info", "No photo taken.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to take photo: $e");
    }
  }

// Record a video with the camera
  Future<void> recordVideo() async {
    try {
      final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);
      if (pickedFile != null) {
        videos.add(File(pickedFile.path)); // Add the captured video to the list
      } else {
        Get.snackbar("Info", "No video recorded.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to record video: $e");
    }
  }


  // Pick multiple images from the gallery
  Future<void> pickImagesFromGallery() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();
      if (pickedFiles != null) {
        images.addAll(pickedFiles.map((e) => File(e.path)));
      } else {
        Get.snackbar("Info", "No images selected.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick images: $e");
    }
  }

  // Pick a video from the gallery
  Future<void> pickVideosFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        videos.add(File(pickedFile.path));
      } else {
        Get.snackbar("Info", "No video selected.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick a video: $e");
    }
  }

  // Take a photo with the camera

  // Remove a selected image
  void removeImage(File image) {
    images.remove(image);
  }

  // Remove a selected video
  void removeVideo(File video) {
    videos.remove(video);
  }
// Save data to Firestore
  Future<bool> saveDataToCollection({
    required String title,
    required List<File> imageFiles, // Accept multiple image files
    required List<File> videoFiles, // Accept multiple video files
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

      // Upload images and videos to Firebase Storage
      List<String> imageUrls = await _uploadImages(imageFiles, title);
      List<String> videoUrls = await _uploadVideos(videoFiles, title);

      // Create a new map of the data to be saved
      Map<String, dynamic> newData = {
        "taskDescription": taskDescription.value,
        "imageUrls": imageUrls.isNotEmpty ? imageUrls : null, // Save image URLs if available
        "videoUrls": videoUrls.isNotEmpty ? videoUrls : null, // Save video URLs if available
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
      CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

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
            .where('taskId', isEqualTo: randomId) // Match the task using randomId
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
        DocumentReference newDocRef =
        tasksCollection.doc(); // Firestore generates a random ID

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
        backgroundColor: Colors.black, // Black background
        colorText: Colors.white, // White text color
      );
      return true;
    } catch (e) {
      // Show error message with black and white theme
      Get.snackbar(
        "Error",
        "Failed to save data: $e",
        backgroundColor: Colors.black, // Black background
        colorText: Colors.white, // White text color
      );
      return false;
    }
  }

// Upload multiple images to Firebase Storage
  Future<List<String>> _uploadImages(List<File> images, String title) async {
    List<String> imageUrls = [];
    for (var image in images) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('$title/images/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = await storageRef.putFile(image);
        final url = await storageRef.getDownloadURL();
        imageUrls.add(url);
      } catch (e) {
        Get.snackbar("Error", "Failed to upload an image: $e");
      }
    }
    return imageUrls;
  }

// Upload multiple videos to Firebase Storage
  Future<List<String>> _uploadVideos(List<File> videos, String title) async {
    List<String> videoUrls = [];
    for (var video in videos) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('$title/videos/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = await storageRef.putFile(video);
        final url = await storageRef.getDownloadURL();
        videoUrls.add(url);
      } catch (e) {
        Get.snackbar("Error", "Failed to upload a video: $e");
      }
    }
    return videoUrls;
  }

  // Save data to Firestore
  // Future<bool> saveDataToCollection({
  //   required String title,
  //   required DateTime? selectedDateTime,
  // }) async {
  //   try {
  //     String randomId = _generateRandomId();
  //     DateTime dateToSave = selectedDateTime ?? DateTime.now();
  //     String userUid = FirebaseAuth.instance.currentUser!.uid;
  //
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('userDetails')
  //         .doc(userUid)
  //         .get();
  //
  //     String userName = userDoc.exists ? userDoc['userName'] : 'Unknown User';
  //
  //     List<String> imageUrls = await _uploadImages(images, title);
  //     List<String> videoUrls = await _uploadVideos(videos, title);
  //
  //     Map<String, dynamic> newData = {
  //       "taskDescription": taskDescription.value,
  //       "imageUrls": imageUrls,
  //       "videoUrls": videoUrls,
  //       "voiceNoteUrl": voiceNoteUrl.value,
  //       "uploadSpareParts": uploadSpareParts.value,
  //       "location": location.value,
  //       "randomId": randomId,
  //       "userUid": userUid,
  //       "selectedDateTime": dateToSave.toIso8601String(),
  //       "userName": userName,
  //       "title": title,
  //     };
  //
  //     CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks');
  //     await tasksCollection.add(newData);
  //
  //     Get.snackbar("Success", "Data saved successfully.");
  //     return true;
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to save data: $e");
  //     return false;
  //   }
  // }

  // Generate a 4-digit random ID
  String _generateRandomId() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  // Upload multiple images to Firebase Storage
  // Future<List<String>> _uploadImages(List<File> images, String title) async {
  //   List<String> imageUrls = [];
  //   for (var image in images) {
  //     try {
  //       final storageRef = FirebaseStorage.instance
  //           .ref()
  //           .child('$title/images/${DateTime.now().millisecondsSinceEpoch}');
  //       final uploadTask = await storageRef.putFile(image);
  //       final url = await storageRef.getDownloadURL();
  //       imageUrls.add(url);
  //     } catch (e) {
  //       Get.snackbar("Error", "Failed to upload an image: $e");
  //     }
  //   }
  //   return imageUrls;
  // }
  //
  // // Upload multiple videos to Firebase Storage
  // Future<List<String>> _uploadVideos(List<File> videos, String title) async {
  //   List<String> videoUrls = [];
  //   for (var video in videos) {
  //     try {
  //       final storageRef = FirebaseStorage.instance
  //           .ref()
  //           .child('$title/videos/${DateTime.now().millisecondsSinceEpoch}');
  //       final uploadTask = await storageRef.putFile(video);
  //       final url = await storageRef.getDownloadURL();
  //       videoUrls.add(url);
  //     } catch (e) {
  //       Get.snackbar("Error", "Failed to upload a video: $e");
  //     }
  //   }
  //   return videoUrls;
  // }


}

// Example location controller
class LocationController extends GetxController {
  var location = ''.obs;

  void updateLocation(String newLocation) {
    location.value = newLocation;
  }
}