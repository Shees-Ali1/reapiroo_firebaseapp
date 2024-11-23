import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../const/color.dart';
import '../../widgets/app_bars.dart';



class RefundPolicy extends StatefulWidget {
  const RefundPolicy({super.key});

  @override
  State<RefundPolicy> createState() => _RefundPolicyState();
}

class _RefundPolicyState extends State<RefundPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        isMenu: false,
        isNotification: false,
        isTitle: true,
        isSecondIcon: false,
        title: 'Refund Policy',
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
              'Refund Policy',
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
              'At [Your Bank Name], customer satisfaction is our priority. This refund policy outlines the terms and conditions for refunds on transactions or services provided through our application.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Eligibility for Refunds',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '1. Refunds are applicable only in cases of unauthorized transactions or system errors.\n'
                  '2. Requests must be submitted within 14 days of the transaction date.\n'
                  '3. All refund requests are subject to verification and approval.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'How to Request a Refund',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '1. Navigate to the “Support” section in the app.\n'
                  '2. Select “Refund Request” and fill out the required details.\n'
                  '3. Attach any supporting documents (if applicable).',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Processing Time',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Refunds are processed within 7-10 business days after approval. '
                  'You will receive a confirmation email once the refund has been initiated.',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'For any questions or concerns, please contact our support team at support@[yourbankname].com.',
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
