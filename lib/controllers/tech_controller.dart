import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString selectedIndex = "0".obs;
  RxString selectedGender = ''.obs;


  // Method to update gender
  void updateGender(String? gender) {
    if (gender != null) {
      selectedGender.value = gender;
    }
  }

  // Method to save user details in Firebase
  Future<void> saveTechUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password, // Add password for authentication
  }) async {
    try {
      if (selectedGender.value.isEmpty) {
        throw Exception("Gender not selected");
      }

      // Step 1: Create user in Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID from Firebase Authentication
      String uid = userCredential.user?.uid ?? '';

      // Step 2: Save user details in Firestore
      await _firestore.collection('tech_users').doc(uid).set({
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password':password,
        'gender': selectedGender.value,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'User details saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
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
}