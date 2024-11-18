import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:repairoo/const/color.dart';
import 'package:repairoo/const/text_styles.dart';
import 'package:repairoo/widgets/custom_button.dart';
import 'package:repairoo/widgets/custom_input_fields.dart';

import 'customer_bid.dart';

class BidBottomSheet extends StatelessWidget {
  const BidBottomSheet({super.key, required this.comingFrom});

  final String comingFrom;

  @override
  Widget build(BuildContext context) {
    final TextEditingController bidController = TextEditingController();
    final TextEditingController messageController = TextEditingController(); // Controller for the message
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

                  // Fetch the current user's UID from FirebaseAuth
                  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

                  if (currentUserId == null) {
                    Get.snackbar("Error", "User not logged in.");
                    return;
                  }

                  if (bidAmount.isEmpty) {
                    Get.snackbar("Error", "Bid amount cannot be empty.");
                    return;
                  }

                  try {
                    // Query the 'tasks' collection where 'userUid' matches the current user's UID
                    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                        .collection('tasks')
                        .where('userUid', isEqualTo: currentUserId)
                        .get();

                    if (querySnapshot.docs.isEmpty) {
                      Get.snackbar("Error", "No tasks found for the current user.");
                      return;
                    }

                    String? matchingBidderId;

                    // Loop through the matching documents
                    for (var doc in querySnapshot.docs) {
                      final data = doc.data() as Map<String, dynamic>;

                      // Search for bidderId in each key that contains a list
                      for (var entry in data.entries) {
                        if (entry.value is List) {
                          final List<dynamic> bids = entry.value;

                          for (var bid in bids) {
                            if (bid is Map<String, dynamic> && bid.containsKey('bidderId')) {
                              matchingBidderId = bid['bidderId'];
                              break;
                            }
                          }
                        }

                        // Break the loop if a matching bidderId is found
                        if (matchingBidderId != null) break;
                      }

                      // Stop if a matching bidderId is found
                      if (matchingBidderId != null) break;
                    }

                    if (matchingBidderId == null) {
                      Get.snackbar("Error", "No bidderId found for the current user.");
                      return;
                    }

                    // Add bid to "Bid Notifications" collection
                    await FirebaseFirestore.instance.collection('Bid Notifications').add({
                      'bidAmount': bidAmount,
                      'message': message,
                      'bidderId': matchingBidderId,
                      'bidFrom': comingFrom,
                      'timestamp': FieldValue.serverTimestamp(),
                      'customerUid': currentUserId,  // Add current user's UID
                    });

                    Get.snackbar("Success", "Bid sent successfully!");
                    Get.back();

                    if (comingFrom == "tech") {
                      Get.bottomSheet(
                        isScrollControlled: true,
                        isDismissible: true,
                        enableDrag: true,
                        const CustomerBidBottomSheet(),
                      );
                    }
                  } catch (e) {
                    Get.snackbar("Error", "Failed to send bid: $e");
                  }
                }
            ),
            SizedBox(height: 29.h),
          ],
        ),
      ),
    );
  }
}
