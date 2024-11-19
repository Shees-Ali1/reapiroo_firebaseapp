import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../const/color.dart';
import '../../../const/text_styles.dart';
import '../../../controllers/signup_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/otp_backbutton.dart';
import '../../bottom_nav/bottom_nav.dart';
import '../../home_screen_for_tech/Home_screen.dart';
import '../../home_screens_for_customers/customer_main_home.dart';

class OtpAuthenticationView extends StatefulWidget {
  final String initialVerificationId; // Initial verificationId received
  final String docId; // Phone number for user reference

  const OtpAuthenticationView({
    super.key,
    required this.initialVerificationId,
    required this.docId,
  });

  @override
  State<OtpAuthenticationView> createState() => _OtpAuthenticationViewState();
}

class _OtpAuthenticationViewState extends State<OtpAuthenticationView> {
  TextEditingController controller = TextEditingController();

  String userRole = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController userVM = Get.put(UserController());
  final SignupController signupController = Get.put(SignupController());
  bool isLoading = false;
  late String verificationId; // Mutable verificationId
  Future<void> verifyOTP() async {
    try {
      signupController.isLoading.value=true;
      String otpCode = controller.text.trim();
      if (otpCode.isEmpty || otpCode.length != 6) {
        Get.snackbar('Invalid OTP', 'Please enter a valid 6-digit OTP.',
            backgroundColor: Colors.white, colorText: Colors.black);
        return;
      }

      bool isPhoneNumberValid = await checkPhoneNumberMatch();
      if (!isPhoneNumberValid) {
        Get.snackbar('Error', 'Phone number does not match with our records.',
            backgroundColor: Colors.white, colorText: Colors.black);
        return;
      }
// Print OTP in debug mode only
      if (kDebugMode) {
        print('Entered OTP: $otpCode'); // Will print in debug mode
      }
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.initialVerificationId, smsCode: otpCode);

      await _auth.signInWithCredential(credential);
      Get.snackbar('Verified', 'Phone number successfully verified.',
          backgroundColor: Colors.white, colorText: Colors.black);

      await FirebaseFirestore.instance
          .collection('UserOtp')
          .doc(widget.docId)
          .update({
        'otpCode': otpCode,
        'verified': true,
      });
    } catch (e) {
      signupController.isLoading.value=true;

      print('Error verifying OTP: $e');
      Get.snackbar('Error', 'Failed to verify OTP. Please try again.',
          backgroundColor: Colors.white, colorText: Colors.black);
    }finally{
      signupController.isLoading.value=false;

    }
  }

  Future<bool> checkPhoneNumberMatch() async {
    try {
      String phoneNumberToCheck = widget.docId.replaceFirst(RegExp(r'^\+?[0-9]{1,2}'), '');

      print('Checking phone number: $phoneNumberToCheck');

      // Check in 'userDetails' collection
      var userDetailsSnapshot = await _firestore
          .collection('userDetails')
          .where('phoneNumber', isEqualTo: phoneNumberToCheck)
          .get();

      print('Fetched userDetails docs: ${userDetailsSnapshot.docs.map((doc) => doc.data())}');

      if (userDetailsSnapshot.docs.isNotEmpty) {
        var userDetailsDoc = userDetailsSnapshot.docs.first;
        String role = userDetailsDoc['role'];
        print('Phone number found in userDetails collection. Role: $role');
        navigateToRole(role);
        return true;
      }

      // Check in 'tech' collection
      var techSnapshot = await _firestore
          .collection('tech_users')
          .where('phoneNumber', isEqualTo: phoneNumberToCheck)
          .get();

      print('Fetched tech docs: ${techSnapshot.docs.map((doc) => doc.data())}');

      if (techSnapshot.docs.isNotEmpty) {
        var techDoc = techSnapshot.docs.first;
        String role = techDoc['role'];
        print('Phone number found in tech collection. Role: $role');
        navigateToRole(role);
        return true;
      }

      print('Phone number not found in either collection');
      Get.snackbar('Error', 'Phone number not found in either collection.');
      return false;
    } catch (e) {
      print('Error checking phone number: $e');
      Get.snackbar('Error', 'Failed to verify phone number. Please try again.');
      return false;
    }
  }


// Helper method for navigation
  void navigateToRole(String role) {
    if (role == 'Customer') {
      Get.offAll(() => AppNavBar(userRole: 'Customer'));
    } else if (role == 'Tech') {
      Get.offAll(() => AppNavBar(userRole: 'Tech'));
    }
  }


  @override
  void initState() {
    super.initState();
    // print('phonenumber${otpCode}');

    verificationId =
        widget.initialVerificationId; // Initialize with the initial value
  }

  // Function to resend OTP

  Future<void> resendOtp() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.docId,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-sign in (optional)
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message ?? 'OTP resend failed.',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            verificationId = verificationId; // Update the verification ID
          });
          Get.snackbar('Success', 'OTP resent successfully.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Update the verification ID in case of timeout
          setState(() {
            verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Unable to resend OTP. Please try again.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('verificationId${widget.initialVerificationId}');
    print('phonenumber${widget.docId}');
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              const OtpBackButtonWidget(),
              SizedBox(height: 8.h),
              Divider(
                thickness: 2,
                height: 1,
                color: const Color.fromRGBO(188, 202, 214, 0.23),
              ),
              SizedBox(height: 25.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Enter OTP',
                        style: jost600(26.54.sp, AppColors.secondary)),
                    SizedBox(height: 8.h),
                    Text(
                      'Enter the 6-digit code sent to ${widget.docId}',
                      textAlign: TextAlign.center,
                      style: jost600(15.17.sp, const Color(0xff6B7280)),
                    ),
                    SizedBox(height: 42.h),
                    PinCodeTextField(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 22.sp,
                      ),
                      appContext: context,
                      length: 6,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.scale,
                      controller: controller,
                      pinTheme: PinTheme(
                        borderRadius: BorderRadius.circular(11.38.r),
                        borderWidth: 1,
                        activeFillColor: AppColors.secondary,
                        shape: PinCodeFieldShape.box,
                        activeColor: AppColors.secondary,
                        selectedColor: AppColors.secondary,
                        inactiveColor: AppColors.secondary.withOpacity(0.5),
                        fieldHeight: 45.h,
                        fieldWidth: 45.w,
                      ),
                    ),
                    SizedBox(height: 72.h),
                    CustomElevatedButton(
                            text: 'Continue',
                            textColor: AppColors.primary,
                            onPressed: verifyOTP,
                            backgroundColor: AppColors.secondary,
                          ),
                    SizedBox(height: 10.h),
                    CustomElevatedButton(
                      borderSide:
                          const BorderSide(color: Color(0xffBDD0EA), width: 1),
                      text: 'Resend Code',
                      textColor: AppColors.secondary,
                      onPressed: resendOtp,
                    ),
                    SizedBox(height: 12.25.h),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
