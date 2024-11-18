import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive variables for user details
  RxString selectedIndex = "0".obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString bio = ''.obs;
  RxString selectedGender = ''.obs;
  RxSet<String> selectedServices = <String>{}.obs; // Selected services
  RxList<String?> documentPaths = <String?>[].obs; // Uploaded document paths

  // Update Methods
  void updateUserDetails({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String? gender,
  }) {
    firstName.value = firstname;
    lastName.value = lastname;
    this.email.value = email;
    this.password.value = password;
    selectedGender.value = gender ?? '';
  }

  void updateBio(String bioDescription) {
    bio.value = bioDescription;
  }

  void updateGender(String? gender) {
    if (gender != null) {
      selectedGender.value = gender;
    }
  }

  void updateSelectedServices(Set<String> services) {
    selectedServices.value = services;
  }

  void updateDocuments(List<String?> documents) {
    documentPaths.assignAll(documents);
  }

  // Method to save user details in Firebase
  Future<void> saveTechUser() async {
    try {
      // Validate required fields
      if (selectedGender.value.isEmpty) throw Exception("Gender not selected.");
      if (documentPaths.isEmpty || documentPaths[0] == null || documentPaths[1] == null) {
        throw Exception("Profile Picture and Emirates ID are required.");
      }

      // Step 1: Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      // Get the user ID from Firebase Authentication
      String uid = userCredential.user?.uid ?? '';

      // Step 2: Save all user data into one document in Firestore
      Map<String, dynamic> userData = {
        'uid': uid,
        'firstName': firstName.value,
        'lastName': lastName.value,
        'email': email.value,
        'gender': selectedGender.value,
        'bio': bio.value,
        'services': selectedServices.toList(),
        'documents': documentPaths, // Save document paths as a list
        'role': 'Tech', // Store the role as "Tech"
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('tech_users').doc(uid).set(userData);

      // Success message
      Get.snackbar(
        'Success',
        'User registered successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Error handling
      print("Error saving user data: $e");
      Get.snackbar(
        'Error',
        'Failed to save user details: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Future<void> saveTechUser() async {
  //   try {
  //     // Validate required fields
  //     if (selectedGender.value.isEmpty) throw Exception("Gender not selected.");
  //     if (documentPaths.isEmpty || documentPaths[0] == null || documentPaths[1] == null) {
  //       throw Exception("Profile Picture and Emirates ID are required.");
  //     }
  //
  //     // Step 1: Create user in Firebase Authentication
  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email.value,
  //       password: password.value,
  //     );
  //
  //     // Get the user ID from Firebase Authentication
  //     String uid = userCredential.user?.uid ?? '';
  //
  //     // Step 2: Save all user data into one document in Firestore
  //     Map<String, dynamic> userData = {
  //       'uid': uid,
  //       'firstName': firstName.value,
  //       'lastName': lastName.value,
  //       'email': email.value,
  //       'gender': selectedGender.value,
  //       'bio': bio.value,
  //       'services': selectedServices.toList(),
  //       'documents': documentPaths, // Save document paths as a list
  //       'createdAt': FieldValue.serverTimestamp(),
  //     };
  //
  //     await _firestore.collection('tech_users').doc(uid).set(userData);
  //
  //     // Success message
  //     Get.snackbar(
  //       'Success',
  //       'User registered successfully!',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );
  //   } catch (e) {
  //     // Error handling
  //     print("Error saving user data: $e");
  //     Get.snackbar(
  //       'Error',
  //       'Failed to save user details: ${e.toString()}',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

}
