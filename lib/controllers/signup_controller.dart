import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairoo/views/auth/login_view/login_screen.dart';

import '../views/auth/otp_verification/otp_verification.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;
  var selectedIndex = 0.obs;
  var userRole = ''.obs;
  var selectedGender = ''.obs;

  RxString VerificationId = ''.obs;
  void updateGender(String? gender) {
    selectedGender.value = gender ?? ''; // Update the selected gender
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();

  File? imageFile; // Store the image path
  var uploadedImageUrl = ''.obs; // Store the uploaded image URL

  void pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path); // Store the selected image file
      // imagePath.value = pickedFile.path; // Update observable for UI
      await uploadImage(pickedFile);
      update(); // Notify listeners about the change if using GetX
    }
  }

// Function to upload image to Firebase Storage and get the URL
  Future<void> uploadImage(XFile imageFile) async {
    try {
      // Create a reference to the Firebase Storage location
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}'; // Unique file name
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName);

      // Convert XFile to File and upload
      File fileToUpload = File(imageFile.path); // Get the path from XFile
      UploadTask uploadTask = storageReference.putFile(fileToUpload);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      // Optionally: Use the imageUrl as needed, e.g., save to Firestore or display
    } catch (e) {
      Get.snackbar("Error", "Image upload failed: $e"); // Show error message
    }
  }

  Future<void> signup() async {
    try {
      isLoading.value = true;

      // Step 1: Firebase Authentication - Sign in with phone number
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: phonenumber.text);
      await saveUserData(FirebaseAuth.instance.currentUser!.uid);
      Get.offAll(LoginScreen());
      name.clear();
      email.clear();
      phonenumber.clear();
    } catch (e) {
      // Handle signup error
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.white, colorText: Colors.black);
    } finally {
      isLoading.value = false;
    }
  }

  void sendOTP(String phoneNumber) async {
    try {
      // setOtp(true);
      print('PhoneNumbers added: ${phoneNumber}');

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.snackbar(
            'Verified',
            'Phone number automatically verified and user signed in: ${credential}',
            backgroundColor: Colors.white,
            colorText: Colors.white,
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar(
            'Verification Failed',
            'Verification failed. Code: ${e.code}. Message: ${e.message}',
            backgroundColor: Colors.white,
            colorText: Colors.black,
          );
          // setOtp(false);
          print('Verification failed. Code: ${e.code}. Message: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) async {
          VerificationId.value = verificationId;
          Get.snackbar(
            'OTP Sent',
            'A 6-digit OTP has been sent to your phone',
            backgroundColor: Colors.white,
            colorText: Colors.black,
          );

          // Save the verification ID to Firestore
          await FirebaseFirestore.instance
              .collection('UserOtp')
              .doc(phoneNumber)
              .set({
            'verificationId': verificationId,
            'timestamp': FieldValue.serverTimestamp(),
            'userId': FirebaseAuth.instance.currentUser?.uid,
          });

          // setOtp(false);
          Get.to(() => OtpAuthenticationView(
              verificationId: verificationId, docId: phoneNumber));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
    VerificationId.value = verificationId;
          // setOtp(false);
        },
      );
    } catch (e) {
      // setOtp(false);
      print('Error sending OTP: $e');
    }
  }

  Future<void> saveUserData(String uid) async {
    await _firestore.collection('userDetails').doc(uid).set({
      'userId': uid,
      'userName': name.text,
      'userEmail': email.text,
      'gender': selectedGender.value,
      'phoneNumber': phonenumber.text,
      'image': uploadedImageUrl.value.isNotEmpty ? uploadedImageUrl.value : '',
      'role': userRole.value, // Store the selected role
    });

    // Success message and navigation
    Get.snackbar("Success", "Signup successful!",
        backgroundColor: Colors.white, colorText: Colors.black);
    name.clear();
    email.clear();
    phonenumber.clear();
    // uploadedImageUrl.value='';
  }
}
