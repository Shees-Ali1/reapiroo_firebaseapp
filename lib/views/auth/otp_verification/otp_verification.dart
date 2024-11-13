import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:repairoo/views/auth/login_view/login_screen.dart';

import '../../../const/color.dart';
import '../../../const/text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/otp_backbutton.dart';
import '../signup_view/role_screen.dart';

class OtpAuthenticationView extends StatefulWidget {
  // final String email;
  final String verificationId;
  final String docId;
  OtpAuthenticationView({
    super.key,required this.verificationId, required this.docId,
  });

  @override
  State<OtpAuthenticationView> createState() => _OtpAuthenticationViewState();
}

class _OtpAuthenticationViewState extends State<OtpAuthenticationView> {
  // AuthController authController = Get.find<AuthController>();

  TextEditingController controller = TextEditingController();
  // final selectedTypeController = Get.put(SelectedTypeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              const OtpBackButtonWidget(),
              SizedBox(
                height: 8.h,
              ),
              Divider(
                thickness: 2,
                height: 1,
                color: Color.fromRGBO(188, 202, 214, 0.23),
              ),
              SizedBox(
                height: 25.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Enter OTP',
                      style: jost600(26.54.sp, AppColors.secondary),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      'Enter 5-digit code we just texted to your phone number',
                      style: jost600(15.17.sp, Color(0xff6B7280)),
                    ),
                    SizedBox(
                      height: 42.h,
                    ),
                    PinCodeTextField(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 22.sp),
                      appContext: context,
                      length: 5,
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
                          fieldHeight: 53.h,
                          fieldWidth: 53.w),
                    ),
                    SizedBox(
                      height: 72.h,
                    ),
                    CustomElevatedButton(
                      text: 'Continue',
                      textColor: AppColors.primary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RoleScreen(); // Replace with your desired screen/widget
                            },
                          ),
                        );
                      },
                      backgroundColor:
                          AppColors.secondary, // Custom background color
                    ),
                    SizedBox(height: 10.h,),
                    CustomElevatedButton(
                      borderSide: BorderSide(color: Color(0xffBDD0EA),width: 1),
                      text: 'Resend Code',
                      textColor: AppColors.secondary,
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return OtpAuthenticationView(); // Replace with your desired screen/widget
                        //     },
                        //   ),
                        // );
                      },
                      // backgroundColor:
                      //     AppColors.secondary, // Custom background color
                    ),
                    SizedBox(
                      height: 12.25.h,
                    ),
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
