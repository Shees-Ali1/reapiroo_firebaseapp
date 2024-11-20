import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';

class CustomerrBidBottomSheet extends StatelessWidget {
  final String comingFrom;

  const CustomerrBidBottomSheet({super.key, required this.comingFrom});

  @override
  Widget build(BuildContext context) {
    final TextEditingController bidController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.w),
          topRight: Radius.circular(40.w),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Bid",
              style: jost600(32.sp, AppColors.primary),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter your bid amount",
                style: jost600(16.sp, AppColors.primary),
              ),
            ),
            SizedBox(height: 15.h),
            CustomInputField(
              controller: bidController,
              label: "Your offer",
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Add a message (optional)",
                style: jost600(16.sp, AppColors.primary),
              ),
            ),
            SizedBox(height: 15.h),
            CustomInputField(
              controller: messageController,
              label: "Your message",
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 21.h),
            CustomElevatedButton(
              text: comingFrom == "customer" ? "Offer" : "Send Bid",
              fontSize: 16.sp,
              onPressed: () async {
                final String bidAmount = bidController.text.trim();
                final String message = messageController.text.trim();

                final String? currentUserId = auth.currentUser?.uid;

                if (currentUserId == null) {
                  Get.snackbar("Error", "User not logged in.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }

                if (bidAmount.isEmpty) {
                  Get.snackbar("Error", "Bid amount cannot be empty.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                  return;
                }

                try {
                  // Query user's bids
                  final QuerySnapshot querySnapshot = await firestore
                      .collection('bids')
                      .where('customerId', isEqualTo: currentUserId)
                      .get();

                  if (querySnapshot.docs.isEmpty) {
                    Get.snackbar("Error", "No bids found for the current user.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                    return;
                  }

                  // Get bidderId from the first matching bid
                  final DocumentSnapshot bidDocument = querySnapshot.docs.first;
                  final String matchingBidderId =
                  (bidDocument.data() as Map<String, dynamic>)['bidderId'];

                  // Add bid to "Bid Notifications"
                  await firestore.collection('Bid Notifications').add({
                    'bidAmount': bidAmount,
                    'message': message,
                    'bidderId': matchingBidderId,
                    'bidFrom': comingFrom,
                    'timestamp': FieldValue.serverTimestamp(),
                    'customerUid': currentUserId,
                  });

                  // Success Snackbar
                  Get.snackbar("Success", "Your offer has been sent successfully!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white);

                  // Close the bottom sheet
                  Get.back();
                } catch (e) {
                  Get.snackbar("Error", "Failed to send bid: ${e.toString()}",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
            ),
            SizedBox(height: 29.h),
          ],
        ),
      ),
    );
  }
}