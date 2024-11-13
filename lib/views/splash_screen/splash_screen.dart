import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/images.dart';

import '../on_boarding/main_onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // AuthController authController = Get.find<AuthController>();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  // void initState() {
  //   // TODO: implement initState
  //   Future.delayed(Duration(seconds: 1), () {
  //     if (SharedPrefs.containKey("appOpenForFirstTime")) {
  //       if (SharedPrefs.getPrefsBool("loggedIn") &&
  //           SharedPrefs.containKey("userId") && _auth.currentUser != null) {
  //         authController.getUserData(SharedPrefs.getPrefsString("userId"));
  //         CustomRoute.navigateTo(context, AppNavBar());
  //       } else {
  //         CustomRoute.navigateTo(context, LoginView());
  //       }
  //     } else {
  //       SharedPrefs.setPrefsBool("appOpenForFirstTime", true);
  //       CustomRoute.navigateTo(context, MainOnBoardingView());
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(() => MainOnBoardingView());
    });
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(
            height: 120,
          ),
          Center(
            child: Image.asset(
              // fit:BoxFit.cover,
              AppImages.splash_logo2,
              height: 237.h,
              width: 237.w,
            ),
          ),
          Spacer(),
          Center(
            child: Image.asset(
              AppImages.splash_logo,
              height: 180.h,
              width: 180.w,
            ),
          )
        ],
      ),
    );
  }
}
