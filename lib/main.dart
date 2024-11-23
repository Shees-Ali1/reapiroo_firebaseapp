import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/controllers/audio_controller.dart';
import 'package:repairoo/controllers/home_controller.dart';
import 'package:repairoo/controllers/servicecontroller.dart';
import 'package:repairoo/controllers/user_controller.dart';
import 'package:repairoo/views/auth/signup_view/role_screen.dart';
import 'package:repairoo/views/splash_screen/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Lock the app in portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Get.put(UserController());
  Get.put(AudioController());
  // Get.put(PhoneAuthController());
  Get.put(TechHomeController());
  Get.put(HomeController());
  Get.put(ServiceController());
  Get.put(LocationController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: ScreenUtilInit(
          designSize: const Size(360, 800),
          builder: (_, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
              // initialBinding: UserBinding(),
            );
          }),
    );
  }
}
