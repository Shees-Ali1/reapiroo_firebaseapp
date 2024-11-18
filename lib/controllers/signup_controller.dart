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
    selectedGender.value = gender ?? ''; // Update the selected gender
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
  final TextEditingController password = TextEditingController();

  var imageFile = Rxn<File>(); // Declare as Rxn<File>() for reactivity

  var uploadedImageUrl = ''.obs; // Store the uploaded image URL

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path); // Update reactively
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

  // Function to upload image to Firebase Storage and get the URL
  Future<void> uploadImage(String userId) async {
    if (imageFile.value == null) return; // Exit if no image selected
    try {
      isLoading.value = true;

      // Get a reference to the Firebase Storage location
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg'); // Customize the file name as needed

      // Upload the image
      UploadTask uploadTask = storageReference.putFile(imageFile.value!);
      TaskSnapshot taskSnapshot = await uploadTask;
      // Get the download URL of the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      uploadedImageUrl.value = imageUrl; // Update the URL reactively
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    try {
      isLoading.value = true;

      // Step 1: Firebase Authentication - Sign in with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);

      // Step 2: Upload user data
      await saveUserData(FirebaseAuth.instance.currentUser!.uid);

      // Step 3: Navigate to login screen
      Get.offAll(LoginScreen());

      // Clear text fields
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
    // Ensure the phone number is not empty, starts with "+92", and is of correct length
    if (phoneNumber.isEmpty || !phoneNumber.startsWith('+92') || phoneNumber.length != 13) {
      Get.snackbar(
        'Invalid Phone Number',
        'Please enter a valid Pakistani phone number with the country code +92 (e.g., +923001234567).',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return;
    }

    try {
      print('Phone number added: $phoneNumber');

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
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

          Get.to(() => OtpAuthenticationView(
              verificationId: verificationId, docId: phoneNumber));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          VerificationId.value = verificationId;
        },
      );
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }

  Future<void> saveUserData(String uid) async {
    await _firestore.collection('userDetails').doc(uid).set({
      'userId': uid,
      'userName': name.text,
      'userEmail': email.text,
      'password': password.text,
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
  }
}
