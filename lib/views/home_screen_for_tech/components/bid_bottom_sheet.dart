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
  final String title;
  final String id;

  const BidBottomSheet({
    super.key,
    required this.userUid,
    required this.title,
    required this.id,
  });

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
        child: SingleChildScrollView( // Wrap the content with SingleChildScrollView
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Text("Bid", style: jost600(32.sp, AppColors.primary)),
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
              SizedBox(height: 21.h),
              CustomElevatedButton(
                text: "Send Bid",
                fontSize: 16.sp,
                onPressed: () async {
                  final String bidAmount = bidController.text.trim();
                  final String currentUserUid =
                      FirebaseAuth.instance.currentUser?.uid ?? ""; // Get current user UID

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

                    // Validate the task exists
                    final QuerySnapshot taskSnapshot = await firestore
                        .collection('tasks')
                        .where('userUid', isEqualTo: userUid)
                        .get();

                    if (taskSnapshot.docs.isEmpty) {
                      Get.snackbar("Error", "Task not found.");
                      return;
                    }

                    final String taskId = taskSnapshot.docs.first.id;

                    // Create a new document in the bids collection
                    await firestore.collection('bids').add({
                      'bidAmount': bidAmount,
                      'bidderId': currentUserUid,
                      'customerId': userUid,
                      'firstName': firstName,
                      'taskId': id,
                      'title': title,
                      'timestamp': FieldValue.serverTimestamp(),
                    });

                    Get.snackbar("Success", "Bid sent successfully!");
                    Navigator.of(context).pop();
                  } catch (e) {
                    Get.snackbar("Error", "Failed to send bid: $e");
                  }
                },
              ),
              SizedBox(height: 29.h),
            ],
          ),
        ),
      ),
    );
  }
}
