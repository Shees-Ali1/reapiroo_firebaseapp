import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../const/color.dart';
import '../../widgets/app_bars.dart';


class Privacypolicy extends StatefulWidget {
  const Privacypolicy({super.key});

  @override
  State<Privacypolicy> createState() => _PrivacypolicyState();
}

class _PrivacypolicyState extends State<Privacypolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
     appBar: MyAppBar(
      isMenu: false,
      isNotification: false,
      isTitle: true,
      isSecondIcon: false,
      title: 'Privacy Policy',
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
              'Privacy Policy',
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
              'At [Your Bank Name], protecting your privacy is of utmost importance to us. '
                  'This Privacy Policy explains how we collect, use, and safeguard your information '
                  'when you use our application.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Information We Collect',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '1. **Personal Information**: Name, email, phone number, and address.\n'
                  '2. **Financial Information**: Bank account details and transaction history.\n'
                  '3. **Device Information**: IP address, device type, and app usage data.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'How We Use Your Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '1. To provide and manage banking services.\n'
                  '2. To enhance user experience through app improvements.\n'
                  '3. To comply with legal and regulatory requirements.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'How We Protect Your Data',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'We implement industry-standard security measures to protect your information, including:\n'
                  '1. Secure encryption for data transmission.\n'
                  '2. Regular security audits and updates.\n'
                  '3. Restricted access to sensitive data.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Your Rights',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '1. You have the right to access and update your personal information.\n'
                  '2. You can request the deletion of your data in certain circumstances.\n'
                  '3. You have the right to withdraw consent for data processing at any time.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Changes to This Policy',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'We may update this Privacy Policy periodically. Users will be notified of any significant changes.',
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
              'For any questions or concerns, please contact us at support@[yourbankname].com.',
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
