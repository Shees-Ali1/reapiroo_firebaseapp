import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairoo/views/auth/login_view/login_screen.dart';
import 'package:repairoo/views/auth/otp_verification/otp_verification.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;
  var selectedIndex = 0.obs;
  var userRole = ''.obs;
  var selectedGender = ''.obs;
  RxString VerificationId = ''.obs;

  void updateGender(String? gender) {
    if (gender != null) {
      selectedGender.value = gender;
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
  final TextEditingController password = TextEditingController();

  Rx<File?> imageFile = Rx<File?>(null); // Reactive variable for the image file
  RxString uploadedImageUrl = ''.obs; // Reactive URL for the uploaded image

  Future<void> pickImageAndUpload(String userId) async {
    try {
      // isLoading.value = true; // Start loading

      // Pick image from gallery
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Update reactive variable with the selected file
        imageFile.value = File(pickedFile.path);

        // Prepare for Firebase Storage upload
        final String fileName =
            '${userId}_${DateTime.now().millisecondsSinceEpoch}';
        final Reference storageReference =
            FirebaseStorage.instance.ref().child('uploads/signup/$fileName');

        // Upload image to Firebase Storage
        final UploadTask uploadTask =
            storageReference.putFile(imageFile.value!);
        final TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL
        final String imageUrl = await taskSnapshot.ref.getDownloadURL();
        uploadedImageUrl.value = imageUrl; // Reactive URL update
        print('Image uploaded successfully: $imageUrl');
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error during image picking/uploading: $e');
    }
  }

  Future<bool> loginWithEmailPassword(String email, String password) async {
    try {
      // Your login logic here
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        return true; // Login successful
      } else {
        return false; // Login failed
      }
    } catch (e) {
      print('Error logging in: $e');
      return false; // Login failed
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

  Future<void> sendOTP(String phoneNumber, String role) async {
    try {
      isLoading.value=true;

      // Validate phone number
      if (phoneNumber.isEmpty || phoneNumber.length != 13) {

        Get.snackbar(
          'Invalid Phone Number',
          'Please enter a valid Pakistani phone number with the country code +92 (e.g., +923001234567).',
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
        return;
      }
      print('Phone number added: $phoneNumber');

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.back(); // Close loader
          Get.snackbar(
            'Verified',
            'Phone number automatically verified and user signed in: $credential',
            backgroundColor: Colors.white,
            colorText: Colors.black,
          );
        },
        verificationFailed: (FirebaseAuthException e) {

          Get.snackbar(
            'Verification Failed',
            'Verification failed. Code: ${e.code}. Message: ${e.message}',
            backgroundColor: Colors.white,
            colorText: Colors.black,
          );
          print('Verification failed. Code: ${e.code}. Message: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) async {
          Get.to(() => OtpAuthenticationView(
            initialVerificationId: verificationId,
            docId: phoneNumber,
          ));

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
            'userId': FirebaseAuth.instance.currentUser!.uid,
            // 'role': role,
          });

        },
        codeAutoRetrievalTimeout: (String verificationId) {
          VerificationId.value = verificationId;
        },
      );
    } catch (e) {
      isLoading.value = false;

      print('Error sending OTP: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    } finally {
      isLoading.value = false;

    }
  }


  Future<void> saveUserData(String uid) async {
    await _firestore.collection('userDetails').doc(uid).set({
      'userId': uid,
      'userName': name.text,
      'userEmail': email.text,
      // 'password': password.text,
      'gender': selectedGender.value,
      'phoneNumber': phonenumber.text,
      'image': uploadedImageUrl.value.isNotEmpty ? uploadedImageUrl.value : '',
      'role': userRole.value, // Store the selected role
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Success message and navigation
    Get.snackbar("Success", "Signup successful!",
        backgroundColor: Colors.white, colorText: Colors.black);
    name.clear();
    email.clear();
    phonenumber.clear();
  }
}
