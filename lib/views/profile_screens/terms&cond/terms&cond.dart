import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/widgets/app_bars.dart';

class Termscond extends StatelessWidget {
  const Termscond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: MyAppBar(
        isMenu: false,
        isNotification: false,
        isTitle: true,
        isSecondIcon: false,
        title: 'Terms & conditions',
        onBackTap: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Repairoo!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'These Terms and Conditions outline the rules and regulations for the use of Repairoo. By accessing and using our app, you agree to these terms. Do not continue to use Repairoo if you do not agree to all the terms and conditions stated on this page.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. User Responsibilities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Users are responsible for ensuring that the information they provide is accurate and up-to-date. Misuse of our platform may lead to suspension of access.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '2. Limitations of Liability',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Repairoo is not liable for any damages arising out of or in connection with the use of our app. We are not responsible for service interruptions or data inaccuracies.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '3. Changes to Terms',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Repairoo reserves the right to revise these terms at any time. We encourage you to review this page periodically for any changes.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have any questions about these Terms and Conditions, please contact us at support@repairoo.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
