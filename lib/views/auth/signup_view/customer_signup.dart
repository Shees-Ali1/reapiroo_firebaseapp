import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:repairoo/controllers/signup_controller.dart';
import 'package:repairoo/views/bottom_nav/bottom_nav.dart';

import '../../../const/color.dart';
import '../../../const/images.dart';
import '../../../const/text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_input_fields.dart';
import '../../../widgets/drop_down_widget.dart';

class CustomerSignup extends StatefulWidget {
  const CustomerSignup({super.key});

  @override
  State<CustomerSignup> createState() => _CustomerSignupState();
}

class _CustomerSignupState extends State<CustomerSignup> {

  final SignupController signupController = Get.find<SignupController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signupController.phonenumber.clear();
    signupController.email.clear();
    signupController.password.clear();

    signupController.name.clear();
    signupController.selectedGender.value ='';
    // signupController.imageFile?.clear();
  }


  // void _showImageSourceDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(
  //           "Choose an Option",
  //           style: jost400(16, AppColors.primary),
  //         ),
  //         content: SizedBox(
  //           // Wrap content in a SizedBox to limit height and improve layout
  //           width: double.maxFinite,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   signupController.pickImage(ImageSource.gallery); // Pick image from gallery
  //                 },
  //                 child: Text('Gallery', style: jost400(14.sp, AppColors.primary)),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   signupController.pickImage(ImageSource.camera); // Take photo with camera
  //                 },
  //                 child: Text('Camera', style: jost400(14.sp, AppColors.primary)),
  //               ),
  //             ],
  //           ),
  //         ),
  //         backgroundColor: AppColors.secondary,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print(signupController.userRole.value);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Close the keyboard when tapping outside
      },
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImages.onboardingelipse2),
                        fit: BoxFit.fill)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    SizedBox(
                      height: 85.h,
                      width: 267.w,
                      child: Image.asset(
                        color: Colors.white,
                        AppImages.logo,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      'Sign up',
                      style: jost700(35.sp, AppColors.secondary),
                    ),
                    SizedBox(height: 30.h),
                    GestureDetector(
                      onTap: () => signupController.pickImage(),
                      child: Obx(
                            () => Container(
                          width: 106.w,
                          height: 106.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: signupController.imageFile.value != null
                                ? DecorationImage(
                              image: FileImage(signupController.imageFile.value!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: signupController.imageFile.value == null
                              ? Center(
                            child: SizedBox(
                              height: 50.h,
                              width: 50.w,
                              child: Image.asset(
                                AppImages.upload_img,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                              : null,
                        ),
                      ),
                    ),




                    SizedBox(height: 30.h),
                  ],
                ),
              ),
              SizedBox(height: 48.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomInputField(
                  label: 'Full name',
                  controller: signupController.name,
                  prefixIcon: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 18.sp,
                  ), // Add prefix icon here
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomInputField(
                  label: 'Your email',
                  controller: signupController.email,
                  prefixIcon: Icon(
                    Icons.email_rounded,
                    color: AppColors.primary,
                    size: 18.sp,
                  ), // Add prefix icon here
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: IntlPhoneField(

                  controller: signupController.phonenumber,
                  flagsButtonPadding: EdgeInsets.only(left: 13.w),
                  cursorColor: Colors.black,
                  style: TextStyle(color: Colors.black),
                  showDropdownIcon: false,
                  decoration: InputDecoration(

                    hintText: 'Your phone number',
                    filled: true,
                    fillColor: Color(0xffFAFAFA),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 14.h),
                    counterText: '',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'jost',
                      fontSize: 14.65.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.31.r),
                      borderSide: BorderSide(color: Color(0xffE2E2E2),width: 0.95),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.31.r),
                      borderSide: BorderSide(color: Color(0xffE2E2E2),width: 0.95),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.31.r),
                      borderSide: BorderSide(color: Color(0xffE2E2E2),width: 0.95),
                    ),
                  ),
                  initialCountryCode: 'AE',
                  onChanged: (phone) {
                    try {
                      debugPrint("Phone number entered: ${phone.completeNumber}");
                    } catch (e) {
                      debugPrint("Error processing phone number: $e");
                    }
                  },
                ),
              ),
              SizedBox(height: 16.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomInputField(
                  label: 'Password',
                  controller: signupController.password,
                  obscureText: true, // Hide the password text
                  prefixIcon: Icon(
                    Icons.lock,
                    color: AppColors.primary,
                    size: 18.sp,
                  ), // Add prefix icon here
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: GenderDropdownField(
                  label: 'Gender',
                  iconPath:
                  'assets/images/gender_icon.png', // Specify the image asset path
                  iconHeight: 18.h, // Set your desired height
                  iconWidth: 18.w, // Set your desired width
                ),
              ),
              SizedBox(
                height: 33.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomElevatedButton(
                  // borderSide: BorderSide(color: Color(0xffBDD0EA),width: 1),
                  text: 'Continue',
                  textColor: AppColors.secondary,
                  onPressed: signupController.signup,
                  backgroundColor: AppColors.primary, // Custom background color
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By signing up you agree to our ',
                        style: jost400(14.sp, AppColors.primary),
                      ),
                      TextSpan(
                        text: 'Terms of Services',
                        style: jost500(14.sp, AppColors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to Terms of Services
                            // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => TermsPage()));
                          },
                      ),
                      TextSpan(
                        text: ' and ',
                        style: jost400(14.sp, AppColors.primary),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: jost500(14.sp, AppColors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to Privacy Policy
                            // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
                          },
                      ),
                      TextSpan(
                        text: '.',
                        style: jost400(14.sp, AppColors.primary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
