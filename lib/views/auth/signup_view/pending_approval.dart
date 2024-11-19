import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/views/auth/login_view/login_screen.dart';
import 'package:repairoo/views/bottom_nav/bottom_nav.dart';
import 'package:repairoo/widgets/custom_button.dart';

class PendingApproval extends StatelessWidget {
  const PendingApproval({super.key});

  // A placeholder function to check if the account is verified
  bool isAccountVerified() {
    // Replace this with the actual logic for checking account verification
    return true; // Assuming the account is not verified
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Pending Approval',
                style: jost600(32.sp, Color(0xff6B7280)),
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              'Thank you for registering with Repairoo. A member of the team will approve your request shortly.',
              textAlign: TextAlign.center,
              style: jost400(20.sp, Color(0xff656F77)),
            ),
            SizedBox(height: 80.h),
            Image.asset(AppImages.logo),
            SizedBox(height: 142.h),
            CustomElevatedButton(
              text: 'Go Home',
              textColor: AppColors.secondary,
              onPressed: () {
                if (isAccountVerified()) {
                  Get.offAll(() => LoginScreen());
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text('Account Not Verified'),
                        content: Text(
                          'Your account has not been verified. Please contact us for assistance.',
                          style: jost400(18.sp, Color(0xff656F77)),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Close',
                              style: TextStyle(color: AppColors.primary),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
