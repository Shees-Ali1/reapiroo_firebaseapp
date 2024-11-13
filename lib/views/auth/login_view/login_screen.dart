import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/views/auth/otp_verification/otp_verification.dart';

import '../../../const/color.dart';
import '../../../const/images.dart';
import '../../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // FocusNode _phoneFocusNode = FocusNode();
  // @override
  // void dispose() {
  //   _phoneFocusNode
  //       .dispose(); // Dispose of the focus node when the widget is disposed
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 110.h,
              ),
              Center(
                child: Image.asset(
                  height: 85.h,
                  width: 237.w,
                  AppImages.logo,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 64.h,
              ),
              Text(
                'Login or Signup',
                style: jost700(35.sp, AppColors.secondary),
              ),
              SizedBox(
                height: 91.h,
              ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: IntlPhoneField(

              flagsButtonPadding: EdgeInsets.only(left: 13.w),
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              showDropdownIcon: false,
              decoration: InputDecoration(
                hintText: '0551234567',
                filled: true,
                fillColor: Color(0xffFAFAFA),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                counterText: '',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'jost',
                  fontSize: 14.65.sp,
                  fontWeight: FontWeight.w400,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.31.r),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.31.r),
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.31.r),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              initialCountryCode: 'AE',
              onChanged: (phone) {
                print(phone.completeNumber);
              },
            ),
          ),

          SizedBox(
                height: 76.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomElevatedButton(
                  text: 'Login',
                  textColor: AppColors.primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return OtpAuthenticationView(); // Replace with your desired screen/widget
                        },
                      ),
                    );

                    // Button action
                  },

                  backgroundColor:
                      AppColors.secondary, // Custom background color
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
