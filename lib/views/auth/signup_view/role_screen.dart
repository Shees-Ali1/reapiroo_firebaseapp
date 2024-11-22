import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/controllers/signup_controller.dart';
import 'package:repairoo/controllers/user_controller.dart';
import 'package:repairoo/views/auth/signup_view/tech_signup.dart';

import '../../../const/color.dart';
import '../../../const/images.dart';
import '../../../widgets/custom_button.dart';
import 'customer_signup.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  final UserController userVM = Get.find<UserController>();
  final SignupController signupController = Get.find<SignupController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
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
                SizedBox(height: 98.h),
                Text(
                  'Select Role',
                  style: jost700(35.sp, AppColors.secondary),
                ),
                SizedBox(height: 58.h),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    signupController.userRole.value = "Customer";
                    signupController.selectedIndex.value = 0;
                    if (kDebugMode) {
                      print(signupController.userRole.value);
                    }

                  },
                  child: buildContainer(
                    'Customer',
                    AppImages.Customer,
                    isSelected: signupController.selectedIndex == 0,
                  ),
                ),
                SizedBox(
                  width: 19.w,
                ),
                GestureDetector(
                  onTap: () {
                    signupController.userRole.value = "Tech";
                    signupController.selectedIndex.value = 1;
                  },
                  child: buildContainer(
                    'Tech',
                    AppImages.Engineer,
                    isSelected: signupController.selectedIndex == 1,
                  ),
                ),
              ],
            );
          }),
          SizedBox(
            height: 33.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomElevatedButton(
              text: 'Continue',
              textColor: AppColors.secondary,
              onPressed: () {
                if (signupController.selectedIndex.value == 0) {
                  // Navigate to Customer Signup
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerSignup(),
                    ),
                  );
                } else if (signupController.selectedIndex.value == 1) {
                  // Navigate to Tech Signup
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TechSignup(),
                    ),
                  );
                }
              },
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
          )
        ],
      ),
    );
  }
}

Widget buildContainer(String text, String image, {bool isSelected = false}) {
  return Container(
    width: 146.w,
    height: 167.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      border: isSelected
          ? Border.all(color: AppColors.primary, width: 1)
          : Border.all(color: Colors.transparent, width: 1),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              image: DecorationImage(
                scale: 5,
                image: AssetImage(image),
              ),
            ),
          ),
          SizedBox(
            height: 29.h,
          ),
          Text(
            text,
            style: jost700(16.sp, AppColors.primary),
          ),
        ],
      ),
    ),
  );
}
