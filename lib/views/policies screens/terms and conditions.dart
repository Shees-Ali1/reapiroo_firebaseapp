import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:repairoo/widgets/app_bars.dart';

import '../../const/color.dart';




class TermsCondition extends StatefulWidget {
  const TermsCondition({super.key});

  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        isMenu: false,
        isNotification: false,
        isTitle: true,
        isSecondIcon: false,
        title: 'Terms and Conditions',
        onBackTap: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Introduction',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Welcome to [Your Bank Name]! By using our app, you agree to comply with and be bound by the following terms and conditions. Please read them carefully before using our services.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'User Responsibilities',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '1. Users must ensure the confidentiality of their login credentials.\n'
                  '2. Unauthorized use of your account is your responsibility.\n'
                  '3. Transactions conducted using your account are assumed to be authorized by you.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Prohibited Activities',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '1. Using the app for illegal or unauthorized purposes.\n'
                  '2. Attempting to compromise the app’s security.\n'
                  '3. Transmitting harmful or malicious software.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Service Limitations',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Our services are provided “as is” and may be subject to interruptions, errors, or delays. We reserve the right to modify or discontinue the app at any time without notice.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Amendments',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'We may update these terms from time to time. Users are encouraged to review this page regularly to stay informed of any changes.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'If you have any questions about these terms, please contact us at support@[yourbankname].com.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
