import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';

class BidBottomSheet extends StatelessWidget {
  final String userUid;

  const BidBottomSheet({super.key, required this.userUid});

  @override
  Widget build(BuildContext context) {
    final TextEditingController bidController = TextEditingController();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
            Text("Bid", style: jost600(32.sp, AppColors.primary)),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Enter your bid amount", style: jost600(16.sp, AppColors.primary)),
            ),
            SizedBox(height: 15.h),
            CustomInputField(
              controller: bidController,
              label: "Your offer",
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 21.h),
            CustomElevatedButton(
              text: "Send Bid",
              fontSize: 16.sp,
              onPressed: () async {
                final String bidAmount = bidController.text.trim();
                final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? ""; // Get current user UID

                if (bidAmount.isEmpty) {
                  Get.snackbar("Error", "Bid amount cannot be empty.");
                  return;
                }

                try {
                  // Fetch the current user's first name from Firestore
                  final DocumentSnapshot userSnapshot = await firestore
                      .collection('tech_users')
                      .doc(currentUserUid)
                      .get();

                  if (!userSnapshot.exists) {
                    Get.snackbar("Error", "User data not found.");
                    return;
                  }

                  final String firstName = userSnapshot['firstName'] ?? "Unknown";

                  // Locate the Firestore document using userUid
                  final QuerySnapshot taskSnapshot = await firestore
                      .collection('tasks')
                      .where('userUid', isEqualTo: userUid)
                      .get();

                  if (taskSnapshot.docs.isNotEmpty) {
                    final docRef = taskSnapshot.docs.first.reference;

                    // Add the bid to the relevant task field (e.g., "TV Mounting")
                    await docRef.update({
                      'TV Mounting': FieldValue.arrayUnion([
                        {
                          'bid': bidAmount,
                          'bidderId': currentUserUid, // Current user making the bid
                          'firstName': firstName,    // Include bidder's first name
                        }
                      ]),
                    });

                    Get.snackbar("Success", "Bid sent successfully!");
                    Navigator.of(context).pop();
                  } else {
                    Get.snackbar("Error", "Task not found.");
                  }
                } catch (e) {
                  Get.snackbar("Error", "Failed to send bid: $e");
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
